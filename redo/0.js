var fs = require('fs')
var path = require('path')
var crypto = require('crypto');

var forge = require('node-forge')
var pki = forge.pki
var asn1 = forge.asn1

var blob = forge.pem.decode(fs.readFileSync(path.join(__dirname, '../test/uxm.pem')))[0].body
var tree = asn1.fromDer(blob)

var crt = pki.certificateFromAsn1(tree)

var subj = tree.value[0].value[5]

var sha1 = crypto.createHash('sha1')

subj.value.forEach(rdn)
console.log(sha1.digest('hex'))

function rdn(rdn) {
  rdn = asn1.copy(rdn)

  pair = rdn.value[0].value[1]
  pair.type = asn1.Type.UTF8
  pair.value = pair.value.toLowerCase().replace(/\s+/g, ' ').replace(/^\s+|\s+$/, '')
  sha1.update(asn1.toDer(rdn).getBytes(), 'binary')
}
