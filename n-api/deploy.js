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

parts = path.parse(exe)
save = path.join(path.dirname(save), `${parts.name}-${process.arch}${parts.ext}`)
from = path.join(path.dirname(from), exe)

console.log('Creating:', save)
fs.createReadStream(from).pipe(fs.createWriteStream(save))
