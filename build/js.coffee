cc = require './cc'
pckg = require '../package'

module.exports = cc """
try
  module.exports = require #{JSON.stringify pckg.name}
"""
