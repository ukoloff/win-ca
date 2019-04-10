# No certificates (not @win32)

export function sync
  return do
    next: next
    return: done
    run: run

  function next
    void

  function done
    void

  !function run
    it!

export function async
  res = sync it
  next = res.next
  res.next = ->
    Promise.resolve next!
  res
