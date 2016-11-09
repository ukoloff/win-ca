var fs = require('fs')
var x = require('./enum')
var n = 0

x()
.on('error', function(err)
{
  throw err
})
.on('crt', function(crt)
{
  n++
  fs.writeFile('tmp/' + n + '.cer', x.pki.certificateToPem(crt))
})
