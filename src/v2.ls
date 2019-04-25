exports <<< {all, each}

each.async = async

!function each
  upgradeAPI & params =
    ondata: !-> params.v2cb? it

!function async
  upgradeAPI & params =
    async: true
    ondata: !-> params.v2cb? void it
    onend:  !-> params.v2cb?!

function all
  upgradeAPI & do
    ondata: result = []
  result

!function upgradeAPI(args, defaults)
  api = require \.
  format = args[0]

  defaults <<<
    unique: false
    format: format ? api.der2.x509
    v2cb:   args[1] or format

  api defaults
