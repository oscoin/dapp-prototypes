#!/usr/bin/env node

const program = require('commander')

program
  .command('setup', 'Set up the cli to interact with the network')
  .command('checkpoint', 'Sends the oscoin network the dependecies and the contributors of this project and allow the network to calculate the osrank of the project')
  .parse(process.argv)
