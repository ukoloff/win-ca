//
// Format PEM
//
var forge = require('node-forge')

var pki = forge.pki

module.exports = format

function format(crt)
{
  return pki.certificateToPem(crt)
}
