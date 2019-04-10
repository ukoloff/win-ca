# No certificates (not @win32)

export function sync
  next: ->
  done: ->
  run: -> it!

export function async
  next: -> Promise.resolve!
  done: ->
  run: -> it!
