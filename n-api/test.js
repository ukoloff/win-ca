const assert = require('assert')

const crypt = require('bindings')('crypt32')
const forge = require('node-forge')

const asn1 = forge.asn1
const pki = forge.pki

console.log('Starting...')
let a = new crypt

let N = 0
console.log('Fetching...')
for (let q; q = a.next(); N++) {
  assert(N < 1000)
  let crt = pki.certificateFromAsn1(asn1.fromDer(q.toString('binary')))
  assert(crt.serialNumber)
}

assert(N > 10)

console.log('Freeing...')
a.done()

console.log('Total:', N)

console.log('Dump with standalone utility...')

const child = require('child_process')
const path = require('path')
const split = require('split')

let NN = 0

let exec = child.spawn(path.join(__dirname, 'build/Release/roots'))
exec.stdout.pipe(split(onCrt)).on('end', onEnd)

function onCrt(pem) {
  if (!pem) return
  NN++
  assert(NN < 1000)
  let q = Buffer.from(pem, 'hex')
  let crt = pki.certificateFromAsn1(asn1.fromDer(q.toString('binary')))
  assert(crt.serialNumber)
}

function onEnd() {
  console.log('Total:', NN)
  assert(N == NN)
}
