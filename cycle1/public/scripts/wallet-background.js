import { encode } from './base32.js'

console.log('oscoin wallet | background | init')

console.log(nacl.sign.keyPair())
console.log(encode(nacl.sign.keyPair().publicKey))

let currentTab = undefined
// Non-present value must be `null` for Elm to accept it as a Maybe.
let keyPair = null
// let keyPair = {
//   id: 'fakeid',
//   pubKey: encode(nacl.sign.keyPair().publicKey),
// }
let projects = {}
let transactions = {}
let progress = {}

if (keyPair !== null) {
  setActiveIcon()
}

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

    // Return all stored transactions.
    if (msg.type == 'fetchTransactions') {
      browser.tabs.sendMessage(sender.tab.id, {
        direction: 'wallet-to-page',
        type: 'transactionsFetched',
        transactions: Object.keys(transactions).map(hash => transactions[hash]),
      })
    }

    // Present the transaction to sign to the user.
    if (msg.type === 'signTransaction') {
      currentTab = sender.tab

      let tx = msg.transaction

      transactions[tx.hash] = tx

      browser.windows
        .create({
          type: 'popup',
          url: `wallet-popup-sign.html#${tx.hash}`,
          height: 640,
          width: 560,
        })
        .then(windowInfo => {
          console.log('popup window info', windowInfo)
        })
    }

    // Cache newly crated projects. Save the F5!
    if (msg.type === 'storeProject') {
      let project = msg.project

      projects[project.address] = project
    }

    // A project that is stored is requested.
    if (msg.type === 'requestProject') {
      browser.tabs.sendMessage(sender.tab.id, {
        direction: 'wallet-to-page',
        type: 'projectFetched',
        project: getProject(msg.address),
        projects: projects,
      })
    }

    // A key pair is required to continue with the current operation on the
    // page.
    if (msg.type === 'requireKeyPair') {
      currentTab = sender.tab

      if (getKeyPair() !== null) {
        keyPairSetupComplete()

        return
      }

      browser.windows
        .create({
          type: 'popup',
          url: 'wallet-popup.html#keys',
          height: 640,
          width: 560,
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
  setActiveIcon()

  if (getCurrentTab() === undefined) {
    return
  }

  browser.tabs.sendMessage(getCurrentTab().id, {
    direction: 'wallet-to-page',
    type: 'keyPairCreated',
    id: getKeyPair(),
  })
}

function getProject(address) {
  return projects[address] || null
}

function getTransaction(hash) {
  console.log(transactions[hash])
  return transactions[hash]
}

function rejectTransaction(hash) {
  console.log('rejectTransaction.hash', hash)

  let tx = transactions[hash]

  tx.state = { type: 'rejected' }

  transactions[hash] = tx

  browser.tabs.sendMessage(getCurrentTab().id, {
    direction: 'wallet-to-page',
    type: 'transactionRejected',
    hash: hash,
  })
}

function signTransaction(hash, keyPairId) {
  console.log('signTransaction.hash', hash)
  console.log('signTransaction.keyPairId', keyPairId)

  let tx = transactions[hash]

  tx.state = { type: 'unconfirmed', blocks: 0 }

  transactions[hash] = tx

  browser.tabs.sendMessage(getCurrentTab().id, {
    direction: 'wallet-to-page',
    type: 'transactionAuthorized',
    hash: hash,
    keyPairId: getKeyPair().id,
  })

  progress[hash] = setInterval(progressTransaction(hash), 10000)
}

// Public API for popup script.
window.createKeyPair = createKeyPair
window.getKeyPair = getKeyPair
window.keyPairSetupComplete = keyPairSetupComplete
window.getTransaction = getTransaction
window.rejectTransaction = rejectTransaction
window.signTransaction = signTransaction

// TRANSACTIONS

function progressTransaction(hash) {
  return function() {
    let tx = transactions[hash]
    let blocks = tx.state.blocks
    let newBlocks = blocks + 1
    let state = { type: 'unconfirmed', blocks: newBlocks }

    if (blocks === 6) {
      state.type = 'confirmed'

      clearInterval(progress[hash])
    }

    tx.state = state
    transactions[hash] = tx

    browser.tabs.sendMessage(getCurrentTab().id, {
      direction: 'wallet-to-page',
      type: 'transactionProgress',
      transaction: tx,
    })
  }
}

// Helpers

function setActiveIcon() {
  // Set the wallet icon dynamically.
  browser.browserAction
    .setIcon({ path: 'icons/wallet-active.svg' })
    .then(
      () => {
        console.log('icon success')
      },
      () => {
        console.log('icon fail')
      }
    )
    .catch(err => {
      console.error(err)
    })
}

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
