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
  sb = path.join sandbox, "#{N}s"
  fs.mkdirp sb

  bitmask = 0
  # Run 2^N jobs in parallel
  Promise.all <| until bitmask .>>. N, ++bitmask
    resolve, reject <-! new Promise _
    # Create N folders / files according to bitmask
    mask = bitmask .<<. 1
    batch = Promise.all <| for til N
      dst = path.join sb, tmp-file!
      mask .>>.= 1
      unless mask .&. 1
        fs.writeFile dst, new Date
        .then -> dst
      else
        dst
    batch.then !->
      me do
        save: it
        async: true
        onsave: evaluate

    function evaluate(folder)
      resolve!


function tmp-file
  digest = crypto.createHash \md5
  digest.update "#{Math.random! + new Date}"
  "#{digest.digest \base64
    .replace /\W+/g ''}.tmp"
