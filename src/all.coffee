###
Fetch all root CAs
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

each = require './each'
module.exports =
all = []

sha1 = (data)->
  crypto.createHash 'sha1'
  .update data, 'binary'
  .digest 'hex'

der = (crt)->
  asn1.toDer pki.certificateToAsn1 crt
  .getBytes()

seen = {}

each (crt)->
  if seen[z = sha1 der crt]
    return
  seen[z] = 1
  all.push crt

seen = 0
