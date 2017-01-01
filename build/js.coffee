cc = require './cc'
pckg = require '../package'

module.exports = cc """
try
  require #{JSON.stringify pckg.name}
"""
