###
Test asynchronous enumeration
###
assert = require 'assert'

async = require '..'
  .async

N = 0
async (error, crt)->
  throw error if error
  unless crt
    console.log 'Async:', N
    return
  N++
  assert crt.serialNumber
