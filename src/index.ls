module.exports = api

api <<<
  disabled: disabled = process.platform != 'win32'
  n-api: n-api = !!process.versions.napi
    and api == require \../fallback
    and not api.electron = do require \is-electron
  der2: require \./der2
  all:  all
  each: each
each.async = async

if api == require \../api
  api {+inject, +save}

# API v[12]
!function each
  upgradeAPI &

!function async
  upgradeAPI & do
    async: true

function all
  result = []
  upgradeAPI & do
    ondata: ->
      result.push it
    onend: ->
  result

!function upgradeAPI(args, defaults = {})
  format = args[0]
  defaults.format ?= if api.der2[format]?
    format
  else
    api.der2.forge

  cb = args[1] or format
  defaults.ondata ?= !->
    cb? void, it
  defaults.onend ?= !->
    cb?!

  api defaults

# API v3
!function api
  member = if it.async then \async else \sync

  engine = if disabled
    require \./none
  else if it.fallback ? !nApi
    require \./fallback
  else
    require \./n-api
  engine .= [member]

  data =
    onend: ->

  if it.generator
    data.$ = engine
    return require \./generator .[member] data

  engine data

