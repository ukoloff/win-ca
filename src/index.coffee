if process.platform == 'win32'
  require './format.oids'

  @der2 = require './der2'

  nApi = !!process.versions.napi
  nApi &&= @ == require '../fallback'
  nApi &&= not @electron = do require 'is-electron'

  @each = require if @nApi = nApi
    './each'
  else
    './each.fallback'

  @all = require './all'

  require './inject'
  require './save'
