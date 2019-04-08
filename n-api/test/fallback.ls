require! <[ assert path child_process split ./common]>

bin = path.join __dirname, \../build/Release/roots

suite "Fallback @#{process.arch}" ->
  var Total, Root, CA, Both, Async

  suite "sync" ->
    title = @title

    for name, args of common.samples
      let name, args
        store = common.store title, name
        <-! test name
        count args, store

    !function count(args, store)
      split store
      .end do
        child_process.spawnSync bin, args .stdout

  suite "async" ->
    title = @title

    for name, args of common.samples
      let name, args
        store = common.store title, name
        <- test name
        count args, store

    function count(args, store)
      lines = 0
      var callback
      out = new Promise (resolve, reject) -> callback := resolve

      child_process.spawn bin, args
      .stdout
      .pipe do
        split store
      .on \end callback
      out
