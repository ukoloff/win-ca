###
Format Certificate output
###
forge = require 'node-forge'

module.exports =
format = (crt)->
  formats crt
  .join '\n'

formats = (crt)->
  for k, v of require './formats'
    s = v crt
    if v.join?
      s = s.join v.join
    if false != v.title
      s = "#{k.replace /./, (s)->s.toUpperCase()}\t#{s}"
    s

# Add OIDs
do
format.oids =
oids = ->
  list = forge.oids
  for k, v of require './oids'
    list[v] = k
    list[k] = v
  return
