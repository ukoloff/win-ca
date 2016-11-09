//
// Enumerate system root CAs
//
var forge = require('node-forge')
var crypt = require('./crypt32')

var asn1 = forge.asn1
var pki = forge.pki

module.exports = me
me.pki = pki

function me()
{
  var listeners = []
  var errors = []
  var h, ctx = null

  crypt.CertOpenSystemStoreA.async(null, 'ROOT', start)

  return {on: handler}

  function handler(name, cb)
  {
    switch(name)
    {
      case 'crt':
        listeners.push(cb)
        break
      case 'error':
        errors.push(cb)
        break
      default:
        croak(new Error('Unknown event: ' + name))
    }
    return this
  }

  function free()
  {
    if(!h)
      return
    crypt.CertCloseStore.async(h, 0, function(){})
    h = 0
    ctx = 0
  }

  function croak(err)
  {
    free()
    if(!errors.length)
      throw err
    errors.forEach(function(cb){ cb(err) })
  }

  function start(err, res)
  {
    if(err)
      return croak(err)
    h = res
    step()
  }

  function step()
  {
    crypt.CertEnumCertificatesInStore.async(h, ctx, next)
  }

  function next(err, res)
  {
    if(err)
      return croak(err)
    try {
      if(res.isNull())
        return free()
      ctx = res
      res = res.deref()
      res = res.pbCertEncoded.reinterpret(res.cbCertEncoded)
      res = asn1.fromDer(res.toString('binary'))
      res = pki.certificateFromAsn1(res)
      listeners.forEach(function(cb){ cb(res) })
      step()
    } catch (e) {
      croak(e)
    }
  }
}
