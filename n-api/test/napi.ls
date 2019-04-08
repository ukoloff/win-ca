require! <[ ./common ]>


suite "N-API @#{process.arch}" !->

  title = \DLL

  setup ->
    @skip!

  for let name, args of common.samples
    # Generate test
    <-! test name
    assert509 = common.assert509 title, name
