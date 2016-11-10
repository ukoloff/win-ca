//
// Format PEM
//
var forge = require('node-forge')

var pki = forge.pki

module.exports = format

function format(crt)
{
  return [subject, pem].map(function(cb)
  {
    return cb(crt)
  })
  .join('\n')
}

function pem(crt)
{
  return pki.certificateToPem(crt)
}

function subject(crt)
{
  return crt.subject.attributes.map(function(rdn)
  {
    return '/' + (rdn.shortName || rdn.name)+ '=' + rdn.value
  })
  .join('')
}
