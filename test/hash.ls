require! <[ assert ./me ./samples ./openssl ]>

toPEM = me.der2 me.der2.pem

predefined =
  uxm: <[ 3aa90a40 09926f58 ]>
  omz: <[ 4b12afa3 fa6b551d ]>

<-! context \X509_NAME_hash

hashers =
  me.hash 0
  me.hash!

function ourHashes(der)
  <- hashers.map
  it der

specify "match for known certificates" !->
  for k, v in samples
    assert.deepEqual do
      predefined[k]
      ourHashes samples.uxm

<-! context "match"

var runner

before ->
  <- openssl.then
  runner := it

beforeEach ->
  @skip unless runner

<- specify "with OpenSSL"
resolve, reject <-! new Promise _
chain = Promise.resolve!
me do
  async: true
  onend: !->
    chain.then resolve, reject
  ondata: more

!function more(der)
  chain .= then -> der
    .then opensslHashes

function opensslHashes(der)
  resolve, reject <-! new Promise _
  runner 'x509 -noout -subject_hash_old -subject_hash' callback
    .end toPEM der

  !function callback(error, value)
    if error
      reject error
    else
      value .= trim!split /\s+/
      assert.deepEqual do
        value
        ourHashes der
      resolve value

