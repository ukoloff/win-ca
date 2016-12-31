###
Fetch all root CAs
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

e = require './enum'
require './format'

module.exports =
all = []

hash = (crt)->
  der = asn1.toDer pki.certificateToAsn1 crt
  crypto.createHash 'sha1'
  .update der.getBytes(), 'binary'
  .digest 'hex'

seen = {}

e (crt)->
  if seen[z = hash crt]
    return
  seen[z] = 1
  all.push crt

seen = 0
