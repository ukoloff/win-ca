const fs = require('fs')
const path = require('path')

const src = './build/Release/crypt32.node'

const from = path.join(__dirname, src)
require(from) // Safeguard

const parts = path.parse(from)
const save = path.join(__dirname, '../lib', `${parts.name}-${process.arch}${parts.ext}`)
console.log(save)

console.log('Creating:', save)
fs.createReadStream(from).pipe(fs.createWriteStream(save))
