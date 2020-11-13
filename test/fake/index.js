require('livescript')

var samples = require('../samples')

for (var k in samples) {
  console.log(samples[k].toString('hex'))
}
