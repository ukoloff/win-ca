###
Asynchronous enumeration

Returns:
  cb(error):      error
  cb(null, crt):  certificate
  cb():           done
###
crypt = require "./crypt32-#{process.arch}"
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

module.exports = (cb)-> setImmediate ->
  store = crypt()
  do step = -> setImmediate ->
    try
      if blob = store.next()
        cb null, pki.certificateFromAsn1 asn1.fromDer blob.toString 'binary'
        do step
      else
        store.done()
        do cb
        return
    catch error
      store.done()
      cb error
