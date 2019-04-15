const assert = require('assert')

const me = require('./me')

context("Deduplication", function() {

  specify("shrinks data", function() {
    assert(count({unique: false}) >= count())
  })

  specify("removes duplicates", function() {
    assert.equal(count({store: ['ca', 'ca']}), count({store: 'ca'}))

    assert.equal(count({store: ['ca', 'ca'], unique: false}), 2 * count({store: 'ca', unique: false}))
  })
})

function count(params) {
  var count = 0
  if (!params) params = {}
  params.generator = true
  for (var crt of me(params)) {
    assert(Buffer.isBuffer(crt))
    count++
  }
  return count
}
