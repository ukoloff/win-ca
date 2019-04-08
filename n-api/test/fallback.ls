require! <[ assert path child_process split ]>

bin = path.join __dirname, \../build/Release/roots

suite "Fallback @#{process.arch}" ->
  var Total, Root, CA, Both, Async

  suite "sync" ->

    test "defaults" ->
      Total := count!
      assert Total > 10

    test "default is Root" ->
      Root := count <[ root ]>

    test "CA" ->
      CA := count <[ ca ]>

    test "several stores" ->
      Both := count <[ root ca ]>

    suiteTeardown "loses nothing" ->
      assert Total == Root
      assert Root + CA == Both

      <- process.on \exit
      console.log \Total: Total

    function count(args = [])
      lines = 0
      split -> if it.length then ++lines
      .end do
        child_process.spawnSync bin, args .stdout
      assert lines > 5, "Five certificates required"
      lines

  suite "async" ->

    test "defaults" ->
      <- count!then 
      Async := it

    test "CA" ->
      count <[ ca ]>

    test "several stores" ->
      count <[ root ca ]>

    function count(args = [])
      lines = 0
      var callback
      out = new Promise (resolve, reject) -> callback := resolve
      child_process.spawn bin, args
      .stdout
      .pipe do
        split -> if it.length then ++lines
      .on \end callback
      <- out.then
      checkCount lines

  suiteTeardown "loses nothing" ->
    assert Total == Async

function checkCount
  assert it > 5, "Five certificates required"
  it
