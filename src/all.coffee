###
Fetch all root CAs
###
e = require './enum'
require './format'

module.exports =
all = []

e (crt)->
  all.push crt
