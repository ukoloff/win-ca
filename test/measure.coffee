self = require '..'

ca = []

console.time 'fetch'

self.each (pem)->
  ca.push pem

console.timeEnd 'fetch'
console.log 'Found:', ca.length
console.log 'Unique:', self.all().length
