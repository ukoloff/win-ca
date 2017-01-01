###
Inject Root CAs into Node.js
###
https = require 'https'

forge = require 'node-forge'

pki = forge.pki

ca = https.globalAgent.options.ca ||= []

for crt in require './all'
  ca.push pki.certificateToPem crt
