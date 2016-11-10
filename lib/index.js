var https = require('https')
var x = require('./enum')

setTimeout(run, 1000)

x()
.on('crt', function(crt)
{
  var z = https.globalAgent.options
  var ca = z.ca
  if(!ca)
    z.ca = ca = []
  ca.push(x.pki.certificateToPem(crt))
})

function run()
{
  https.get('https://ekb.ru', got)
}

function got(resp)
{
  resp.pipe(process.stdout)
}
