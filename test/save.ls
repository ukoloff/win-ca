require! <[ ./fs path crypto ./me ]>

<-! context \Saving

sandbox = path.join __dirname, \../tmp  tmp-file!

count = 1
iter = me generator: true
until iter.next!done
  count++

before ->
  fs.mkdirp sandbox

after !->
  fs.remove sandbox
  .catch !->

for let N to 3
  <- specify "##{N}"
  sb = path.join sandbox, tmp-file!
  fs.mkdirp sb

function tmp-file
  digest = crypto.createHash \md5
  digest.update "#{Math.random! + new Date}"
  "#{digest.digest \base64
    .replace /\W+/g ''}.tmp"
