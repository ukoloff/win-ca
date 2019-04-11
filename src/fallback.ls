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
    .on \end ->
      callback!
    .end do
      child_process.spawnSync bin, args
      .stdout

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


