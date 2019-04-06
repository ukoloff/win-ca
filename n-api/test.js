var assert = require('assert')
var child = require('child_process')
var path = require('path')

var split = require('split')
var forge = require('node-forge')

var asn1 = forge.asn1
var pki = forge.pki

var bufferFrom = Buffer.from || function (data, encoding) {
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

nApi()

function assertCrt(blob) {
  var tree = asn1.fromDer(blob.toString('binary'))
  assert(tree.value.length)
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

function nApi() {
  if (!process.versions.napi) {
    console.log('! Skipping N-API bindings test...')
    return
  }

  console.log('Starting N-API connection...')
  var crypt = require('bindings')('crypt32')
  var a = crypt()

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
