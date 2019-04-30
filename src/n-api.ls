# Fetch certificates via N-API

crypt32 = require "./crypt32-#{process.arch}"

export !function sync(args)
  var handle
  current = if args.length then 0 else -1

  return {next, done, run}

  !function next
    while current < args.length
      handle ?:= if current < 0
        crypt32!
      else
        crypt32 args[current]

      if handle.next!
        return that

      handle.done!
      handle := void
      current++

  !function done
    handle?.done!
    handle := void
    current := args.length

  !function run
    while next!
      it that
    it!

export !function async
  res = sync it
  next = res.next
  res.run = run
  return res

  !function run(callback)
    do function fire
      Promise.resolve!
      .then next
      .then !->
        if it
          callback it
          return fire!
        callback!
