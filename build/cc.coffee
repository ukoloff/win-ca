coffee = require 'coffee-script'

module.exports = (src)->
  coffee.compile src,
    bare: true
    header: true
