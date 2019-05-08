#!/usr/bin/env node

const inquirer = require('inquirer')
const program = require('commander')

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

program
  .action(function () {
    console.log('Welcome to oscoin.')
    console.log('To be able to use your keys in the terminal we need your 16 word passphrase.')
    inquirer
	    .prompt({
        type: 'input',
        name: 'passphrose',
        message: 'Please enter your 16 word passphrase:',
      }).then(function (answer) {
        console.log('Correct.')
        sleep(500).then(() => {
          console.log('Your key is active, you can now use the oscoin-cli. Run “osc --help” to get started.')
        })
      })

  })
  .parse(process.argv)
