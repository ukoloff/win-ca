###
Build top package
###
fs = require 'fs'
path = require 'path'

paths = require './paths'

pckg = JSON.parse JSON.stringify paths.package

name = pckg.name

pckg.name = name.replace /\W\w+$/, ''
for k in 'os main files scripts'.split ' '
  delete pckg[k]

Object.keys pckg
.filter (s)-> /dependencies$/i.test s
.forEach (s)->
  delete pckg[s]
pckg.optionalDependencies =
  "#{name}": pckg.version

fs.writeFile path.join(paths.top, 'package.json'), JSON.stringify(pckg, null, '  '), ->
fs.writeFile path.join(paths.top, 'index.js'), require('./js'), ->

for k in 'README.md'.split ' '
  fs.createReadStream path.join paths.root, k
  .pipe fs.createWriteStream path.join paths.top, k
