var path = require('path')
var edge = require('edge');

forge = require('node-forge')
pki = forge.pki
asn1 = forge.asn1

var enumCA = edge.func(path.join(__dirname, 'enum.cs'))

enumCA(0, true).forEach(unDer)

function unDer(der)
{
  var cer = pki.certificateFromAsn1(asn1.fromDer(der.toString('binary')))
  console.log(cer.subject.attributes.map(rdn).join(''))
}

function rdn(rdn)
{
  return "/" + (rdn.shortName || rdn.name || rdn.type) + "=" + rdn.value
}
