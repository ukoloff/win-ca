module.exports = crypt32

!function crypt32(store = 'Root')
  i = 0
  return {next, done}

  function next()
    if i < 5
      buffer-from "#{store}##{++i}"

  !function done()
    i := 1000

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding
