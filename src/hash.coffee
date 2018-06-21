###
X509_NAME_hash
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

# Convert Subject to canonic form (as OpenSSL 1+ does)
#
# See x509_name_canon in OpenSSL sources:
# In it all strings are converted to UTF8, leading, trailing and
# multiple spaces collapsed, converted to lower case and the leading
# SEQUENCE header removed.
# In future we could also normalize the UTF8 too.
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
  # returns string with binary encoding

encode = (dn)->
  stripSeq asn1.toDer pki.distinguishedNameToAsn1 canon dn

sha1 = (data)->
  crypto.createHash 'sha1'
  .update data, 'binary'
  .digest()

module.exports = (crt)->
  sha1 encode crt.subject
  .readUInt32LE 0

