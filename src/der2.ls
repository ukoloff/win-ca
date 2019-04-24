# Convert DER-encoded certificate to something...

module.exports = der2

forge$ = require  \./forge

formatters = {der, pem, txt, asn1, x509}

list = []
for k, v of formatters
  der2[k] = list.length
  list.push v

der2.forge = der2.x509

is-buffer = Buffer.is-buffer

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding

function der2(format, blob)
  converter = list[format] || list[0]
  if blob?
    converter blob
  else
    converter

# Individual converters below
function der
  if is-buffer it
    it
  else
    buffer-from it, \binary

function pem
  it = der it .toString \base64
  lines = ['-----BEGIN CERTIFICATE-----']
  for i til it.length by 64
    lines.push it.substr i , 64
  lines.push '-----END CERTIFICATE-----' ''
  lines.join "\r\n"

function txt
  self = require \../package

  crt = asn1 it
  d = new Date
  """
  Subject\t#{
    crt.subject.value.map (.value[0].value[1].value) .join '/'}
  Valid\t#{
    crt.valid.value.map (.value) .join ' - '}
  Saved\t#{
    d.toLocaleDateString!} #{
    d.toTimeString!replace /\s*\(.*\)\s*/ ''} by #{
    self.name}@#{
    self.version}
  #{pem it}
  """

function asn1
  asn1parser = forge$!asn1
  it .= toString \binary
  crt = asn1parser.fromDer it   # Certificate
    .value[0].value             # TBSCertificate
  serial = crt[0]
  hasSerial =
    serial.tagClass == asn1parser.Class.CONTEXT_SPECIFIC and
    serial.type == 0 and
    serial.constructed
  crt = crt.slice hasSerial
  serial:  crt[0]
  issuer:  crt[2]
  valid:   crt[3]
  subject: crt[4]

function x509
  it.toString 'binary'
  |>  forge$!asn1.fromDer
  |>  forge$!pki.certificateFromAsn1
