require! {
  child_process: {spawn}
  \appveyor-mocha
}

module.exports = new Promise testRun

function testRun(success)
  run 'version', (error, ver)->
    success if error then run

    <- process.on \exit
    appveyorMocha.log "Found: #{if error then 'No OpenSSL' else ver}"

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
