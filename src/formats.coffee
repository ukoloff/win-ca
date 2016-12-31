###
Format parts of certificate
###
pki = require 'node-forge'
  .pki
self = require '../package'

@subject =
subject = (crt)->
  crt.subject.attributes.map (rdn)->
    "/#{rdn.shortName || rdn.name || rdn.type}=#{rdn.value}"

subject.join = ''

@valid =
valid = (crt)->
  for k, v of crt.validity
    v.toISOString()

valid.join = ' - '

@saved = ->
  d = new Date
  "#{d.toLocaleDateString()} #{
    d.toTimeString().replace /\s*\(.*\)\s*/, ''} by #{self.name}@#{self.version}"

@pem =
pem = (crt)->
  pki.certificateToPem crt

pem.title = false
