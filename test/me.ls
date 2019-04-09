require! \appveyor-mocha
module.exports = me = require \..

appveyor-mocha.log "Using N-API: #{if me.n-api then \Yes else \No}"
