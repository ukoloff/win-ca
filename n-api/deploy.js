var fs = require('fs')
var path = require('path')

var src = 'build/Release/crypt32.node'
var exe = 'roots.exe'

var from = path.join(__dirname, src)
require(from) // Safeguard

var parts = path.parse(from)
var save = path.join(__dirname, '../lib', `${parts.name}-${process.arch}${parts.ext}`)

console.log('Creating:', save)
fs.createReadStream(from).pipe(fs.createWriteStream(save))

if (process.arch != "ia32" || 'exe' in process.argv) return

save = path.join(path.dirname(save), exe)
from = path.join(path.dirname(from), exe)

console.log('Creating:', save)
fs.createReadStream(from).pipe(fs.createWriteStream(save))
