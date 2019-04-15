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

  if (msg.direction === 'page-to-extension' &&
    msg.type === 'keySetup') {

    currentTab = sender.tab;

    browser.windows.create({
      type: 'popup',
      url: 'wallet-popup.html',
      height: 534,
      width: 420
    }).then(windowInfo => {
      console.log('popup window info', windowInfo)

      // browser.runtime.sendMessage(
    })
  }

  if (msg.type === 'keySetupComplete') {
    browser.tabs.sendMessage(getCurrentTab().id, {
      direction: 'extension-to-page',
      type: 'keySetupComplete'
    })
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
