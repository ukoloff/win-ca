###
X509_NAME_hash_old
###
crypto = require 'crypto'
forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

bytes = (buffer)->
  buffer.getBytes()

module.exports = (dn)->
  crypto.createHash 'md5'
  .update bytes asn1.toDer pki.distinguishedNameToAsn1 dn
  .digest().readUInt32LE 0
