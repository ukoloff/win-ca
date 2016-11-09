//
// FFI interface to crypt32.dll
//
var ffi = require('ffi')
var ref = require('ref')
var struct = require('ref-struct')

var HCertStore = ref.refType(ref.types.void)

var Ctx = struct({
  dwCertEncodingType: 'long',
  pbCertEncoded: 'pointer',
  cbCertEncoded: 'long',
  pCertInfo: 'pointer',
  hCertStore: HCertStore
})

var pCtx = ref.refType(Ctx)

module.exports = ffi.Library('crypt32', {
  CertOpenSystemStoreA: [HCertStore, ['pointer', 'string']],
  CertCloseStore: ['int', [HCertStore, 'long']],
  CertEnumCertificatesInStore: [pCtx, [HCertStore, pCtx]]
})
