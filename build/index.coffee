###
Build tasks
###
paths = require './paths'
mkdir = require '../src/mkdir'

mkdir paths.dst, ->
  require "./dst"
