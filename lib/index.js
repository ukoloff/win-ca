var fs = require('fs')
var x = require('./enum')
var format = require('./format')

var n = 0

x()
.on('crt', function(crt)
{
  n++
  fs.writeFile('tmp/' + n + '.cer', format(crt))
})
