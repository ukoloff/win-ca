# Fetch certificates via standalone utility

require! <[ path child_process split ]>

bin = path.join __dirname, 'roots'

export !function sync(args)
  return do
    next: next
    return: done
    run: run

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
    spliter callback
    .end do
      child_process.spawnSync bin, args
      .stdout
    .on \end ->
      callback!

export !function async(args)
  return do
    next: next
    return: done
    run: run

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

    var resolver
    res =  new Promise !->
      resolver := it

    requests.push resolver
    return res

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
  return consumer !->
    if it.length
      callback buffer-from it, 'hex'

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding


