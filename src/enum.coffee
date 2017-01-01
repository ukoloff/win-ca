###
Enumerate system root CAs synchronously
###
crypt = require './crypt32'

module.exports = (cb)->
  store = crypt.CertOpenSystemStoreA null, 'ROOT'
  try
    ctx = null
    while 1
      ctx = crypt.CertEnumCertificatesInStore store, ctx
      return if ctx.isNull()
      cb ctx.deref().crt()
  finally
    crypt.CertCloseStore store, 0
