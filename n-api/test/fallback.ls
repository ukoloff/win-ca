require! <[ path child_process ./common]>

bin = path.join __dirname, \../build/Release/roots

suite "Fallback @#{process.arch}" ->

  suite "sync" ->
    title = @title

    for name, args of common.samples
      let name, args
        splitter = common.splitter title, name
        # Generate test
        <-! test name
        splitter.end do
          child_process.spawnSync bin, args .stdout

  suite "async" ->
    title = @title

    for name, args of common.samples
      let name, args
        splitter = common.splitter title, name
        # Generate test
        <- test name
        var callback
        out = new Promise (resolve, reject) -> callback := resolve

        child_process.spawn bin, args
        .stdout
        .pipe splitter
        .on \end callback

        # Return promise to make test async
        out
