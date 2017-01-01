###
Save Root CAs to disk
###
fs = require 'fs'
path = require 'path'

all = require './all'
mkdir = require './mkdir'
format = require './format'
hash = require './hash'
hach = require './hash_old'

dst = path.join __dirname, '../pem'

hex = (hash)->
  x = hash.toString 16
  while x.length < 8
    x = '0' + x
  x

mkdir dst, ->
  list = all.slice()
  hashes = {}
  names = {}

  name = (hash)->
    x = hex hash
    hashes[x] ||= 0
    n = hashes[x]++
    n = "#{x}.#{n}"
    names[n] = 1
    n

  do save = ->
    return unless crt = list.pop()

    fs.writeFile path.join(dst, pem = name hash crt.subject), format(crt), save
