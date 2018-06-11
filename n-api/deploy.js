const fs = require('fs')
const path = require('path')

const src = 'build/Release/crypt32.node'
const exe = 'roots.exe'

let from = path.join(__dirname, src)
require(from) // Safeguard

let parts = path.parse(from)
let save = path.join(__dirname, '../lib', `${parts.name}-${process.arch}${parts.ext}`)

console.log('Creating:', save)
fs.createReadStream(from).pipe(fs.createWriteStream(save))

if (process.arch != "ia32") return

save = path.join(path.dirname(save), exe)
from = path.join(path.dirname(from), exe)

console.log('Creating:', save)
fs.createReadStream(from).pipe(fs.createWriteStream(save))
