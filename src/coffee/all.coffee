###
Fetch all root CAs
###
crypto = require 'crypto'

der2 = require './der2'

all = []

module.exports = (format)->
  all.map (der)->
    der2 format, der

sha1 = (data)->
  crypto.createHash 'sha1'
  .update data, 'binary'
  .digest 'hex'

seen = {}

require '..'
.each der2.der, (der)->
  if not seen[z = sha1 der]
    seen[z] = 1
    all.push der
  return
