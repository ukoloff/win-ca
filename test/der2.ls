require! <[ path fs assert node-forge ./me ./samples ]>

uxm = samples.uxm

<-! context "DER converters"

specify "work" !->
  assert Buffer.isBuffer    me.der2 me.der2.der, uxm
  assert "string" == typeof me.der2 me.der2.pem, uxm
  assert "string" == typeof me.der2 me.der2.txt, uxm
  assert "object" == typeof me.der2 me.der2.asn1, uxm
  assert "object" == typeof me.der2 me.der2.x509, uxm

specify "are curried" !->
  for , v of me.der2
    assertEq do
      me.der2 v, uxm
      me.der2 v <| uxm

specify "do nothing by default" !->
  fn = me.der2!
  for k of me.der2
    assert.equal do
      k
      fn k .toString \binary

!function assertEq(a, b)
  assert.equal do
    JSON.stringify a
    JSON.stringify b
