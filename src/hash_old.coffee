###
X509_NAME_hash_old
###
crypto = require 'crypto'

asn1 = require 'node-forge'
  .asn1

der2 = require './der2'

module.exports = (der)->
  md5 = crypto.createHash 'md5'
  subj = der2 der2.asn1, der
    .subject
  md5.update asn1.toDer(subj).getBytes(), 'binary'
  hex md5

hex = (hash)->
  hash = hash.digest().slice 0, 4
  # Buffer::swap32()
  hash.writeUInt32LE hash.readUInt32BE(0), 0
  hash.toString 'hex'
