###
Format parts of certificate
###
pki = require 'node-forge'
  .pki
self = require '../package'

@subject
subject = (crt)->
  crt.subject.attributes.map (rdn)->
    "/#{rdn.shortName || rdn.name || rdn.type}=#{rdn.value}"

subject.join = ''

@valid =
valid = (crt)->
  for k in crt.validity
    x[k].toISOString()

valid.join = ' - '

@saved = ->
  "#{new Date} by #{self.name}@#{self.version}"

@pem =
pem = (crt)->
  pki.certificateToPem crt

pem.title = false
