###
Asynchronous enumeration

Returns:
  cb(error):      error
  cb(null, crt):  certificate
  cb():           done
###
crypt = require './crypt32'

module.exports = (cb)->
  store = null

  crypt.CertOpenSystemStoreA.async null, 'ROOT', (error, result)->
    return if croak error
    store = result
    more null

  free = ->
    return unless store
    crypt.CertCloseStore.async store, 0, ->
    store = 0

  croak = (error)->
    return unless error
    do free
    cb error
    return true

  more = (ctx)->
    crypt.CertEnumCertificatesInStore.async store, ctx, (error, result)->
      return if croak error
      try
        if result.isNull()
          do free
          setImmediate cb
          return
        cb null, result.deref().crt()
        more result
      catch error
        do free
        cb error
