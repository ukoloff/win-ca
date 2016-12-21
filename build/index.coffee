###
Build top package
###
fs = require 'fs'
path = require 'path'

pckg = require '../package'
pckg = JSON.parse JSON.stringify pckg
name = pckg.name

pckg.name = name.replace /\W\w+$/, ''
for k in 'os main scripts'.split ' '
  delete pckg[k]

Object.keys pckg
.filter (s)-> /dependencies$/i.test s
.forEach (s)->
  delete pckg[s]
pckg.files = ['index.js']
pckg.optionalDependencies =
  "#{name}": pckg.version

src = path.join __dirname, '..'
dst = path.join src, 'top'

try fs.mkdirSync dst

fs.writeFile path.join(dst, 'package.json'), JSON.stringify(pckg, null, '  '), ->
fs.writeFile path.join(dst, pckg.files[0]), require('./glue'), ->

for k in 'README.md'.split ' '
  fs.createReadStream path.join src, k
  .pipe fs.createWriteStream path.join dst, k
