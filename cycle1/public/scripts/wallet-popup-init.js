(function() {
  console.log('oscoin wallet | popup | init')

  // Init elm ui.
  var popup = Elm.WalletPopup.init({
    node: document.getElementById('popup')
  })

  // Get current tab from background script for message passing of feedback
  // after setup completion.
  let background = browser.extension.getBackgroundPage()
  let currentTab = background.getCurrentTab()

  // Listen to key pair setup events and relay back to the tab.
  popup.ports.keyPairSetupComplete.subscribe(function() {
    browser.tabs.sendMessage(currentTab.id, {
      type: 'keySetupComplete'
    })
    window.close()
  })
})();
