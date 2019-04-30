require! {
  child_process: {spawn}
  \appveyor-mocha
}

module.exports = binary = new Promise testRun

after !->
  <-! binary.then
  appveyor-mocha.log "Found:\t#{if it then it.version else 'No OpenSSL'}"

function testRun(success)
  run 'version', (error, ver)->
    success unless error then run

    run.version = ver

    <- process.on \exit

function run(args, cb)
  if "string" == typeof args
    args .= split /\s+/
  out = ''
  child = spawn 'openssl', args
  child.on 'error', !->
    out := void
    cb it
  child.stdout
  .on \data !->
    out ? += it
  .on \end !->
    cb void, out.trim()  if out?
  child.stdin
