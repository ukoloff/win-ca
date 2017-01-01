###
FFI interface to crypt32.dll
###
ffi = require 'ffi'
ref = require 'ref'
struct = require 'ref-struct'

Ctx = struct
  dwCertEncodingType: 'long'
  pbCertEncoded: 'pointer'
  cbCertEncoded: 'long'
  pCertInfo: 'pointer'
  hCertStore: HCertStore = ref.refType ref.types.void

pCtx = ref.refType Ctx

for k, v of require './ctx'
  Ctx::[k] = v

ffi.Library 'crypt32',
  CertOpenSystemStoreA: [HCertStore, ['pointer', 'string']]
  CertCloseStore: ['int', [HCertStore, 'long']]
  CertEnumCertificatesInStore: [pCtx, [HCertStore, pCtx]]
  exports
