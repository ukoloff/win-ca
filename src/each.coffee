###
Enumerate system root CAs
###
crypt = require "./binding"
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

module.exports = each = (cb)->
  store = crypt()
  try
    while blob = store.next()
      cb getCrt blob
  finally
    store.done()

###
Asynchronous enumeration

Callback:
  cb(error):      error
  cb(null, crt):  certificate
  cb():           done
###
each.async = (cb)-> setImmediate ->
  store = crypt()
  do step = -> setImmediate ->
    try
      if blob = store.next()
        cb null, getCrt blob
        do step
      else
        store.done()
        do cb
        return
    catch error
      store.done()
      cb error

getCrt = (blob)->
  pki.certificateFromAsn1 asn1.fromDer blob.toString 'binary'
