###
Inject Root CAs into Node.js
###
https = require 'https'

all = require './all'
der2 = require './der2'

ca = https.globalAgent.options.ca ||= []

ca.push.apply ca, all der2.pem
