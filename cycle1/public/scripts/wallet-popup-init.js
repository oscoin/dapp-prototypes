(function() {
  console.log('oscoin wallet | popup | init')

  // Init elm ui.
  var popup = Elm.WalletPopup.init({
    node: document.getElementById('popup')
  })

  // Listen to keyPairCreate events and signal the wallet to create one with the
  // given identifier.
  popup.ports.keyPairCreate.subscribe(function(id) {
    console.log('ports.keyPairCreate', id)

    popup.ports.keyPairCreated.send(id)
  })

  // Get current tab from background script for message passing of feedback
  // after setup completion.
  // let background = browser.extension.getBackgroundPage()
  // let currentTab = background.getCurrentTab()

  // Listen to key pair setup events and relay back to the tab.
  popup.ports.keyPairSetupComplete.subscribe(function() {
    console.log('ports.keyPairSetupComplete')
    // browser.tabs.sendMessage(currentTab.id, {
    //   type: 'keySetupComplete'
    // })
    // window.close()
  })
})();
