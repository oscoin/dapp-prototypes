window.addEventListener('DOMContentLoaded', _ => {
  console.log(document.getElementById('wallet') ? 'webext' : null)

  var app = Elm.Main.init({
    flags: {
      keyPair: null,
      wallet: document.getElementById('wallet') ? 'webext' : null,
    },
    node: document.getElementById('app'),
  })

  // Check if wallet is installed.
  window.postMessage({
    direction: 'page-to-wallet',
    type: 'getKeyPair',
  })

  app.ports.requireKeyPair.subscribe(function() {
    console.log('ports.requireKeyPair')

    window.postMessage({
      direction: 'page-to-wallet',
      type: 'requireKeyPair',
    })
  })

  // Listen for transcation that need to be signed by the wallet.
  app.ports.signTransaction.subscribe(function(transaction) {
    console.log('ports.signTransaction', transaction)

    window.postMessage({
      direction: 'page-to-wallet',
      type: 'signTransaction',
      transaction: transaction,
    })
  })

  window.addEventListener('message', function(event) {
    console.log('window.message', event)

    let msg = event.data

    console.log('window.message.msg', msg)

    if (msg.direction === 'wallet-to-page') {
      // Web extension wallet is signaling presence.
      if (msg.type === 'walletPresent') {
        app.ports.walletWebExtPresent.send(null)

        // Fetch key pair on app startup to reflect state of the wallet.
        window.postMessage({
          direction: 'page-to-wallet',
          type: 'getKeyPair',
        })
      }

      // A new key pair was created.
      if (msg.type === 'keyPairCreated') {
        app.ports.keyPairCreated.send(msg.id)
      }

      // An existing key pair was fetched.
      if (msg.type === 'keyPairFetched' && msg.id && msg.id !== null) {
        app.ports.keyPairFetched.send(msg.id)
      }
    }
  })
})
