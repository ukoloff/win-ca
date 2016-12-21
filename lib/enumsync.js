//
// Enumerate system root CAs synchronously
//
var crypt = require('./crypt32')

module.exports = me

function me(cb)
{
  var store = crypt.CertOpenSystemStoreA(null, 'ROOT')
  try {
    var ctx = null
    while(1)
    {
      ctx = crypt.CertEnumCertificatesInStore(store, ctx)
      if(ctx.isNull())
        break
      cb(ctx.deref().pem())
    }
  } finally {
    crypt.CertCloseStore(store, 0)
  }
}
