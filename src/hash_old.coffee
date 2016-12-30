###
X509_NAME_hash_old
###
crypto = require 'crypto'
forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

module.exports = (crt)->
  crypto.createHash 'md5'
  .update asn1.toDer pki.distinguishedNameToAsn1 crt.subject
  .digest().readUInt32BE 0
