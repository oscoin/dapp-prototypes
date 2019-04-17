(function() {
  console.log('oscoin wallet | popup | init', window.location)

  // Get background object to call API on it and current key pair if exists.
  let background = browser.extension.getBackgroundPage()
  let maybeKeyPair = background.getKeyPair() || null
  let maybeTransaction = background.getTransaction() || null

  // Init elm ui.
  var popup = Elm.WalletPopup.init({
    flags: {
      maybeKeyPair,
      maybeTransaction,
      location: {
        hash: window.location.hash,
        path: window.location.pathname
      } 
    },
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

    // Signal that key pair setup completed in the popup and the it will close.
    background.keyPairSetupComplete()
    window.close()
  })
})();
