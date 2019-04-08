require! <[ assert split node-forge ]>

@samples =
  total:  <[]>
  root:   <[ root ]>
  ca:     <[ ca ]>
  both:   <[ root ca ]>

suiteTeardown ~>
  check @sync
  check @async

  equal @sync, @async

@splitter = splitter

bufferFrom = Buffer.from || (data, encoding)->
  new Buffer data, encoding

# Build Splitter for line count
~function splitter(title, variable)
  split !~>
    return unless it.length

    tree = bufferFrom it, 'hex'
      .toString 'binary'
      |> nodeForge.asn1.fromDer
    assert tree.value.length, "Invalid certificate"

    store = @[title] ||= {}
    store[variable] ||= 0
    value = ++store[variable]
    assert value < 1000, "Too many certificates in store"

# Final checks...
function check
  return unless it
  for k, v of it
    assert v > 5, "Five certificates in store required"

  assert it.total == it.root
  assert it.root + it.ca == it.both

function equal(a, b)
  eq a, b
  eq b, a

  function eq(a, b)
    for k, v of a
      assert v == b[k]

<~ process.on \exit
console.log \Total: @sync.total
