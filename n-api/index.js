const crypt = require('bindings')('crypt32').Crypt32;
const forge = require('node-forge')

const asn1 = forge.asn1
const pki = forge.pki


console.log('Creating')
let a = new crypt;

console.log('Fetching')
for (let q; q = a.next();) {
  console.log(pki.certificateFromAsn1(asn1.fromDer(q)))
}

console.log('Freeing')
a.done()
