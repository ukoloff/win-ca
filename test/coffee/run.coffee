ca = require '..'

process.on "exit", ->
  console.log "Root CAs saved to", ca.path
