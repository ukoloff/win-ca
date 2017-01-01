fs = require 'fs'
path = require 'path'

for f in fs.readdirSync __dirname
  continue if f == path.basename __filename
  continue unless '.coffee' == path.extname f
  try
    require "./#{f}"
  catch e
    console.error e.message
    console.log e.stack
