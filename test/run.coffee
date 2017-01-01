require '..'

process.on "exit", ->
  console.log "Root CAs saved to", process.env.SSL_CERT_DIR
