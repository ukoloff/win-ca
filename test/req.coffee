assert = require 'assert'
https = require 'https'

require '..'

assert Array.isArray ca = https.globalAgent.options.ca
assert ca.length

https.get uri = 'https://ya.ru', ->
  console.log "HTTPS GET", uri, "succeeded."
