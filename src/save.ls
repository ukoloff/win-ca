require! <[ fs path make-dir ./der2 ./hash ]>

module.exports = save

toPEM = der2 der2.txt
to$ = hash!
writeFile = promisify fs.writeFile
readdir = promisify fs.readdir
unlink = promisify fs.unlink

!function save(params)
  var folder, chain, PEM
  hashes = {}
  names = new Set

  return later

  function later
    Promise.resolve it
    .then saver

  !function saver(der)
    if der
      chain ||:= mkdir params.save
        .then startPEM
      chain .= then -> der
        .then single
    else
      chain?
      .then cleanUp
      .catch !->
        folder := void
      .then !->
        PEM?.end!
        params.onsave? folder

  !function startPEM
    folder := it
    PEM := fs.createWriteStream name \roots.pem

  !function single(der)
    pem = toPEM der
    PEM.write pem
    hashes[hash = to$ der] ||= 0
    writeFile do
      name "#{hash}.#{hashes[hash]++}"
      pem

  function name
    names.add it
    path.join folder, it

  !function cleanUp
    readdir folder
    .then ->
      Promise.all do
        it.filter -> !names.has it
        .map -> path.join folder, it
        .map -> unlink it .catch ignore
    .then ignore

function defaults
  return
    path.join __dirname, \../pem
    path.join process.env.USERPROFILE || process.env.HOME, \.local/win-ca/pem
    ...

!function mkdir(dst)
  if \string == typeof dst
    dst = [dst]
  else unless Array.is-array dst
    dst = defaults!

  idx = 0
  return wrap Promise.reject Error 'No folders to save to'

  function wrap(promise)
    if idx >= dst.length
      promise
    else
      promise.catch -> wrap make-dir dst[idx++]

function promisify(fn)
  ->
    args = [].slice.call &
    resolve, reject <-! new Promise _
    args.push callback
    fn.apply @, args

    !function callback(error, value)
      if error
        reject error
      else
        resolve value

function ignore
  void
