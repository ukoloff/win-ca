//
// Format PEM
//
var self = require('../package')
var forge = require('node-forge')

var pki = forge.pki

module.exports = format

function format(crt)
{
  return [subject, valid, ts, pem].map(function(cb)
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
  return 'Subject: ' +  crt.subject.attributes.map(function(rdn)
  {
    return '/' + (rdn.shortName || rdn.name)+ '=' + rdn.value
  })
  .join('')
}

function valid(crt)
{
  var x = crt.validity
  var a = []
  for(var k in x)
    a.push(x[k].toISOString())
  return 'Valid: ' +
   a.join(' - ')
}

function ts()
{
  return 'Saved: ' + new Date + ' by ' + self.name + '@' + self.version
}
