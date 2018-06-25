self = require '..'

ca = []

console.time 'Fetch'

self.each self.der2.der, (pem)->
  ca.push pem

console.timeEnd 'Fetch'
console.log 'Found:', ca.length
console.log 'Unique:', self.all(self.der2.der).length
