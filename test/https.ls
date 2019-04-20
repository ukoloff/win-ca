require! <[ crypto https url split node-forge ./me ]>

pki = node-forge.pki

<-! context \HTTPS

CA = newX509!
Crt = newX509 CA
var Server, Port

before "Un-inject" !->
  me.inject!

before "Start Web-server" ->
  resolve <-! new Promise _
  Server := https.create-server do
    key: Crt.key-pem
    cert: Crt.crt-pem
    https-get
  .listen !->
    Port := @address!port
    resolve!

after "Stop Web-server" !->
  Server.close!

context \self-signed ->
  specify 'fails w/o certificate' ->
    revert fetch!

  specify 'requires certificate' ->
    fetch do
      ca: [CA.crt-pem]

context \well-known !->
  Yandex = \https://www.google.com/

  specify 'fails w/o certificate' ->
    revert fetch do
      url: Yandex
      agent: new https.Agent ca: []

  specify 'requires certificate' ->
    fetch do
      url: Yandex

function https-get(req, res)
  req.pipe split reverse
  .pipe res

function reverse(str)
  str.split '' .reverse!.join ''

function fetch(options = {})
  uri = options.url || \https://localhost
  opts = {}
  opts <<<< if url.URL
    new url.URL uri
  else
    url.parse uri
  opts <<<< options
  delete opts.url
  unless options.url
    opts <<<
      port: Port

  resolve, reject <-! new Promise _
  https.get opts, !-> resolve @
  .on \error reject

function revert(fetch-promise)
  fetch-promise
  .then do
    ->
      Promise.reject Error 'Connected w/o certificate'
    ->
      unless it.code in <[ UNABLE_TO_VERIFY_LEAF_SIGNATURE UNABLE_TO_GET_ISSUER_CERT_LOCALLY ]>
        Promise.reject it

function newX509(signer)
  rsa = pki.rsa.generate-key-pair 1024
  crt = pki.create-certificate!

  crt.serial-number = random 4
  crt.validity.not-before = new Date +new Date! - 1000 * 60 * 60
  crt.validity.not-after =  new Date +new Date! + 1000 * 60 * 60

  crt.set-subject attrs =
    name: \commonName
    value: random 11
    ...
  crt.set-extensions exts =
    * name: \basicConstraints
      cA: !signer
    * name: \subjectAltName
      alt-names:
        type: 6 # URI
        value: \https://localhost
        ...

  crt.public-key = rsa.public-key

  result =
    crt: crt
    key: rsa.private-key
    key-pem: pki.private-key-to-pem rsa.private-key

  signer ?= result

  crt.set-issuer signer.crt.subject.attributes
  crt.sign signer.key

  result.crt-pem = pki.certificate-to-pem crt

  result

function random(n = 0)
  crypto.createHash \md5
    .update "#{Math.random!}/#{+new Date}"
    .digest \hex
    .slice -n
