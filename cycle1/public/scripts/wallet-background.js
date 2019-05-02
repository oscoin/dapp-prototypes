import { encode } from './base32.js'

console.log('oscoin wallet | background | init')

console.log(nacl.sign.keyPair())
console.log(encode(nacl.sign.keyPair().publicKey))

// Set the wallet icon dynamically.
browser.browserAction
  .setIcon({ path: 'icons/wallet-error.svg' })
  .then(
    () => {
      console.log('icon success')
    },
    () => {
      cosnole.log('icon fail')
    }
  )
  .catch(err => {
    console.error(err)
  })

let currentTab = undefined
// Non-present value must be `null` for Elm to accept it as a Maybe.
// let keyPair = null
let keyPair = {
  id: 'fakeid',
  pubKey: encode(nacl.sign.keyPair().publicKey),
}
let transaction = null

browser.runtime.onMessage.addListener((msg, sender) => {
  console.log(msg, sender)

  if (msg.direction === 'page-to-wallet') {
    // The page requests wallet information to see if the wallet is installed at
    // all.
    if (msg.type === 'getWallet') {
      browser.tabs.sendMessage(sender.tab.id, {
        direction: 'wallet-to-page',
        type: 'walletPresent',
      })
    }
    // The page wants to fetch a key pair if existent.
    if (msg.type === 'getKeyPair') {
      browser.tabs.sendMessage(sender.tab.id, {
        direction: 'wallet-to-page',
        type: 'keyPairFetched',
        id: getKeyPair(),
      })
    }

    // Present the transaction to sign to the user.
    if (msg.type === 'signTransaction') {
      currentTab = sender.tab
      // transaction = testTransaction()

      let tx = msg.transaction
      let enc = new TextEncoder()
      tx.hash = new TextDecoder().decode(
        nacl.hash(enc.encode(JSON.stringify(tx)))
      )

      transaction = tx

      browser.windows
        .create({
          type: 'popup',
          url: 'wallet-popup.html#sign',
          height: 534,
          width: 420,
        })
        .then(windowInfo => {
          console.log('popup window info', windowInfo)
        })
    }

    // A key pair is required to continue with the current operation on the
    // page.
    if (msg.type === 'requireKeyPair') {
      currentTab = sender.tab

      browser.windows
        .create({
          type: 'popup',
          url: 'wallet-popup.html#keys',
          height: 534,
          width: 420,
        })
        .then(windowInfo => {
          console.log('popup window info', windowInfo)
        })
    }
  }
})

function getCurrentTab() {
  return currentTab
}

function createKeyPair(id) {
  keyPair = {
    id: id,
    pubKey: encode(nacl.sign.keyPair().publicKey),
  }

  return keyPair
}

function getKeyPair() {
  return keyPair
}

function keyPairSetupComplete() {
  browser.tabs.sendMessage(getCurrentTab().id, {
    direction: 'wallet-to-page',
    type: 'keyPairCreated',
    id: getKeyPair(),
  })
}

function getTransaction() {
  return transaction
}

// Public API for popup script.
window.createKeyPair = createKeyPair
window.getKeyPair = getKeyPair
window.keyPairSetupComplete = keyPairSetupComplete
window.getTransaction = getTransaction

// Helpers

function testTransaction() {
  let projectAddr = 'cabal#3gd815h0c6x84hj03gd815h0f3gd815h0c6x84hj03gd'
  let tx = {
    fee: 1038,
    messages: [
      { type: 'project-registration', address: projectAddr },
      {
        type: 'update-contract-rule',
        address: projectAddr,
        ruleChange: { type: 'reward', old: 'EqualDependency', new: 'Burn' },
      },
      {
        type: 'update-contract-rule',
        address: projectAddr,
        ruleChange: {
          type: 'donation',
          old: 'FundSaving',
          new: 'EqualMaintainer',
        },
      },
      {
        type: 'update-contract-rule',
        address: projectAddr,
        ruleChange: {
          type: 'role',
          old: 'MaintainerSingleSigner',
          new: 'MaintainerMultiSig',
        },
      },
    ],
  }

  let enc = new TextEncoder()
  tx.hash = new TextDecoder().decode(nacl.hash(enc.encode(JSON.stringify(tx))))

  return tx
}
