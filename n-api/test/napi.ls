require! <[ ./common]>


suite "N-API @#{process.arch}" !->

  title = \DLL

  for name, args of common.samples
    let name, args
      assert509 = common.assert509 title, name
      # Generate test
      <-! test name
