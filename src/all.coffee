###
Fetch all root CAs
###
e = require './enum'
module.exports =
all = []

e (crt)->
  all.push crt
