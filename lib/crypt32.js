//
// FFI interface to crypt32.dll
//
var ffi = require('ffi')
var ref = require('ref')
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
  hCertStore: HCertStore
})

Ctx.prototype.crt = function()
{
  var res = this.pbCertEncoded.reinterpret(this.cbCertEncoded)
  res = asn1.fromDer(res.toString('binary'))
  return pki.certificateFromAsn1(res)
}

Ctx.prototype.pem = function()
{
  return pki.certificateToPem(this.crt())
}

var pCtx = ref.refType(Ctx)

module.exports = ffi.Library('crypt32', {
  CertOpenSystemStoreA: [HCertStore, ['pointer', 'string']],
  CertCloseStore: ['int', [HCertStore, 'long']],
  CertEnumCertificatesInStore: [pCtx, [HCertStore, pCtx]]
})
