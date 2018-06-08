const crypt = require('bindings')('crypt32')
const forge = require('node-forge')

const asn1 = forge.asn1
const pki = forge.pki


console.log('Creating')
let a = new crypt;

let N = 0
console.log('Fetching')
for (let q; q = a.next(); N++) {

  console.log(pki.certificateFromAsn1(asn1.fromDer(q.toString('binary'))))
}

console.log('Total:', N)

console.log('Freeing')
a.done()
