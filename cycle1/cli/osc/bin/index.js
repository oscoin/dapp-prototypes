#!/usr/bin/env node

const program = require('commander')

program
  .command('setup', 'Set up the cli to interact with the network')
  .command('checkpoint', 'Set up the cli to interact with the network')
  .parse(process.argv)
