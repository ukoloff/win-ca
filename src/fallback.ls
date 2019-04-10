# Fetch certificates via standalone utility

require! <[ path child_process split ]>

bin = path.join __dirname, 'mock/roots'

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
    .end do
      child_process.spawnSync bin, args
      .stdout
    .on \end ->
      callback!

export !function async(args)
  return {run, next, done}

  var queue, requests, finished

  !function next
    if finished
      return Promise.resolve!

    unless queue
      queue := []
      requests := []
      run enqueue

    if queue.length
      return Promise.resolve queue.shift!

    return new Promise !->
      requests.push it

    !function enqueue
      unless it
        done!
        return

      if requests.length
        requests.shift! it
        return

      unless finished
        queue.push it

  !function done
    finished := true
    queue := []
    for resolver in requests
      resolver!

  !function run(callback)
    child_process.spawn bin, args
    .stdout
    .pipe splitter callback
    .on \end ->
      callback!

function splitter(callback)
  split !->
    if it.length
      callback buffer-from it, 'hex'

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding


