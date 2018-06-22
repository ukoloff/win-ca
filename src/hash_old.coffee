###
X509_NAME_hash_old
###
crypto = require 'crypto'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

module.exports = (crt)->
  md5 = crypto.createHash 'md5'
  subj = crt2asn1 crt
    .subject
  md5.update asn1.toDer(subj).getBytes(), 'binary'
  hex md5

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

hex = (hash)->
  hash = hash.digest().slice 0, 4
  # Buffer::swap32()
  hash.writeUInt32LE hash.readUInt32BE(0), 0
  hash.toString 'hex'
