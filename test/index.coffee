fs = require 'fs'

for f in fs.readdirSync __dirname
  require "./#{f}"
