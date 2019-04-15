module.exports = asyncIterator

const assert = require('assert')

const me = require('../me')

async function asyncIterator() {
  let count = 0
  for await (let crt of me({async: true, generator: true})) {
    assert(Buffer.isBuffer(crt))
    count++
  }
  assert(count > 10)
}
