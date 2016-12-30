###
Compile .coffee -> .js
###
fs = require 'fs'
path = require 'path'

cc = require './cc'
paths = require './paths'

fs.readdir src = paths.src, (err, files)->
  throw err if err
  do compile = ->
    return unless files.length
    fs.readFile path.join(src, file = files.pop()), (err, coffee)->
      throw err if err
      do compile
      fs.writeFile path.join(paths.dst, "#{path.parse(file).name}.js"),
        cc(String coffee), ->
