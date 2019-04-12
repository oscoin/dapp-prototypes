(function () {
  console.log('oscoin key manager | contentscript | init')

  // Send messages from the extension to the page.
  browser.runtime.onMessage.addListener((msg) => {
    console.log('browser.runtime.onMessage', msg)

    msg.direction = 'extension-to-page'

    window.postMessage(msg, '*')
  })

  // Send messages from the page to the extension.
  window.addEventListener('message', event => {
    let msg = event.data;

    if (msg.direction === 'page-to-extension') {
      browser.runtime.sendMessage(msg)
        .then(() => {
          console.log(arguments)
          console.log('message sent to extension')
        }, err => {
          console.log(arguments)
          console.error('message to extension failed', err)
        })
    }
  })
})();
