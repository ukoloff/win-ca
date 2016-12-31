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

module.exports = (dn)->
  crypto.createHash 'md5'
  .update encode(dn), 'binary'
  .digest()
  .readUInt32LE 0
