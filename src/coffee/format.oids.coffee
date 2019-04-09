###
Add our OIDs
###
forge = require 'node-forge'

list = forge.oids
for k, v of require './oids'
  list[v] = k
  list[k] = v
