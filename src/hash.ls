# X509_NAME_hash & X509_NAME_hash_old
require! <[ crypto ./forge ./der2]>

asn1 = forge!asn1
toASN1 = der2 der2.asn1

module.exports = dispatch

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding

# Convert Subject to canonic form (as OpenSSL 1+ does)
#
# See x509_name_canon in OpenSSL sources:
# In it all strings are converted to UTF8, leading, trailing and
# multiple spaces collapsed, converted to lower case and the leading
# SEQUENCE header removed.
# In future we could also normalize the UTF8 too.
function hash
  sha1 = crypto.create-hash \sha1

  toASN1 it .subject.value.for-each !->
    it = asn1.copy it

    pair = it.value[0].value[1]
    unless pair.value
      return
    pair.type = asn1.Type.UTF8

    # Binary -> UTF-8
    unicod = buffer-from pair.value, \binary .to-string \utf8

    unicod .= trim!replace /[A-Z]+/g, (.to-lower-case!) .replace /\s+/g ' '

    # UTF-8 -> Binary
    pair.value = buffer-from unicod, \utf8 .to-string \binary

    sha1.update do
      asn1.to-der it
        .get-bytes!
      \binary

  hex sha1

# As in OpenSSL v0.*
function hash0
  md5 = crypto.create-hash \md5
  subj = toASN1 it
    .subject
  md5.update do
    asn1.to-der subj
      .get-bytes!
    \binary
  hex md5

function hex
  it .= digest!slice 0 4
  # Buffer::swap32()
  it.writeUInt32LE it.readUInt32BE(0), 0
  it.to-string \hex

function dispatch(ver, blob)
  fn = if 0 == ver
    hash0
  else
    hash

  if blob?
    fn blob
  else
    fn
