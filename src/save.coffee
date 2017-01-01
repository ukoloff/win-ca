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

  # Get name for file/symlink
  name = (hash)->
    x = hex hash
    hashes[x] ||= 0
    n = hashes[x]++
    n = "#{x}.#{n}"
    names[n] = 1
    n

  # Delete unused files
  drop = ->
    fs.readdir dst, (err, files)->
      throw err if err
      do drop = ->
        return unless file = files.pop()

        if names[file]
          setImmediate drop
          return

        fs.unlink path.join(dst, file), (err)->
          throw err if err
          do drop

  do save = ->
    unless crt = list.pop()
      do drop
      return

    fs.writeFile path.join(dst, pem = name hash crt.subject), format(crt), (err)->
      throw err if err
      fs.unlink link = path.join(dst, name hach crt.subject), (err)->
        fs.symlink pem, link, 'file', (err)->
          throw err if err
          do save
