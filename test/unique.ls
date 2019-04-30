require! <[ assert ./me ]>

<-! context \Deduplication

specify "shrinks data" !->
  assert count! <= count unique: false

specify "removes duplicates" !->
  assert.equal do
    count store: <[ ca ca]>
    count store: \ca

  assert.equal do
    count do
      store: <[ ca ca]>
      unique: false
    2 * count do
      store: \ca
      unique: false

function count(params = {})
  N = 0
  params.ondata = !->
    assert Buffer.is-buffer it
    N++
  me params
  N
