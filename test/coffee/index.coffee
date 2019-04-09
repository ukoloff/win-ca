fs = require 'fs'
path = require 'path'

return if do require './mutex'

N=0

fs.readdirSync __dirname
.forEach (f)-> setImmediate ->
  return unless '.coffee' == path.extname f
  require "./#{f}"
