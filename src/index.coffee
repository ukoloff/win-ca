if process.platform != 'win32'
  return

require './format.oids'

isElectron = require 'is-electron'

@der2 = require './der2'

@electron = electron = do isElectron
@each = if !electron and @nApi = !!process.versions.napi
  require './each'
else
  require './each.fallback'

@all = require './all'

require './inject'
@path =  require './save'
  .path
