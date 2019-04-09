module.exports = api

api <<<
  der2: require \./der2
  all:  all
  each: each
each.async = async

# API v[12]
!function each
  api upgradeParams &

!function async
  api upgradeParams & do
    async: true

function all
  result = []
  api upgradeParams & do
    ondata: ->
      result.push it
    onend: ->
  result

function upgradeParams(args, defaults = {})
  format = args[0]
  defaults.format ?= if api.der2[format]?
    api.der2[* - 1]
  else
    format

  cb = args[1] or format
  defaults.ondata ?= !->
    cb? void, it
  defaults.onend ?= !->
    cb?!

  defaults

# API v3
function api
  void
