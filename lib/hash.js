// Calculate name_hash and name_hash_old

var fs = require('fs')

var f = require('node-forge')
var pki = f.pki;
var asn1 = f.asn1;

var pem  = fs.readFileSync('22.cer');
var crt = pki.certificateFromPem(pem);

//console.log(crt.subject)
var subj = asn1.toDer(pki.distinguishedNameToAsn1(crt.subject))
fs.writeFileSync('22.subj.old.der', subj)
//console.log(subj)

var subz = asn1.toDer(
pki.distinguishedNameToAsn1({
  attributes: crt.subject.attributes.map(canon)
}))

nn = subz.getByte();	// skip SEQUENCE
asn1.getBerValueLength(subz);	// skip Length
subz = subz.getBytes();

//console.log(subz)

fs.writeFileSync('22.subj.der', subz)

function canon(rdn)
{
  return {
    valueTagClass: asn1.Type.UTF8,
    type: rdn.type,
    value: rdn.value.toLowerCase().replace(/\s+/g, ' ').replace(/^\s+|\s+$/, '')
  }
}
