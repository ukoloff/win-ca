###
Test name_hash[_old]
###
fs = require 'fs'
path = require 'path'
assert = require 'assert'

forge = require 'node-forge'

hash = require '../lib/hash'
hach = require '../lib/hash_old'

pem = fs.readFileSync path.join __dirname, 'uxm.pem'
der = forge.pem.decode(pem)[0].body

assert.equal '3aa90a40', hach der
assert.equal '09926f58', hash der

console.log "Hashes ok:", 2
