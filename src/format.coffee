###
Format Certificate output
###
module.exports = (crt)->
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
