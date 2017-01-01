###
X509_NAME_hash_old
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

encode = (dn)->
  asn1.toDer pki.distinguishedNameToAsn1 dn
  .getBytes()
  # returns string with binary encoding

md5 = (data)->
  crypto.createHash 'md5'
  .update data, 'binary'
  .digest()

module.exports = (dn)->
  md5 encode dn
  .readUInt32LE 0

