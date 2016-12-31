###
X509_NAME_hash
###
crypto = require 'crypto'
forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

# Convert Subject to canonic form (as OpenSSL 1+ does)
canon = (dn)->
  attributes: dn.attributes.map (rdn)->
    valueTagClass: asn1.Type.UTF8
    type: rdn.type
    value: rdn.value
      .toLowerCase()
      .replace /\s+/g, ' '
      .replace /^\s+|\s+$/, ''

# Strip SEQUENCE header
stripSeq = (buffer)->
  buffer.getByte()              # skip SEQUENCE
  asn1.getBerValueLength buffer # skip Length
  buffer.getBytes()

module.exports = (dn)->
  crypto.createHash 'sha1'
  .update stripSeq asn1.toDer pki.distinguishedNameToAsn1 canon dn
  .digest().readUInt32LE 0
