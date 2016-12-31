fs = require 'fs'
path = require 'path'

for f in fs.readdirSync __dirname
  continue unless '.coffee' == path.extname f
  require "./#{f}"
