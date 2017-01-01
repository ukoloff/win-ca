###
Helper functions for Win32 certificate context
###
forge = require 'node-forge'

asn1 = forge.asn1
pki = forge.pki

@crt = ->
  der = @pbCertEncoded.reinterpret @cbCertEncoded
  pki.certificateFromAsn1 asn1.fromDer der.toString 'binary'

@pem = ->
  pki.certificateToPem @crt()
