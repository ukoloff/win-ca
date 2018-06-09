if process.platform != 'win32'
  return

require './format.oids'

@all = ->
  require './all'

require './inject'
@path =  require './save'
  .path

@each = require './each'

@async = (cb)->
  require('./async') cb
