require! <[ path fs assert node-forge ./me ]>

pem = fs.readFileSync <| path.join __dirname, 'uxm.pem'
export der = nodeForge.pem.decode(pem)[0].body

<-! context "DER converters"

specify "work" !->
  for k, v of me.der2
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
