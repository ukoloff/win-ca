var fs = require('fs')
var ref = require('ref')
var ffi = require('ffi')
var struct = require('ref-struct')
var forge = require('node-forge')

var asn1 = forge.asn1
var pki = forge.pki

var HCertStore = ref.refType(ref.types.void)

var Ctx = struct({
  dwCertEncodingType: 'long',
  pbCertEncoded: 'pointer',
  cbCertEncoded: 'long',
  pCertInfo: 'pointer',
  hCertStore: 'pointer'
})

var pCtx = ref.refType(Ctx)

var crypt = ffi.Library('crypt32', {
  CertOpenSystemStoreA: [HCertStore, ['pointer', 'string']],
  CertCloseStore: ['int', [HCertStore, 'long']],
  CertEnumCertificatesInStore: [pCtx, [HCertStore, pCtx]]
})

var h = crypt.CertOpenSystemStoreA(null, 'ROOT')
var n = 0
for(var ctx = null; !(ctx = crypt.CertEnumCertificatesInStore(h, ctx)).isNull(); )
{
  n++
  var z = ctx.deref()
  var asn = asn1.fromDer(z.pbCertEncoded.reinterpret(z.cbCertEncoded).toString('binary'))
  var crt = pki.certificateFromAsn1(asn)
  fs.writeFileSync('tmp/' + n + '.cer', pki.certificateToPem(crt))
}
crypt.CertCloseStore(h, 0)
