module.exports = api

api <<<
  disabled: disabled = process.platform != 'win32'
  n-api: n-api = !!process.versions.napi
    and api == require \../fallback
    and not api.electron = do require \is-electron
  der2: der2 = require \./der2
  hash: hash
  inject: inject

api <<<< require \./v2

if !disabled and api == require \../api
  api {+inject, +$ave, +async}

function hash
  (api.hash = require \./hash) ...

function inject
  (api.inject = require \./inject .inject) ...

# API v3
!function api(params = {})
  engine = if disabled or params.disabled
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

  mapper = der2 params.format

  if params.save or params.$ave
    saver = require \./save <| params

  if params.inject
    injector = require \./inject <| params.inject

  if params.generator
    return do if async then asyncGenerator else syncGenerator

  engine.run !->
    if !it or !unique or unique it
      Process it

  !function syncProcess
    if saver
      saver it

    if it
      if injector
        injector it
      params.ondata? mapper it
    else
      params.onend?!

  !function asyncProcess
    Promise.resolve it
    .then syncProcess

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
    value: if it? then mapper it else it

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
      .then engine.next
      .then ->
        if it and unique and !unique it
          fire!
        else
          genProcess it

function myself
  @
