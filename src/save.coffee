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

exports.path =
dst = path.join __dirname, '../pem'

mkdir dst, ->
  process.env.SSL_CERT_DIR = dst
  list = all.slice()
  hashes = {}
  names = {}

  # Get name for file/symlink
  name = (hash)->
    hashes[hash] ||= 0
    n = "#{hash}.#{hashes[hash]++}"
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

    fs.writeFile path.join(dst, pem = name hash crt), format(crt), (err)->
      throw err if err
      fs.unlink link = path.join(dst, name hach crt), (err)->
        fs.symlink pem, link, 'file', (err)->
          # throw err if err
          do save
