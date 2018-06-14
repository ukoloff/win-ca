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

assert.equal 0x3aa90a40, hach crt.subject
assert.equal 0x09926f58, hash crt.subject

console.log "Hashes ok:", 2
