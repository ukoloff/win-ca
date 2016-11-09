var ref = require('ref')
var ffi = require('ffi')
var struct = require('ref-struct')

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
  CertEnumCertificatesInStore: [pCtx, ['pointer', pCtx]]
})

crypt.CertOpenSystemStoreA(null, 'ROOT')
