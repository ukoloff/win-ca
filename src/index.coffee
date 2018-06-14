if process.platform != 'win32'
  return

require './format.oids'

if @nApi = !!process.versions.napi
  each = require './each'
  each.async = require './async'
else
  each = require './each.fallback'
  each.async = require './async.fallback'
@each = each

@all = ->
  require './all'

require './inject'
@path =  require './save'
  .path
