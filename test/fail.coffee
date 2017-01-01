###
Fail HTTPS request when no Root CAs available
###
url = require 'url'
https = require 'https'

options = url.parse 'https://ya.ru'
options.agent = new https.Agent ca: []
https.get options, ->
  throw Error 'HTTPS without Root CAs succeeded!'
.on 'error', ->
  console.log 'HTTPS is tested to fail without Root CAs.'
