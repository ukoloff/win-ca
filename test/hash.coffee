###
Test name_hash[_old]
###
fs = require 'fs'
path = require 'path'
forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

hash = require '../lib/hash'
hach = require '../lib/hash_old'

pem = fs.readFileSync path.join __dirname, 'uxm.pem'
crt = pki.certificateFromPem pem
console.log crt.subject
console.log hash crt.subject
console.log hach crt.subject
