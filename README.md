# win-ca

[![Build status](https://ci.appveyor.com/api/projects/status/e6xhpp9d7aml95j2?svg=true)](https://ci.appveyor.com/project/ukoloff/win-ca)
[![NPM version](https://badge.fury.io/js/win-ca.svg)](http://badge.fury.io/js/win-ca)

Get Windows System Root certificates.

## Usage

Just say `npm install --save win-ca`
and then call `require('win-ca')`.

It is safe to use it under other OSes (not M$ Windows).

## API

After `require('win-ca')` Windows' Root CAs
are found, deduplicated
and installed to `https.globalAgent.options.ca`
so they are automatically used for all
requests with Node.js' https module.

For use in other places, these certificates
are available via `.all()` method
(in [node-forge][]'s format).

```coffee
ca = require 'win-ca'
forge = require 'node-forge'

for crt in ca.all()
  dst.write forge.pki.certificateToPem crt
```
One can enumerate Root CAs himself using `.each()` method:

```coffee
ca = require 'win-ca'

ca.each (crt)->
  dst.write forge.pki.certificateToPem crt
```

But these list may contain duplicates.

Asynchronous enumeration is provided via `.async()` method:

```coffee
ca = require 'win-ca'

ca.async (error, crt)->
  throw error if error
  if crt
    dst.write forge.pki.certificateToPem crt
  else
    console.log "That's all folks!"
```

Finally, `win-ca` saves fetched ceritificates to disk
for use by other soft.
Path to folder containing all the certificates
is available as `require('win-ca').path`.
Environment variable `SSL_CERT_DIR`
is set to point at it,
so OpenSSL-based software will use it automatically.

## Building

- npm install
- npm test
- npm publish
- cd top
- npm publish

## Credits

Uses [node-forge][]
and [node-ffi][].

See also [OpenSSL::Win::Root][].

[node-ffi]: https://github.com/node-ffi/node-ffi
[node-forge]: https://github.com/digitalbazaar/forge
[OpenSSL::Win::Root]: https://github.com/ukoloff/openssl-win-root
