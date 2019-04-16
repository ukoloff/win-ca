require! <[ assert node-forge ./me ]>

checkers =
  der: derCheck
  pem: pemCheck
  txt: txtCheck
  asn1: asn1check

context "Legacy API" !->

  context \all, !->

    for let k, v of checkers
      <-! specify k
      me.all me.der2[k]
        .forEach v

  context "each" !->

    for let k, v of checkers
      <-! specify k
      finished = 0
      me.each do
        me.der2[k]
        callback
      assert.equal 1, finished

      !function callback(err, value)
        assert !err
        if value
          v value
        else
          finished++

    context "async" ->

      for let k, v of checkers
        <-! specify k
        finished = 0
        resolve, reject <-! new Promise _
        me.each.async do
          me.der2[k]
          callback

        !function callback(err, value)
          if err
            reject err
          else if value
            v value
          else if finished++
            reject Error 'Multiple ends'
          else
            resolve!

function derCheck
  assert Buffer.is-buffer it

function pemCheck
  assert.equal \string typeof it
  assert /\n$/.test it
  pem = nodeForge.pem.decode it
  assert.equal 1 pem.length

txtFields =
  /\bSubject\s+/i
  /\bValid\s+/i
  /\bSaved\s+/i

function txtCheck
  pemCheck it
  for re in txtFields
    assert re.test it

function asn1check
  assert.equal \object typeof it
