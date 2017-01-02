fs = require 'fs'
path = require 'path'

return if do require './mutex'

fs.readdirSync __dirname
.forEach (f)-> setImmediate ->
  return unless '.coffee' == path.extname f
  try
    require "./#{f}"
  catch e
    console.error e.message
    console.log e.stack
