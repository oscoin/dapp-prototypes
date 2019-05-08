#!/usr/bin/env node

const program = require('commander')

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

program
  .arguments('<package>')
  .usage('<package> [options]')
  .action(function (browPackage, cmd) {
    console.log('==> Installing ' + `${browPackage}`)
    console.log('==> Downloading https://homebrew.bintray.com/bottles/oscoin-cli-11.1.mojave.bottle.tar.gz')
    sleep(1500).then(() => {
      console.log('==> Pouring oscoin-cli-11.1.mojave.bottle.tar.gz')
      console.log('==> Caveats')
      console.log('Great success!!!')
      console.log(' ')
    })
    sleep(2000).then(() => {
      console.log('To see if oscoin is installed properly, run:')
      console.log('  osc version')
      console.log(' ')
      console.log('To do your first checkpoint run:')
      console.log('  osc checkpoint <project-address>')
      console.log(' ')
    })
    sleep(2500).then(() => {
      console.log('==> Summary')
      console.log('🍺  /usr/local/Cellar/oscoin/11.1: 3,548 files, 40.3MB')
    })

  })
  .parse(process.argv)
