var assert = require('assert')

// var  crypt = require('bindings')('crypt32')
var forge = require('node-forge')

var asn1 = forge.asn1
var pki = forge.pki

/*
console.log('Starting...')
var a = new crypt

var N = 0
console.log('Fetching...')
for (var q; q = a.next(); N++) {
  assert(N < 1000)
  var crt = pki.certificateFromAsn1(asn1.fromDer(q.toString('binary')))
  assert(crt.serialNumber)
}

assert(N > 10)

console.log('Freeing...')
a.done()

console.log('Total:', N)
*/
console.log('Dump with standalone utility...')

var child = require('child_process')
var path = require('path')
var split = require('split')

var NN = 0

var exec = child.spawn(path.join(__dirname, 'build/Release/roots'))
exec.stdout.pipe(split(onCrt)).on('end', onEnd)

function onCrt(pem) {
  if (!pem) return
  NN++
  assert(NN < 1000)
  var q = Buffer.from(pem, 'hex')
  var crt = pki.certificateFromAsn1(asn1.fromDer(q.toString('binary')))
  assert(crt.serialNumber)
}

function onEnd() {
  console.log('Total:', NN)
  assert(NN > 10)
}
