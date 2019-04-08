require! <[ path child_process split ./common ]>

bin = path.join __dirname, \../build/Release/roots

suite "Fallback @#{process.arch}" ->

  suite "sync" !->
    title = @title

    for let name, args of common.samples
      # Generate test
      <-! test name
      split do
        common.assert509 title, name, unHex
      .end do
        child_process.spawnSync bin, args
        .stdout

  suite "async" !->
    title = @title

    for let name, args of common.samples
      # Generate test
      <- test name
      var callback
      out = new Promise (resolve, reject) ->
        callback := resolve

      child_process.spawn bin, args
      .stdout
      .pipe do
        split common.assert509 title, name, unHex
      .on \end callback

      # Return promise to make test async
      out

bufferFrom = Buffer.from || (data, encoding)->
  new Buffer data, encoding

function unHex
  bufferFrom it, 'hex'
