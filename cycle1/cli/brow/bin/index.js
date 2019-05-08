#!/usr/bin/env node

const program = require('commander')

program
  .command('install', 'Install packages with brow')
  .option('-p, --project-address <project-address>', 'Apply whatever command follows to this project')
  .parse(process.argv)
