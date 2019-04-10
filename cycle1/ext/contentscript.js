(function () {
  console.log('oscoin key manager | contentscript | init')

  browser.runtime.onMessage.addListener((message) => {
    console.log('browser.runtime.onMessage', message)
    window.postMessage(message, '*')
  })
})();
