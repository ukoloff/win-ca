if process.platform != 'win32'
  return

require './format.oids'

if @nApi = !!process.versions.napi
  each = require './each'
else
  each = require './each.fallback'
@each = each

@all = ->
  require './all'

require './inject'
@path =  require './save'
  .path
