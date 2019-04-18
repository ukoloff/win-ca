require! <[ crypto https url split node-forge ]>

pki = node-forge.pki

<-! context \Web-server

CA = newX509!
Crt = newX509 CA
var Server, Port

before "Start Web-server" ->
  resolve <-! new Promise _
  Server := https.create-server do
    key: Crt.key-pem
    cert: Crt.crt-pem
    https-get
  .listen !->
    Port := @address!port
    resolve!

after "Stop Web-server" ->
  Server.close!

specify 'fails w/o certificate' ->
  resolve, reject <-! new Promise _
  options = URL 'https://localhost'
  options <<<
    port: Port
  https.get options, !->
    reject Error 'Connected w/o certificate'
  .on \error ->
    if it.message.match /unable\s+to\s+verify/
      resolve!
    else
      reject it

specify 'requires certificate' ->
  resolve, reject <-! new Promise _
  options = URL 'https://localhost'
  options <<<
    port: Port
    ca: [CA.crt-pem]
  https.get options, handle
  .on \error reject

  function handle(resp)
    resolve!

function https-get(req, res)
  req.pipe split reverse
  .pipe res

function reverse(str)
  str.split '' .reverse!.join ''

function URL(uri)
  res = {}
  res <<< if url.URL
    new url.URL uri
  else
    url.parse uri

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
  digest = crypto.createHash \md5
  digest.update "#{Math.random! + new Date}"
  digest.digest \hex
    .slice -n
