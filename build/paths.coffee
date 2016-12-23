path = require 'path'

@package =
pckg = require '../package'

@root =
root = path.join __dirname, '..'

for f in 'src top'.split ' '
  @[f] = path.join root, f

@dst = path.join root, pckg.files[0]
