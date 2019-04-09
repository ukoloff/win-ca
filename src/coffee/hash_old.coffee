###
X509_NAME_hash_old
###
crypto = require 'crypto'

asn1 = require 'node-forge'
  .asn1

der2 = require './der2'
hex = require './hex'

module.exports = (der)->
  md5 = crypto.createHash 'md5'
  subj = der2 der2.asn1, der
    .subject
  md5.update asn1.toDer(subj).getBytes(), 'binary'
  hex md5
