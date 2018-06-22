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
module.exports = (crt)->
  sha1 = crypto.createHash 'sha1'

  crt2asn1 crt
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

  sha1.digest()
    .readUInt32LE 0

# Mini-parser for X.509 ASN.1
crt2asn1 = (crt)->
  crt = pki.certificateToAsn1 crt # Certificate
    .value[0].value               # TBSCertificate
  serial = crt[0]
  hasSerial =
    serial.tagClass == asn1.Class.CONTEXT_SPECIFIC and
    serial.type == 0 and
    serial.constructed
  crt = crt.slice hasSerial
  serial:  crt[0]
  issuer:  crt[2]
  valid:   crt[3]
  subject: crt[4]
