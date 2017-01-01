enm = require '..'
  .enum

ca = []

console.time 'fetch'

enm (pem)->
  ca.push pem

console.timeEnd 'fetch'
console.log 'Found:', ca.length
