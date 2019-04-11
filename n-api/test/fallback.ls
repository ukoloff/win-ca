require! <[ path child_process split ./common ]>

bin = path.join __dirname, \../build/Release/roots

suite "Fallback @#{process.arch}" ->

  suite "sync" !->
    title = @title

    for let name, args of common.samples
      # Generate test
      <-! test name
      splitter title, name
      .end do
        child_process.spawnSync bin, args
        .stdout

  suite "async" !->
    title = @title

    for let name, args of common.samples
      # Generate test
      <- test name
      # Return promise to make test async
      new Promise !->
        child_process.spawn bin, args
        .stdout
        .pipe splitter title, name
        .on \end it

bufferFrom = Buffer.from || (data, encoding)->
  new Buffer data, encoding

function unHex
  bufferFrom it, 'hex'

function splitter(title, name)
  split common.assert509 title, name, unHex
