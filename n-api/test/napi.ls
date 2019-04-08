require! <[ ./common]>


suite "N-API @#{process.arch}" ->

  title = \DLL

  for name, args of common.samples
    let name, args
      splitter = common.splitter title, name
      # Generate test
      <-! test name

