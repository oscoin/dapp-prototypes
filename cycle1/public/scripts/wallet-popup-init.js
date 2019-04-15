(function() {
  console.log('oscoin wallet | popup | init')

  // Get current tab from background script for message passing of feedback
  // after setup completion.
  let background = browser.extension.getBackgroundPage()
  let keyPair = background.getKeyPair()

  // Init elm ui.
  var popup = Elm.WalletPopup.init({
    flags: keyPair,
    node: document.getElementById('popup')
  })

  // Listen to keyPairCreate events and signal the wallet to create one with the
  // given identifier.
  popup.ports.keyPairCreate.subscribe(function(id) {
    console.log('ports.keyPairCreate', id)

    popup.ports.keyPairCreated.send(background.createKeyPair(id))
  })

  // Listen to key pair setup events and relay back to the tab.
  popup.ports.keyPairSetupComplete.subscribe(function() {
    console.log('ports.keyPairSetupComplete')

    browser.runtime.sendMessage({
      type: 'keySetupComplete'
    })

    window.close()
  })
})();
