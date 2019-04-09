require! <[ ./common ]>

suite "N-API @#{process.arch}" !->

  title = \DLL

  var crypt32

  setup ->
    @skip!  unless process.versions.napi

  for let name, args of common.samples
    # Generate test
    <-! test name
    crypt32 := require \bindings <| \crypt32 unless crypt32

    stores = for let store in args
      -> crypt32 store
    else
      [-> crypt32!]

    assert509 = common.assert509 title, name
    for let store in stores
      handle = store!
      while handle.next!
        assert509 that
      handle.done!
