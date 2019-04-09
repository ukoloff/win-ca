###
Format OpenSSL-style hash
###
module.exports = (hash)->
  hash = hash.digest().slice 0, 4
  # Buffer::swap32()
  hash.writeUInt32LE hash.readUInt32BE(0), 0
  hash.toString 'hex'
