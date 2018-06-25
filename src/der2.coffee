###
Convert DER-encoded certificate to something...
###
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

self = require '../package'

module.exports = der2 = (format, der)->
  (formats[format] or formats[formats.length-1]) der

convert =
  der: der = (der)->der

convert.pem = pem = (der)->
  lines = ['-----BEGIN CERTIFICATE-----']
  der = der.toString 'base64'
  # Split by 64
  while der.length
    lines.push der.substr 0, 64
    der = der.substr 64
  lines.push '-----END CERTIFICATE-----', ''
  lines.join "\r\n"

convert.txt = (der)->
  crt = myASN der
  d = new Date
  """
  Subject\t#{crt.subject.value.map((rdn)->rdn.value[0].value[1].value).join '/'}
  Valid\t#{crt.valid.value.map((date)->date.value).join ' - '}
  Saved\t#{d.toLocaleDateString()} #{
    d.toTimeString().replace /\s*\(.*\)\s*/, ''} by #{self.name}@#{self.version}
  #{pem der}
  """

convert.asn1 = myASN = (der)->
  crt = asn1.fromDer der.toString 'binary'  # Certificate
    .value[0].value                         # TBSCertificate
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

convert.forge = (der)->
  pki.certificateFromAsn1 asn1.fromDer der.toString 'binary'

# Assign der.XXX constants
formats = []
for k, v of convert
  der2[k] = formats.length
  formats.push v

der2[k] = do der  # = undefined
