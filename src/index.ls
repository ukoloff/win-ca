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
  else unless Array.is-array store
    store = [store]

  engine .= [if async = params.async then \async else \sync] store

  Process = if async then async-process else sync-process

  if false != params.unique
    unique = do require \./unique

  mapper = der2 params.format

  if Array.is-array params.ondata
    params.ondata .= push.bind params.ondata

  if params.save or params.$ave
    saver = require \./save <| params

  if params.inject
    injector = require \./inject <| params.inject

  if params.generator
    return do if async then async-generator else sync-generator

  engine.run !->
    if !it or !unique or unique it
      Process it

  !function sync-process
    if saver
      saver it

    if it
      if injector
        injector it
      params.ondata? mapper it
    else
      params.onend?!

  !function async-process
    Promise.resolve it
    .then sync-process

  function sync-generator
    (Symbol.iterator): myself
    return: Return
    next:   sync-next

  function async-generator
    (Symbol.async-iterator ? '@') : myself
    return: Return
    next:   async-next

  function gen-process
    Process it
    done: !it
    value: if it? then mapper it else it

  function Return
    engine.done!
    done: true
    value: it

  function sync-next
    while (der = engine.next!) and unique and not unique der
      void
    genProcess der

  function async-next
    function fire
      Promise.resolve!
      .then engine.next
      .then ->
        if it and unique and !unique it
          fire!
        else
          gen-process it
    fire!

function myself
  @
