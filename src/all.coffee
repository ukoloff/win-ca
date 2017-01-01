###
Fetch all root CAs
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

require './format'
e = require './enum'
module.exports =
all = []

sha1 = (data)->
  crypto.createHash 'sha1'
  .update data, 'binary'
  .digest 'hex'

hash = (crt)->
  der = asn1.toDer pki.certificateToAsn1 crt
  sha1 der.getBytes()

seen = {}

e (crt)->
  if seen[z = hash crt]
    return
  seen[z] = 1
  all.push crt

seen = 0
