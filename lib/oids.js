//
// Some OIDs
//
var forge = require('node-forge')

add({
  dc: '0.9.2342.19200300.100.1.25'
})

function add(oids)
{
  var list = forge.oids
  for(var k in oids)
  {
    v = oids[k]
    list[v] = k
    list[k] =v
  }
}
