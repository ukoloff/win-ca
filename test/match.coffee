###
Test for hashes match with OpenSSL
###
spawn = require 'child_process'
  .spawn

run = (args, cb)->
  out = ''
  child = spawn 'openssl', args
  child.on 'error', (error)->
    out = null
    cb error
  child.stdout
  .on 'data', (data)->
    out += data if out?
  .on 'end', ->
    cb null, out.trim()  if out?
  child.stdin

run ['version'], (error, ver)->
  if error
    console.error 'OpenSSL not found. Skipping hashes test...'
    return
  console.log 'Found:', ver
  list = require '..'
    .all().slice()
