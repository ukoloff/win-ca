require! <[ path assert node-forge ./me ./samples ]>

checkers =
  der: der-check
  pem: pem-check
  txt: txt-check
  asn1: asn1-check
  x509: x509-check

exports <<< checkers
delete exports.x509

context "DER converters" !->
  specify "work" !->
    for _, pem of samples
      for k, v of checkers
        v me.der2 me.der2[k], pem

  specify "are curried" !->
    for k, _ of checkers
      fn = me.der2 format = me.der2[k]
      for _, pem of samples
        assert-eq do
          me.der2 format, pem
          fn pem

  specify "do nothing by default" !->
    fn = me.der2!
    for k of me.der2
      assert.equal do
        k
        fn k .to-string \binary
    for _, v of samples
      assert-eq do
        v
        fn v

!function assert-eq(a, b)
  assert.equal do
    JSON.stringify a
    JSON.stringify b

function der-check
  assert Buffer.is-buffer it

function pem-check
  assert.equal \string typeof it
  assert /\n$/.test it
  pem = node-forge.pem.decode it
  assert.equal 1 pem.length

txtFields =
  /\bSubject\s+/i
  /\bValid\s+/i

function txt-check
  pemCheck it
  for re in txtFields
    assert re.test it

function asn1-check
  assert.equal \object typeof it
  assert.deep-equal do
    Object.keys it
    <[ serial valid issuer subject ]>

function x509-check
  assert.equal \object typeof it
  assert it.validity
  assert it.subject
  assert it.issuer
