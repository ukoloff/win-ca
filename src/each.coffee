###
Enumerate system root CAs synchronously
###
crypt = require "./crypt32-#{process.arch}"
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

module.exports = (cb)->
  store = crypt()
  try
    while blob = store.next()
      cb pki.certificateFromAsn1 asn1.fromDer blob.toString 'binary'
  finally
    store.done()
