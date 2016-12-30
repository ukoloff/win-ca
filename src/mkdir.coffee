###
mkdir if not exists
Poor's man mkdirp
###
fs = require 'fs'

module.exports = (s, fn)->
  fs.mkdir s, (err)->
    if !err
      do fn
      return
    fs.stat s, (err2, stat)->
      if !err2 and stat.isDirectory()
        do fn
      else
        fn err
