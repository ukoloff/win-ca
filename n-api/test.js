var assert = require('assert')

var forge = require('node-forge')

var asn1 = forge.asn1
var pki = forge.pki

var child = require('child_process')
var path = require('path')
var split = require('split')

bufferFrom = Buffer.from || function(data, encoding) {
  return new Buffer(data, encoding);
};

var binUtility = path.join(__dirname, 'build/Release/roots')
console.log('Dump with standalone utility...')
var NN = 0
split(onCrt).end(child.spawnSync(binUtility).stdout)

var Total = NN
console.log('Total:', NN)
assert(NN > 10)

console.log('Asynchronous dump with standalone utility...')
NN = 0
child.spawn(binUtility).stdout.pipe(split(onCrt)).on('end', onEnd)

var crypt
try {
  crypt = require('bindings')('crypt32')
} catch (e) {
  console.log('! Skipping N-API bindings test...')
}

nApi(crypt)

function assertCrt(blob) {
  var crt = pki.certificateFromAsn1(asn1.fromDer(blob.toString('binary')))
  assert(crt.serialNumber)
}

function onCrt(pem) {
  if (!pem) return
  NN++
  assertCrt(bufferFrom(pem, 'hex'))
  assert(NN < 1000)
}

function onEnd() {
  console.log('Total:', NN, '\t// Async standalone')
  assert(NN === Total)
}

function nApi(crypt) {
  if (!crypt) return

  console.log('Starting N-API connection...')
  var a = new crypt

  var N = 0
  console.log('Fetching...')
  for (var blob; blob = a.next(); N++) {
    assertCrt(blob)
    assert(N < 1000)
  }

  console.log('Total:', N, '\t// N-API')

  assert(N === Total)

  console.log('Cleaning N-API...')
  a.done()
}
