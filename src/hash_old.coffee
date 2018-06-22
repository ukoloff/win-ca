###
X509_NAME_hash_old
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

md5 = (data)->
  crypto.createHash 'md5'
  .update data, 'binary'
  .digest()

module.exports = (crt)->
  subj = crt2asn1 crt
    .subject
  md5 asn1.toDer(subj).getBytes()
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
