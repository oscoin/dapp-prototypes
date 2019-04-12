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

browser.runtime.onMessage.addListener((msg, sender) => {
  console.log(msg, sender)

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
})

function getCurrentTab() {
  return currentTab
}
