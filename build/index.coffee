###
Build tasks
###
paths = require './paths'
mkdir = require '../src/mkdir'

for z in 'top dst'.split ' '
  mkdir paths[z], do (z)-> ->
    require "./#{z}"
