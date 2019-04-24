require! <[ assert ./fs path crypto node-forge ./me ]>

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
  @skip! if me.disabled

  return fs.mkdirp playground = path.join sandbox, "#{N}s"
  .then ->
    # Run 2^N jobs in parallel
    for bitmask til 1 .<<. N
      run-save-bitmask bitmask
  .then promise-all

  function run-save-bitmask(bitmask)
    var winner
    # Prepare N destinations to save to
    return Promise.all do
      for i til N
        candidate2save bitmask .>>. i .&. 1
    .then run-saver
    .then delay
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
        pems = it.filter -> /[.]pem$/i.test it
        assert.equal 1 pems.length
        fs.readFile path.join folder, pems[0]
      .then !->
        assert.equal do
          count - 1
          node-forge.pem.decode it .length

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

specify "cleans stale" ->
  @skip!  if me.disabled
  @timeout 5000

  return Promise.all do
    for til 7
      check-cleanup!

!function check-cleanup
  return fs.mkdirp winner = path.join sandbox, tmp-file!
  .then write-stales
  .then run-saver
  .then delay
  .then evaluate

  function evaluate(folder)
    assert.equal winner, folder
    fs.readdir folder
    .then !->
      assert.equal count, it.length

function write-stales(folder)
  Promise.all do
    for to 27 * Math.random!
      fs.writeFile do
        path.join folder, tmp-file!
        '# ' + tmp-file!
  .then -> folder

function run-saver(folder)
  resolve <-! new Promise _
  me do
    save: folder
    onsave: resolve

function tmp-file
  "#{
  crypto.createHash \md5
    .update "#{Math.random!}"
    .digest \base64
    .replace /\W+/g ''
  }.tmp"

function promise-all
  Promise.all it

function delay(value)
  resolve <-! new Promise _
  setTimeout resolve, 42 + 12 * Math.random!, value
