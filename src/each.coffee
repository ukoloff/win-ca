###
Enumerate system root CAs
###
crypt = require "./binding"
der2 = require './der2'

module.exports = each = (format, cb)->
  cb ||= format
  store = crypt()
  try
    while blob = store.next()
      cb der2 format, blob
  finally
    store.done()
  return

###
Asynchronous enumeration

Callback:
  cb(error):      error
  cb(null, crt):  certificate
  cb():           done
###
each.async = (format, cb)-> setImmediate ->
  cb ||= format
  store = crypt()
  do step = -> setImmediate ->
    try
      if blob = store.next()
        cb null, der2 format, blob
        do step
      else
        store.done()
        do cb
    catch error
      store.done()
      cb error
    return
