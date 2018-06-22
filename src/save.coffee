###
Save Root CAs to disk
###
fs = require 'fs'
path = require 'path'

all = require './all'
format = require './format'
hash = require './hash'
mkdir = require './mkdir'

exports.path =
dst = path.join __dirname, '../pem'

mkdir dst, ->
  process.env.SSL_CERT_DIR = dst

  list = all.slice()
  hashes = {}
  names = {}

  pems = fs.createWriteStream path.join dst, roots = 'roots.pem'
  names[roots] = 1

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
        loop
          unless file = files.pop()
            return
          unless names[file]
            break

        fs.unlink path.join(dst, file), (err)->
          throw err if err
          do drop

  do save = ->
    unless crt = list.pop()
      pems.end()
      do drop
      return

    pems.write text = format crt

    fs.writeFile path.join(dst, pem = name hash crt), text, (err)->
      throw err if err
      do save
