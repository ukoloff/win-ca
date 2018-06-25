###
Enumerate system root CAs
###
path = require 'path'
spawn = require 'child_process'

split = require 'split'

der2 = require './der2'

bufferFrom = Buffer.from or (data, encoding)->
  new Buffer data, encoding

module.exports = each = (format, cb)->
  cb ||= format
  child = spawn.spawnSync exe()
  split (blob)->
    unless blob
      return
    cb der2 format, bufferFrom blob, 'hex'
  .end child.stdout
  return

###
Asynchronous enumeration

Callback:
  cb(error):      error
  cb(null, crt):  certificate
  cb():           done
###
each.async = (format, cb)->
  cb ||= format
  spawn.spawn exe()
    .stdout.pipe split (blob)->
      unless blob
        return
      cb null, der2 format, bufferFrom blob, 'hex'
    .on 'end', ->
      cb null
      return

exe = ->
  path.join __dirname, 'roots'
