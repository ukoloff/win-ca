require! <[ https ./der2 ]>

module.exports = inject

toPEM = der2 der2.pem

roots = []

!function inject(mode)
  https.globalAgent.options.ca = roots

  return injector

  function injector
    roots.push toPEM it
