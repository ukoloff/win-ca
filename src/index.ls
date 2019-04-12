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

/**********************************************************************************
if api == require \../api
  api {+inject, +save}
**********************************************************************************/

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
!function api(params)
  engine = if disabled
    require \./none
  else if params.fallback ? !nApi
    require \./fallback
  else
    require \./n-api

  unless store = params.store
    store = []
  else unless Array.isArray store
    store = [store]

  engine .= [if async = params.async then \async else \sync] store

  Process = if async then asyncProcess else syncProcess

  if false != params.unique
    unique = do require \./unique

  if params.generator
    return do if async then asyncGenerator else syncGenerator

  engine.run !->
    if !it or !unique or unique it
      Process it

  !function syncProcess
    if it
      params.ondata? it
    else
      params.onend?!

  !function asyncProcess
    Promise.resolve it
    .next syncProcess

  function syncGenerator
    (Symbol.iterator): myself
    return: Return
    next:   syncNext

  function asyncGenerator
    (Symbol.asyncIterator ? '@') : myself
    return: Return
    next:   asyncNext

  function genProcess
    Process it
    done: !it
    value: it

  function Return
    engine.done!
    done: true
    value: it

  function syncNext
    while (der = engine.next!) and unique and not unique der
      void
    genProcess der

  function asyncNext
    do function fire
      Promise.resolve!
      .next engine.next
      .next ->
        if it and unique and !unique it
          fire!
        else
          genProcess it

function myself
  @
