# win-ca

[![Build status](https://ci.appveyor.com/api/projects/status/e6xhpp9d7aml95j2?svg=true)](https://ci.appveyor.com/project/ukoloff/win-ca)
[![NPM version](https://badge.fury.io/js/win-ca.svg)](http://badge.fury.io/js/win-ca)

Get Windows System Root certificates for [Node.js][].

## Rationale

Unlike [Ruby][], [Node.js][] on Windows **allows**
HTTPS requests out-of-box.
But it is implemented in a rather bizzare way:

> Node uses a
> [statically compiled, manually updated, hardcoded list][node.pem]
> of certificate authorities,
> rather than relying on the system's trust store...
> [Read more][node/4175]

It's very strange behavour under any OS,
but Windows differs from most of them
by having its own trust store,
fully incompatible with [OpenSSL].

This package is intended to
fetch Root CAs from Windows' store
and make them available to
[Node.js] application with minimal efforts.

### Advantages

- No internet access is required at all
- Windows store is updated automatically (in most modern environments)
- Manually installed Root certificates are used
- Enterpise trusted certificates (GPO etc.) are made available too

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

```js
let ca = require('win-ca')
let forge = require('node-forge')

for (let crt of ca.all())
  console.log(forge.pki.certificateToPem(crt))
```
One can enumerate Root CAs himself using `.each()` method:

```js
let ca = require('win-ca')

ca.each(crt=>
  console.log(forge.pki.certificateToPem(crt)))
```

But this list may contain duplicates.

Asynchronous enumeration is provided via `.async()` method:

```coffee
let ca = require('win-ca')

ca.async((error, crt)=> {
  if (error) throw error;
  if(crt)
    console.log(forge.pki.certificateToPem(crt))
  else
    console.log("That's all folks!")
})    
```

Finally, `win-ca` saves fetched ceritificates to disk
for use by other soft.
Path to folder containing all the certificates
is available as `require('win-ca').path`.
Environment variable `SSL_CERT_DIR`
is set to point at it,
so [OpenSSL][]-based software will use it automatically.
The layout of that folder mimics
that of [OpenSSL][]'s `c_rehash` utility.

## Building

- npm install
- npm test
- npm publish
- cd top
- npm publish

## Caveats

Package `ffi-napi` is heavily used.
For it to compile under Windows
one need Windows Build Tools for Node.js properly installed.
It is usually achieved by:
```sh
npm install --global windows-build-tools
```

## Credits

Uses [node-forge][]
and [node-ffi-napi][] (ancestor of [node-ffi][]).

See also [OpenSSL::Win::Root][].

[node-ffi]: https://github.com/node-ffi/node-ffi
[node-ffi-napi]: https://github.com/node-ffi-napi/node-ffi-napi
[node-forge]: https://github.com/digitalbazaar/forge
[OpenSSL::Win::Root]: https://github.com/ukoloff/openssl-win-root
[Node.js]: http://nodejs.org/
[Ruby]: https://www.ruby-lang.org/
[node.pem]: https://github.com/nodejs/node/blob/master/src/node_root_certs.h
[node/4175]: https://github.com/nodejs/node/issues/4175
[OpenSSL]: https://www.openssl.org/
