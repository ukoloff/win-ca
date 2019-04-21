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
        .then -> folder := it
      chain .= then ->
        if folder
          single der
    else if chain
      chain
      .then cleanUp
      .then !->
        if PEM
          PEM.end!
        params.onsave? folder
    else
      params.onsave?!

  function single(der)
    (PEM ||:= fs.createWriteStream name \roots.pem)
      .write pem = toPEM der
    hashes[hash = to$ der] ||= 0
    writeFile do
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
    path.join process.env.USERPROFILE || process.env.HOME, \.local/win-ca/pem
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
