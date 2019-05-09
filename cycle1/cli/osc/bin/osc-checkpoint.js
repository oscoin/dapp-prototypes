#!/usr/bin/env node
const inquirer = require('inquirer')
const program = require('commander')

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

program
  .arguments('<package>')
  .usage('<package> [options]')
  .action(function (project, cmd) {
    console.log('Wasn\'t able to find prior checkpoint, starting fresh.')
    console.log('Reading package.json...')
    sleep(1000).then(() => {
      console.log('Detected 3 dependencies.')
      console.log('  + elm@1f4b321 -> ' + `${project}`)
      console.log('  + react@7b3519a -> ' + `${project}`)
      console.log('  + styled-components@90b4524 -> ' + `${project}`)
      console.log('Calculating contributions...')
    })
    sleep(1800).then(() => {
      console.log('Detected 19 new contributions.')
      console.log('  + Julien Donck <donckjulien@gmail.com> -> 12 new commits')
      console.log('  + Alexander Simmerl <xla@gmail.com> -> 5 new commits')
      console.log('  + Cory Levinson <corlock@gmail.com> -> 2 new commits')
    })
    sleep(2500).then(() => {
      console.log(' ')
      console.log('This is the checkpoint you are about to submit:')
      console.log(' ')
      console.log('    number: 0')
      console.log('    hash: bcf789a')
      console.log('    new_dependencies:')
      console.log('      elm@1f4b321, react@7b3519a, styled-components@90b4524')
      console.log('    new_contributions:')
      console.log('      19 new contributions by Julien Donck, Alexander Simmerl and Cory Levinson')
      console.log(' ')
      console.log('    transaction fee: 0.1 osc')
      console.log(' ')
      inquirer
	    .prompt({
          type: 'confirm',
          name: 'authorize',
          message: 'Do you want to authorize this transaction?',
          default: false
        }).then(function (answer) {
          console.log('Your checkpoint was submitted and is being confirmed through the network.')
          console.log(' ')
          console.log('See your project here: oscoin.io/projects/' + `${project}`)
          console.log(' ')
        })
    })

  })
  .parse(process.argv)


















