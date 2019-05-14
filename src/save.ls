require! <[ fs os path make-dir ./der2 ./hash ]>

module.exports = save

toPEM = der2 der2.txt
to$ = hash!
write-file = promisify fs.write-file
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
      chain ||:= mkdir params.save || params.$ave
        .then -> folder := it
      chain .= then ->
        if folder
          single der
    else if chain
      chain
      .then cleanUp
      .then !->
        PEM?.end!
        if folder and params.$ave
          process.env.SSL_CERT_DIR = require \. .path = folder
        params.onsave? folder
    else
      params.onsave?!

  function single(der)
    (PEM ||:= fs.create-write-stream name \roots.pem)
      .write pem = toPEM der
    hashes[hash = to$ der] ||= 0
    write-file do
      name "#{hash}.#{hashes[hash]++}"
      pem
    .catch ignore # or: -> folder := void ???

  function name
    names.add it
    path.join folder, it

  !function cleanUp
    if folder
      readdir folder
      .then ->
        Promise.all do
          it.filter -> !names.has it
          .map -> path.join folder, it
          .map -> unlink it .catch ignore
      .catch ignore

function defaults
  return
    path.join __dirname, \../pem
    path.join os.homedir!, \.local/win-ca/pem
    ...

!function mkdir(dst)
  if \string == typeof dst
    dst = [dst]
  else unless Array.is-array dst
    dst = defaults!

  idx = 0
  return next-dir!
  function next-dir
    if idx < dst.length
      make-dir dst[idx++]
      .catch next-dir
    else
      Promise.resolve!

function promisify(fn)
  ->
    args = [].slice.call &
    resolve, reject <~! new Promise _
    args.push callback
    fn.apply @, args

    !function callback(error, value)
      if error
        reject error
      else
        resolve value

function ignore
  void
