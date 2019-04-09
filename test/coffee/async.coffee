###
Test asynchronous enumeration
###
assert = require 'assert'

me = require '..'

N = 0

me.each.async me.der2.asn1, (error, crt)->
  throw error if error
  unless crt
    console.log 'Async:', N
    return
  N++
  assert crt.subject
