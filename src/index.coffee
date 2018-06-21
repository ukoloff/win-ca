if process.platform != 'win32'
  return

require './format.oids'

@each = if @nApi = !!process.versions.napi
  require './each'
else
  require './each.fallback'

@all = ->
  require './all'

require './inject'
@path =  require './save'
  .path
