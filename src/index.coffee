if process.platform != 'win32'
  return

require './format.oids'

@der2 = require './der2'

@each = if @nApi = !!process.versions.napi
  require './each'
else
  require './each.fallback'

@all = ->
  require './all'

require './inject'
@path =  require './save'
  .path
