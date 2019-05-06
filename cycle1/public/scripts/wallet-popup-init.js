(function() {
  console.log('oscoin wallet | popup | init')

  // Get background object to call API on it and current key pair if exists.
  let background = browser.extension.getBackgroundPage()
  let maybeKeyPair = background.getKeyPair()
  let maybeTransaction = null
  let page = 'keys'

  if (location.pathname === '/wallet-popup-sign.html') {
    page = 'sign'
    maybeTransaction = background.getTransaction(location.hash.substring(1))
  }

  // Init elm uid#1z1qqm6d5yb3wqngb9pfhjwf6yuhjj6x3f89prxepuinae18mr85.
  var popup = Elm.WalletPopup.init({
    flags: {
      maybeKeyPair,
      maybeTransaction,
      page: page,
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

  // Listen to rejectTransaction events and signal the wallet that the user
  // doesn't want to sign this transaction.
  popup.ports.rejectTransaction.subscribe(function(hash) {
    console.log('ports.rejectTransaction', hash)

    // Signal to reject the transaction and close.
    background.rejectTransaction(hash)
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
