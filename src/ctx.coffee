###
Helper functions for Win32 certificate context
###
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

@crt = ->
  res = @pbCertEncoded.reinterpret @cbCertEncoded
  res = asn1.fromDer res.toString 'binary'
  pki.certificateFromAsn1 res

@pem = ->
  pki.certificateToPem @crt()
