require! <[ assert path ./samples ./me ]>

context "Fake Root sources" !->
  specify "work in fallback mode" !->
    me.exe path.join __dirname, \fake/fake.bat
    roots = []
    me do
      fallback: true
      ondata: roots
    assert.deepEqual roots, [v for k, v of samples]
    me.exe!
