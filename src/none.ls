# No certificates (not @win32)

export function sync
  next: ->
  done: ->
  run: -> it!

export async = sync
