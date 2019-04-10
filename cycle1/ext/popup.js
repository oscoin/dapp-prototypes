(() => {
  console.log('oscoin key manager | popup | init')

  document.addEventListener('click', event => {
    if (event.target.id !== 'done') {
      return
    }
    console.log(event)

    browser.tabs.query({ active: true, currentWindow: true })
      .then(tabs => {
        console.log('tabs.query', tabs)

        browser.tabs.sendMessage(tabs[0].id, {
          msg: 'hello from the popup'
        })
        window.close()
      }, err => {
        console.error('tabs.query', err)
      })
  })
  // .addEventListener('click', event => {
  //   event.preventDefault()

  //   console.log(event)

  //   browser.tabs.query({ active: true, currentWindow: true })
  //     .then(tabs => {
  //       console.log('tabs.query', tabs)

  //       browser.tabs.sendMessage(tabs[0].id, {
  //         msg: 'hello from the popup'
  //       })
  //     }, err => {
  //       console.error('tabs.query', err)
  //     })
  // })
})();
