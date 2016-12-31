###
Save Root CAs to disk
###
fs = require 'fs'
path = require 'path'

all = require './all'
mkdir = require './mkdir'
format = require './format'

dst = path.join __dirname, '../pem'

mkdir dst, ->
  all = all.slice()
  do save = ->
    return unless all.length
    crt = all.pop()
    fs.writeFile path.join(dst, ''+all.length), format(crt), save
