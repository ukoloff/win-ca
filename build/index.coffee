###
Build tasks
###
paths = require './paths'
mkdir = require 'make-dir'

mkdir paths.dst
.then ->
  require "./dst"
.catch (err)->
  console.error err
  process.exit 1
