exports <<< {all, each}

each.async = async

!function each
  upgradeAPI &

!function async
  upgradeAPI & do
    async: true

function all
  result = []
  upgradeAPI & do
    ondata: !->
      result.push it
    onend: ->
  result

!function upgradeAPI(args, defaults = {})
  format = args[0]

  defaults.unique = false

  defaults.format ?= format ? api.der2.x509

  cb = args[1] or format
  defaults.ondata ?= !->
    cb? void, it
  defaults.onend ?= !->
    cb?!

  defaults |> require \.
