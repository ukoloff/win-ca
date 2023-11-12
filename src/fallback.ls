# Fetch certificates via standalone utility

require! <[ path child_process split ]>

var bin

execFileProperties =
  maxBuffer: 1024 * 1024 * 1024

do function exe new-bin=\roots.exe
  old = bin
  bin := path.resolve __dirname, new-bin
  old

export exe

export !function sync(args)
  return {run, next, done}

  var queue, index

  !function next
    unless queue
      queue := []
      index := 0
      run !->
        queue.push it   if it
    if index < queue.length
      return queue[index++]
    queue := []

  !function done
    queue := []

  !function run(callback)
    splitter callback
    .on \end !->
      callback!
    .end do
      child_process.exec-file-sync bin, args, execFileProperties

export !function async(args)
  return {run, next, done}

  var queue, requests, finished

  !function next
    unless queue
      queue := []
      requests := []
      run enqueue

    return if queue.length
      Promise.resolve queue.shift!
    else if finished
      Promise.resolve!
    else
      new Promise !->
        requests.push it

  !function enqueue
    if finished
      return

    unless it
      suspend!
    else if requests.length
      requests.shift! it
    else
      queue.push it

  !function done
    queue := []
    suspend!

  !function suspend
    finished := true
    for resolver in requests
      resolver!

  !function run callback
    child_process.exec-file bin, args, execFileProperties, ->
    .stdout
    .pipe splitter callback
    .on \end !->
      callback!

function splitter callback
  line <-! split
  callback buffer-from line, \hex if line.length

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding


