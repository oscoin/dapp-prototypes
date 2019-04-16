console.log('oscoin wallet | background | init')

browser.browserAction.setIcon({ path: "icons/wallet-error.svg" })
  .then(() => {
    console.log('icon success')
  }, () => {
    cosnole.log('icon fail')
  })
  .catch(err => {
    console.error(err)
  })

let currentTab = undefined;
// Non-present value must be `null` for Elm to accept it as a Maybe.
let keyPair = null;

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

    // A key pair is required to continue with the current operation on the
    // page.
    if (msg.type === 'requireKeyPair') {
      currentTab = sender.tab;

      browser.windows.create({
        type: 'popup',
        url: 'wallet-popup.html',
        height: 534,
        width: 420
      }).then(windowInfo => {
        console.log('popup window info', windowInfo)
      })
    }
  }
})

function createKeyPair(id) {
  keyPair = id

  return id
}

function getKeyPair() {
  return keyPair
}

function getCurrentTab() {
  return currentTab
}

function keyPairSetupComplete() {
    browser.tabs.sendMessage(getCurrentTab().id, {
      direction: 'wallet-to-page',
      type: 'keyPairCreated',
      id: getKeyPair(),
    })
}
