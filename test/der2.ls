require! <[ path fs assert node-forge ./me ]>

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding

pem = fs.readFileSync <| path.join __dirname, 'uxm.pem'
export der = buffer-from nodeForge.pem.decode(pem)[0].body, 'binary'

<-! context "DER converters"

specify "work" !->
  for k, v of me.der2
    continue
    #  TODO
    assert.equal do
      typeof me.der2 v, der
      if k.length >3
        "object"
      else
        "string"

specify "are curried" !->
  for , v of me.der2
    assertEq do
      me.der2 v, der
      me.der2 v <| der

specify "do nothing by default" !->
  fn = me.der2!
  for i from -5 to 5
    assert.equal i, fn i

!function assertEq(a, b)
  assert.equal do
    JSON.stringify a
    JSON.stringify b
