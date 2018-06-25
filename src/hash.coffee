###
X509_NAME_hash
###
crypto = require 'crypto'

asn1 = require 'node-forge'
  .asn1

der2 = require './der2'

# Convert Subject to canonic form (as OpenSSL 1+ does)
#
# See x509_name_canon in OpenSSL sources:
# In it all strings are converted to UTF8, leading, trailing and
# multiple spaces collapsed, converted to lower case and the leading
# SEQUENCE header removed.
# In future we could also normalize the UTF8 too.
module.exports = (der)->
  sha1 = crypto.createHash 'sha1'

  der2 der2.asn1, der
  .subject
  .value.forEach (rdn)->
    rdn = asn1.copy rdn

    pair = rdn.value[0].value[1]
    pair.type = asn1.Type.UTF8
    unless pair.value
      return
    pair.value = pair.value
      .toLowerCase()
      .replace /\s+/g, ' '
      .replace /^\s+|\s+$/, ''
    sha1.update asn1.toDer(rdn).getBytes(), 'binary'

  hex sha1

hex = (hash)->
  hash = hash.digest().slice 0, 4
  # Buffer::swap32()
  hash.writeUInt32LE hash.readUInt32BE(0), 0
  hash.toString 'hex'
