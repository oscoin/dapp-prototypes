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
      console.log('+ elm@<HASH> -> ' + `${project}`)
      console.log('+ react@<HASH> -> ' + `${project}`)
      console.log('+ styled-components@<HASH> -> ' + `${project}`)
      console.log('Calculating contributions...')
    })
    sleep(2500).then(() => {
      console.log('...')
      console.log(' ')
      console.log('This is the checkpoint you are about to submit:')
      console.log('    number: 0')
      console.log('    hash: bcf789a')
      console.log('    new_dependencies:')
      console.log('      elm@<HASH>, react@<HASH>, styled-components@<HASH>')
      console.log('    new_contributions:')
      console.log('      ...')
      console.log(' ')
      console.log('    transaction fee: 0.1 osc')
      console.log(' ')
      inquirer
	    .prompt({
          type: 'confirm',
          name: 'authorize',
          message: 'Do you want to authorize this transaction [Y/n]?',
          default: false
        }).then(function (answer) {
          console.log('Your checkpoint was submitted and is being confirmed through the network.')
          console.log('See your project here: oscoin.io/projects/' + `${project}`)
        })
    })

  })
  .parse(process.argv)


















