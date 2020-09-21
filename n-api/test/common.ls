require! <[ assert node-forge ]>

export samples =
  total:  <[ ]>
  root:   <[ root ]>
  ca:     <[ ca ]>
  both:   <[ root ca ]>

# Final checks...
suiteTeardown ~>
  check @sync
  check @async
  check @DLL

  equal @sync, @async
  equal @sync, @DLL   if @DLL

function check
  return unless it

  assert it.total == it.root
  assert it.root + it.ca == it.both

  assert it.root >= 3, "Three root certificates required"

function equal(a, b)
  eq a, b
  eq b, a

  !function eq(a, b)
    for k, v of a
      assert v == b[k]

bufferFrom = Buffer.from || (data, encoding)->
  new Buffer data, encoding

# Build Checker if Buffer is valid X509 certificate (and count it)
export ~function assert509(title, variable, preprocess = -> it)
  store = @[title] ||= {}
  store[variable] ||= 0

  !~>
    return unless it.length

    tree = preprocess it
      .toString 'binary'
      |> nodeForge.asn1.fromDer
    assert tree.value.length, "Invalid certificate"

    assert ++store[variable] < 1000, "Too many certificates in store"

<~! process.on \exit
console.log \Total: @sync.total
