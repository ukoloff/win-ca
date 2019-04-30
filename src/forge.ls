# Lazy node-forge loader

module.exports = loader

var forge

function loader
  unless forge
    forge := require \node-forge
    oids = forge.oids
    for k, v of require \./oids
      oids[k] ?= v
      oids[v] ?= k

  forge
