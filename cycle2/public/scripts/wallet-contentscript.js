(function(window) {
  console.log('oscoin wallet | contentscript | init')

  window.addEventListener('DOMContentLoaded', event => {
    let app = document.getElementById('app')

    let marker = document.createElement('div')
    marker.setAttribute('id', 'wallet')

    document.body.insertBefore(marker, app)
  })

  // Send messages from the extension to the page.
  browser.runtime.onMessage.addListener(msg => {
    console.log('browser.runtime.onMessage', msg)

    if ((msg.direction = 'wallet-to-page')) {
      window.postMessage(msg, '*')
    }
  })

  // Send messages from the page to the extension.
  window.addEventListener('message', event => {
    let msg = event.data

    console.log('page-to-wallet', msg)

    if (msg.direction === 'page-to-wallet') {
      browser.runtime.sendMessage(msg).then(
        () => {
          console.log('message sent to extension')
        },
        err => {
          console.error('message to extension failed', err)
        }
      )
    }
  })
})(window)
