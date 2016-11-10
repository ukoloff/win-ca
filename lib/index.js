var https = require('https')
var x = require('./enum')

setTimeout(run, 1000)

var ca = https.globalAgent.options
ca = ca.ca || (ca.ca = [])

x()
.on('crt', function(crt)
{
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
