coffee = require 'coffee-script'

pckg = require '../package'

src = """
try
  module.exports = require #{JSON.stringify pckg.name}
"""

module.exports = coffee.compile src, bare: true, header: true
