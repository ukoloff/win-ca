###
Test name_hash[_old]
###
fs = require 'fs'
path = require 'path'
assert = require 'assert'
forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

hash = require '../lib/hash'
hach = require '../lib/hash_old'

pem = fs.readFileSync path.join __dirname, 'uxm.pem'
crt = pki.certificateFromPem pem

assert.equal '3aa90a40', hach crt
assert.equal '09926f58', hash crt

console.log "Hashes ok:", 2
