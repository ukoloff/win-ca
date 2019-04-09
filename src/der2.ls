# Convert DER-encoded certificate to something...

module.exports = der2

forge$ = require  \./forge

formatters = {der, pem, txt, asn1, forge}

list = []
for k, v of formatters
  der2[k] = list.length
  list.push v

function der2(format, blob)
  converter = list[format] || list[0]
  if blob?
    converter blob
  else
    converter

# Individual converters below
function der
  it

function pem
  lines = ['-----BEGIN CERTIFICATE-----']
  it .= toString \base64
  # Split by 64
  while it.length, it .= substr 64
    lines.push it.substr 0, 64
  lines.push '-----END CERTIFICATE-----', ''
  lines.join "\r\n"

function txt
  self = require \../package

  crt = asn1 it
  d = new Date
  """
  Subject\t#{crt.subject.value.map((.value[0].value[1].value)).join '/'}
  Valid\t#{crt.valid.value.map((.value)).join ' - '}
  Saved\t#{d.toLocaleDateString!} #{
    d.toTimeString!replace /\s*\(.*\)\s*/, ''} by #{self.name}@#{self.version}
  #{pem it}
  """

function asn1
  asn1parser = forge$!asn1
  crt = asn1parser.fromDer it.toString 'binary' # Certificate
    .value[0].value                             # TBSCertificate
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

function forge
  it.toString 'binary'
  |>  forge$!asn1.fromDer
  |>  forge$!pki.certificateFromAsn1
