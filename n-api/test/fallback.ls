require! <[ assert path child_process split ]>

bin = path.join __dirname, \../build/Release/roots

suite "Fallback @#{process.arch}" ->
  var Total, Root, CA, Both

  test "defaults" ->
    Total := count!
    assert Total > 10

  test "default is Root" ->
    Root := count ['root']

  test "CA" ->
    CA := count ['ca']

  test "several stores" ->
    Both := count ['root', 'ca']

  suiteTeardown "loses nothing" ->
    assert Total == Root
    assert Root + CA == Both

  function count(args = [])
    lines = 0
    split -> if it.length then ++lines
    .end do
      child_process.spawnSync bin, args .stdout
    assert lines > 5, "Five certificates required"
    lines
