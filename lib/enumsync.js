//
// Enumerate system root CAs synchronously
//
var forge = require('node-forge')
var crypt = require('./crypt32')

var asn1 = forge.asn1
var pki = forge.pki

module.exports = me
me.pki = pki

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
      var res = ctx.deref()
      res = res.pbCertEncoded.reinterpret(res.cbCertEncoded)
      res = asn1.fromDer(res.toString('binary'))
      res = pki.certificateFromAsn1(res)
      cb(res)
    }
  } finally {
    crypt.CertCloseStore(store, 0)
  }
}
