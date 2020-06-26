require! <[ assert node-forge ./me ]>

export samples =
  total:  <[ ]>
  root:   <[ root ]>
  ca:     <[ ca ]>
  both:   <[ root ca ]>

counts = {}

# Final check
after !->
  var first
  for k, v of counts
    check-counts v
    if first
      assert.deepEqual v, first
    else
      first = v

# Build Checker if Buffer is valid X509 certificate (and count it)
export function assert509(mocha-test)
  suite = mocha-test .= test
  suite = while suite .= parent
    suite.title.slice 0 1
  suite .= reverse!join '' .toLowerCase!
  store = counts[suite] ||= {}
  store[variable = mocha-test.title] ||= 0

  !->
    assert Buffer.is-buffer it
    tree = it
      .toString 'binary'
      |> nodeForge.asn1.fromDer
    assert tree.value.length, "Invalid certificate"

    assert ++store[variable] < 1000, "Too many certificates in store"

!function check-counts
  return if me.disabled

  assert.equal it.total, it.root
  assert.equal it.root + it.ca, it.both

  assert it.root >= 3, "Three root certificates required"
