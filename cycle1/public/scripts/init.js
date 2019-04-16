(function() {
  var app = Elm.Main.init({
    flags: null,
    node: document.getElementById('app')
  });

  // Fetch key pair on app startup to reflect state of the wallet.
  window.postMessage({
    direction: 'page-to-extension',
    type: 'getKeyPair'
  });

  app.ports.requireKeyPair.subscribe(function () {
    console.log('ports.requireKeyPair')

    window.postMessage({
      direction: 'page-to-extension',
      type: 'requireKeyPair'
    });
  });

  window.addEventListener('message', function (event) {
    console.log('window.message', event);

    let msg = event.data;

    console.log('window.message.msg', msg)

    if (msg.direction === 'extension-to-page') {
      // A new key pair was created.
      if (msg.type === 'keyPairCreated') {
        app.ports.keyPairCreated.send(msg.id);
      }

      // An existing key pair was fetched.
      if (msg.type === 'keyPairFetched' && msg.id && msg.id !== null) {
        app.ports.keyPairFetched.send(msg.id);
      }
    }
  })
})();
