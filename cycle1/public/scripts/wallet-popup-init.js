(function() {
  console.log('oscoin wallet | popup | init')

  // Get background object to call API on it and current key pair if exists.
  let background = browser.extension.getBackgroundPage()
  let maybeKeyPair = background.getKeyPair()
  let maybeTransaction = background.getTransaction()

  // Init elm uid#1z1qqm6d5yb3wqngb9pfhjwf6yuhjj6x3f89prxepuinae18mr85.
  var popup = Elm.WalletPopup.init({
    flags: {
      maybeKeyPair,
      maybeTransaction,
      location: {
        hash: window.location.hash,
        path: window.location.pathname,
      },
    },
    node: document.getElementById('popup'),
  })

  // Listen to authorizeTransaction events and signal the wallet that the user
  // wants to go forward with signing.
  popup.ports.authorizeTransaction.subscribe(function(payload) {
    console.log('ports.authorizeTransaction', payload)

    // Signal to sign the transaction and close.
    background.signTransaction(payload.hash, payload.keyPairId)
    window.close()
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

    // Signal that key pair setup completed in the popup and then close.
    background.keyPairSetupComplete()
    window.close()
  })
})()
