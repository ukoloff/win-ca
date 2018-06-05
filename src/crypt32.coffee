###
FFI-NAPI interface to crypt32.dll
###
ffi = require 'ffi-napi'
ref = require 'ref-napi'
struct = require 'ref-struct-di'

struct = struct ref

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
  @
