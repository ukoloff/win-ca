require! <[ assert ./me ./samples ./openssl ]>

toPEM = me.der2 me.der2.pem

predefined =
  uxm:    <[ 3aa90a40 09926f58 ]>
  omz:    <[ 4b12afa3 fa6b551d ]>
  certum: <[ 95aff9e3 48bec511 ]>

<-! context \X509_NAME_hash

hashers =
  me.hash 0
  me.hash!

function ourHashes(der)
  <- hashers.map
  it der

specify "match for known certificates" !->
  for k, v of samples
    assert.deepEqual do
      predefined[k]
      ourHashes v

<-! context "match"

var runner

before ->
  <- openssl.then
  runner := it

beforeEach ->
  @skip! unless runner

<- specify "with OpenSSL"
resolve, reject <-! new Promise _
list = []
me do
  async: true
  onend: !->
    Promise.all list
      .then resolve, reject
  ondata: more

!function more(der)
  list.push <| randomDelay der .then opensslHashes

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

function randomDelay(value)
  resolve <-! new Promise _
  <-! setTimeout _, 27 * Math.random!
  resolve value
