require! <[ assert ./fs path crypto ./me ]>

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
  return fs.mkdirp playground = path.join sandbox, "#{N}s"
  .then ->
    # Run 2^N jobs in parallel
    for bitmask til 1 .<<. N
      run-save-bitmask bitmask
  .then -> Promise.all it

  function run-save-bitmask(bitmask)
    var winner
    # Prepare N destinations to save to
    return Promise.resolve!then ->
      for i til N
        candidate2save bitmask .>>. i .&. 1
    .then -> Promise.all it
    .then run-saver
    .then evaluate

    function candidate2save(allowed)
      dst = path.join playground, tmp-file!
      if allowed
        winner ?:= dst
        dst
      else
        fs.writeFile dst, new Date
        .then -> dst

    function run-saver(folders)
      resolve <-! new Promise _
      me do
        save: folders
        async: true
        onsave: resolve

    function evaluate(folder)
      assert.equal winner, folder, "Wrong save destination"
      unless folder
        return
      fs.readdir folder
      .then ->
        assert.equal count, it.length

specify \none ->
  resolve, reject <-! new Promise _
  me do
    disabled: true
    save: true
    async: true
    onsave: !->
      if it
        reject Error "Saves nothing"
      else
        resolve it

function tmp-file
  digest = crypto.createHash \md5
  # digest.update "#{+new Date!}:#{Math.random!}"
  digest.update "#{Math.random!}"
  "#{digest.digest \base64
    .replace /\W+/g ''}.tmp"
