###
List system with .Net
###
path = require 'path'

edge = require 'edge'

forge = require 'node-forge'
pki = forge.pki
asn1 = forge.asn1

enumCA = edge.func path.join __dirname, '..', 'edge', 'enum.cs'

module.exports = enumCA 0, true
  .map (der)->
    pki.certificateFromAsn1 asn1.fromDer der.toString 'binary'
