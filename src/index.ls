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

/*****************************************************************************************
if api == require \../api
  api {+inject, +save}
*****************************************************************************************/

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
  member = if async = params.async then \async else \sync

  engine = if disabled
    require \./none
  else if params.fallback ? !nApi
    require \./fallback
  else
    require \./n-api
  engine .= [member]

  if false != params.unique
    unique = do require \./unique

  unless store = params.store
    store = []
  else unless Array.isArray store
    store = [store]

  engine = engine store

  if params.generator
    return do if async then asyncGenerator else syncGenerator

  engine.run Process

  !function Process
    if async
      if it
        params.ondata? it
      else
        params.onend?!
    else
      if it
        later -> params.ondata? it
      else
        later -> params.onend?!

  function Return
    engine.done!
    done: true
    value: it

  function syncGenerator
    (Symbol.iterator): myself
    return: Return
    next: ->
      while der = engine.next! and unique and not unique der
        void
      Process der
      done: !der
      value: der

  function asyncGenerator
    (Symbol.asyncIterator ? '@') : myself
    return: Return
    next: ->
      do function fire
        Promise.resolve!
        .next engine.next
        .next ->
          if it and unique and !unique it
            fire!
          else
            Process it
            done: !it
            value: it

function myself
  @

function later
  Promise.resolve!then later
