suite "LiveScript @#{process.arch}" ->
  test "is ok" ->

  test "async" ->
    new Promise delay

function delay
  setTimeout it, 500

