###
Enumerate system root CAs synchronously
###
path = require 'path'
spawn = require 'child_process'

split = require 'split'
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

bufferFrom = Buffer.from or (data, encoding)->
  new Buffer data, encoding

module.exports = each = (cb)->
  child = spawn.spawnSync exe()
  split (blob)->
    unless blob
      return
    blob = bufferFrom blob, 'hex'
    cb getCrt blob
  .end child.stdout
  return

###
Asynchronous enumeration

Returns:
  cb(error):      error
  cb(null, crt):  certificate
  cb():           done
###
each.async = (cb)->
  spawn.spawn exe()
    .stdout.pipe split (blob)->
      unless blob
        return
      blob = bufferFrom blob, 'hex'
      cb null, getCrt blob
    .on 'end', ->
      cb null
      return

exe = ->
  path.join __dirname, 'roots'

getCrt = (blob)->
  pki.certificateFromAsn1 asn1.fromDer blob.toString 'binary'
