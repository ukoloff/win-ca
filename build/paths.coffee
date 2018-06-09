path = require 'path'

@package =
pckg = require '../package'

@root =
root = path.join __dirname, '..'

@src = path.join root, 'src'

@dst = path.join root, pckg.files[0]
