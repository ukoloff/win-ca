# No certificates (not @win32)

export function sync
  next: next
  return: done
  run: run

  function next
    void

  function done
    it

  function run
    it!

export function async
  next: next
  return: done
  run: run

  function next
    void

  function done
    it

  function run
    it!
