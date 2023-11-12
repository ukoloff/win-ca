# win-ca

[![Build status](https://ci.appveyor.com/api/projects/status/e6xhpp9d7aml95j2?svg=true)](https://ci.appveyor.com/project/ukoloff/win-ca)
[![NPM version](https://badge.fury.io/js/win-ca.svg)](http://badge.fury.io/js/win-ca)
[![Store Roots](https://github.com/ukoloff/win-ca/workflows/Store%20Roots/badge.svg)](https://github.com/ukoloff/win-ca/actions)

Get Windows System Root certificates for [Node.js].

## Rationale

Unlike [Ruby][], [Node.js][] on Windows **allows**
HTTPS requests out-of-box.
But it is implemented in a rather bizarre way:

> Node uses a
> [statically compiled, manually updated, hardcoded list][node.pem]
> of certificate authorities,
> rather than relying on the system's trust store...
> [Read more][node/4175]

It's somewhat non-intuitive under any OS,
but Windows differs from most of them
by having its own trust store,
fully incompatible with [OpenSSL].

This package is intended to
fetch Root CAs from Windows' store
(*Trusted Root Certification Authorities*)
and make them available to
[Node.js] application with minimal efforts.

### Advantages

- No internet access is required at all
- Windows store is updated automatically (in most modern environments)
- Manually installed Root certificates are used
- Enterprise trusted certificates (GPO etc.) are made available too

## Usage

For 95% of users:

1. Just say `npm install --save win-ca`
2. Then call `require('win-ca')`.
3. That's it!

If you need more -
proceed to [API](#api)
section below.

By the way,
`win-ca` is safe to be used
under other OSes (not M$ Windows).
It does nothing there.

### Electron
`win-ca` was adapted to run inside Electron applications
with no additional configuration
([asar] supported).

See
[Minimal Electron application using win-ca][electron-win-ca]
for usage example.

### VS Code extension

Special [extension](vscode) for [VS Code]
was created to import `win-ca`
in context of VS Code's Extension Host.

Since all VS Code extensions share the same process,
root certificates imported by one of them
are immediately available to others.
This can allow VS Code extensions to connect to
(properly configured)
intranet sites from Windows machines.

## API
<details>
<summary>
Click to view...
</summary>

First versions of `win-ca`
opened Windows' *Trusted Root Certificate Store*,
fetched certificates,
deduplicated them and installed to
`https.globalAgent.options.ca`,
so they are automatically used for all
requests with Node.js' `https` module.

But sometimes one needs to
get these certificates to
do something else.
For that case,
full featured API was devised.
It is the only function
with numerous parameters
and operation modes, eg:

```js
const ca = require('win-ca')

rootCAs = []
// Fetch all certificates in PEM format
ca({
  format: ca.der2.pem,
  ondata: crt => rootCAs.push(crt)
})
```

### Entry points

`win-ca` offers three ways of importing:

1. Regular `require('win-ca')`
2. Fallback `require('win-ca/fallback')`
3. Pure API `require('win-ca/api')`

They all export the same API,
but differ in initialization:

1. `win-ca` *does* fetch certificates from
`Root` store,
saves them to disk
and makes them available to
`https` module with no effort.

2. `win-ca/fallback` does the same,
but it never uses [N-API](#n-api)
for fetching certificates,
so it should work
in all versions of Node.js
as well as inside Electron application.

3. `win-ca/api` does *nothing*,
just exports API,
so you decide yourself
what to do.

## API Parameters

API function may be called with no parameters,
but that makes little sense.
One should pass it object with some fields, ie:

- `format`
  defines representation of certificates to fetch.
  Available values are:

  | Constant | Value | Meaning
  |---|---:|---
  |der2.der | 0 | DER-format (binary, Node's [Buffer][])
  |der2.pem | 1 | PEM-format (text, Base64-encoded)
  |der2.txt | 2 | PEM-format plus some <abbr title="This is SPARTA!!!">laconic</abbr> header
  |der2.asn1| 3 | ASN.1-parsed certificate
  |der2.x509| 4 | Certificate in `node-forge` format (RSA only!)

  Default value is `der`.

  See also [der2](#der2) function below.

- `store` -
  which Windows' store to use.
  Default is `Root`
  (ie *Trusted Root Certification Authorities*).

  Windows has a whole lot of Certificate
  stores (eg `Root`, `CA`, `My`, `TrustedPublisher` etc.)
  One can list certificates from
  any of them
  (knowing its name)
  or several stores at once
  (using array for `store` parameter).

  ```js
  var list = []
  require('win-ca/api')({store: ['root', 'ca'], ondata: list})
  ```

- `unique`
  whether certificates list
  should be deduplicated.
  Default is `true`
  (no duplicates returned).

  Use `{unique: false}`
  to see all certificates
  in store.

- `ondata` - callback fired for each certificate found.

  Every certificate will be converted to `format`
  and passed as the first (the only) parameter.

  As a syntactic sugar,
  array can be passed instead of function,
  it will be populated with certificates.

- `onend` - callback fired (with no parameters) at the end of retrieval

  Useful for asynchronous invocations,
  but works in any case.

- `fallback` - boolean flag,
  indicating [N-API](#n-api)
  shouldn't be used
  even if it is available.

  Default value depends on Node.js version
  (4, 5 and 7 `{fallback: true}`;
  modern versions `{fallback: false}`).
  It is also `true` if Electron is detected.

  Finally, if `win-ca` has been required as
  `win-ca/fallback`,
  default value for this flag is also
  set to `true`.

  Note, that one can force [N-API](#n-api) by setting
  `{fallback: false}`,
  but if Node.js cannot proceed,
  exception will be thrown.
  It can be catched,
  but Node.js will nevertheless remain in unstable state,
  so beware.

- `async` - boolean flag to make retrieval process asynchronous
  (`false` by default)

  If `true`, API call returns immediately,
  certificates will be
  fetched later and feed to `ondata` callback.
  Finally `onend` callback will be called.

- `generator` - boolean flag to emulate ES6 generator
  (default: `false`)

  If called with this flag,
  ES6 iterator object is immediately
  returned
  (regular or asynchronous -
  according to `async` flag).

  ```js
  const ca = require('win-ca/api')

  // Iterate
  for (let der of ca({generator: true})) {
    // Process(der)
  }

  // Or thus (Node.js v>=6)
  let list = [...ca({generator: true})]

  // Or even (Node.js v>=10)
  for await(let der of ca({generator: true, async: true})) {
    // await Process(der)
  }
  ```

  Note, that if callbacks are set along
  with `generator` flag,
  they will be *also* fired.

- `inject` - how to install certificates
  (default: `false`, ie just fetch from store, do not install)

  If set to `true`,
  certificated fetched
  will be also added to
  `https.globalAgent.options.ca`
  (in PEM format, regardless of `format` parameter),
  so all subsequent calls
  to `https` client methods
  (https.request, https.get etc.)
  will silently use them
  *instead* of built-in ones.

  If set to `'+'`,
  new *experimental*
  method is used instead:
  `tls.createSecureContext()`
  is patched and
  fetched certificates
  are used *in addition* to
  built-in ones
  (and not only for `https`,
  but for all secure connections).

  Injection mode can be later
  changed (or disabled)
  with [.inject()](#inject)
  helper function.

- `save` - how to save certificates to disk
  (default: `false`, ie use *no* I/O at all)

  If set to string, or array of strings,
  they will be treated as
  list of candidate folders to save certificates to.
  First one that exists or can be
  (recursively) created will be used.

  If no valid folder path found,
  saving will be silently discarded.

  If `{save: true}` used,
  predefined list of folders will be tried:
    + `pem` folder inside `win-ca` module itself
    + `.local/win-ca/pem` folder inside user's profile

  Certificates will be stored into the folder in two formats:
    + Each certificate as separate text file with special file name
      (mimics behavour of [OpenSSL]'s `c_rehash` utility) -
      suitable for `SSL_CERT_DIR`
    + All certificates in single `roots.pem` file -
      suitable for `SSL_CERT_FILE`

  If `win-ca` is required not via `win-ca/api`,
  it calls itself with `{inject: true, save: true}`
  and additionaly sets `ca.path` field
  and `SSL_CERT_DIR` environment variable
  to the folder with certificates saved.

- `onsave` - callback called at the end of saving
  (if `save` is truthy).

  Path to a folder is passed to callback,
  or no parameters (`undefined`)
  if it has been impossible to save certificates to disk.

## Helper functions

Some internal functions are exposed:

### der2

```js
var certificate = ca.der2(format, certificate_in_der_format)
```

Converts certificate from DER
to
[format](#api-parameters)
specified in first parameter.

Function `.der2()` is curried:

```js
var toPEM = ca.der2(ca.der2.pem)

var pem = toPEM(der)
```

### hash
```js
var hash = ca.hash(version, certificate_in_der_format)
```
Gives certificate hash
(aka X509_NAME_hash),
ie 8-character hexadecimal string,
derived from certificate subject.

If version (first parameter) is 0,
an old algorithm is used
(aka X509_NAME_hash_old, used in OpenSSL v0.\*),
else - the new one
(X509_NAME_hash of OpenSSL v1.\*).

Function `.hash()` is also curried:

```js
var hasher = ca.hash()
console.log(hasher(der))
```

### inject
```js
ca.inject(mode)
// or:
ca.inject(mode, array_of_certificates)
```

Manages the way
certificates are
passed to other modules.

This function is internally called by API
when `{inject:}` parameter used.

First argument (`mode`) is injection mode:

- `false`: no injection, built-in certificates are used

- `true`: put certificates to `https.globalAgent.options.ca`
  and use them *instead* of built-in ones for `https` module

- `'+'`: new *experimental* mode:
  `tls.createSecureContext()` is patched
  and certificates are used
  *along with* built-in ones.
  This mode should affect all secure connections,
  not just `https` module.

Second parameter (`array_of_certificates`)
is list of certificates to inject.
If it is omitted,
previous list is used
(only inject mode is changed).

For example,
simplest way to test new
injection mode is:
```js
const ca = require('win-ca') // Fetch certificates and start injecting (old way)

ca.inject('+') // Switch to new injection mode
```

Note,
that this function should be called
before first secure connection is established,
since every secure connection populates
different caches,
that are extremely hard to invalidate.
Changing injection mode in the
middle of secure communication
can lead to unpredictable results.

### exe

Applications that use `win-ca`
are sometimes packed / bundled.
In this case one should find appropriate
place for binary utility `roots.exe`
(used in fallback mode,
which is always the case with Electron apps)
and then make `win-ca` to find the binary.

Function `.exe()` is intended to provide this
functionality.
You must call it **before** first invocation of library itself,
eg:
```js
var ca = require('win-ca/api')

ca.exe('/full/path/to/roots.exe')
ca({fallback: true, inject: true})
```

`.exe()` with no parameters switches to
default location
(inside `lib` folder).
In any case it returns previous
path to `roots.exe`:
```
console.log(require('win-ca').exe()) // Where is my root.exe?
```

## Legacy API
<details>
<summary>
Click to view...
</summary>

`win-ca` v2 had another API,
which is preserved for compatibility,
but discouraged to use.
It consists of three functions:

* Synchronous:
  + `.all()`
  + `.each()`
* Asynchronous:
  + `.each.async()`

```
var ca = require('win-ca')

do.something.with(ca.all(ca.der2.pem))
```

Note:
1. All three yield
    certificates
    in [node-forge][]'s format
    by default
    (unlike [modern API](#api),
    that returns DER
    if unspecified by user).

    Unfortunately, `node-forge` at the time of writing is unable to
    parse non-RSA certificates
    (namely, ECC certificates becoming more popular).
    If your *Trusted Root Certification Authorities* store
    contains modern certificates,
    legacy API calls
    will throw exception.
    To tackle the problem -
    pass them [format](#api-parameters)
    as the first parameter.

2. `.all()` deduplicates
  certificates (like [regular API](#api)),
  while both `.each` calls
  may return duplicates
  (`{unique: false}` applied)

3. `Root` store always used
  (no way for `store:` option)

4. Both `.each` calls require callback
    (with optional `format`)

    Synchronous `.each()` callback gets single
    argument - certificate
    (in specified format)

    ```js
      var ca = require('win-ca')
      ca.each(ca.der2.x509, crt=>
        console.log(crt.serialNumber)
      )
    ```

    Asynchronous `.each.async()` callback
    gets two parameters:
      + `error` (which is always `undefined` in this version)
      + `result` - certificate in requested `format`
        or `undefined` to signal end of retrieval

    ```js
    let ca = require('win-ca')

    ca.each.async((error, crt)=> {
      if (error) throw error;
      if(crt)
        console.log(forge.pki.certificateToPem(crt))
      else
        console.log("That's all folks!")
    })
    ```

</details>

## N-API

Current version uses [N-API],
so it can be used in [Node.js versions with N-API support][N-API-support],
i.e. v6 and all versions starting from v8.

Thanks to N-API, it is possible to precompile
[Windows DLL](n-api/crypt32.cpp) and save it to package,
so no compilation is needed at installation time.

For other Node.js versions
(v4, 5 or 7)
special [fallback utility](n-api/roots.c) is called
in the background to fetch the list anyway.

If you wish to use this fallback engine
(even for modern Node.js),
you can
```js
require('win-ca/fallback')
```
</details>

## Caveats

Windows 10 tends to
have only a few certificates in
its *Trusted Root Certification Authorities* store
and [lazily add them to it on first use][win.lazy].

If your OS does so,
`win-ca` will still help to
connect to your own sites
(protected by self-signed certificates,
or by the ones, distributed with GPO),
but will make connection to
well-known sites
(like Google or Twitter) impossible!

The simplest remedy is to
*once* open desired site in
Internet Explorer / Google Chrome
(certificate will be *silently* added
to Root store).

Another option is to switch to new
*experimental* [injection](#inject) method:
```js
require('win-ca').inject('+')
```

### Clear `pem` folder on publish

If you use `win-ca` in some Electron app or VS Code extension,
be warned that
`node_modules/win-ca/pem` folder
is *highly likely* to be packed into your bundle
with all root certificates on development machine.

You had better remove said folder
before publishing
(eg. in `prepack` npm script if it applies).

## Building

- npm install
- npm run pretest
- npm run [nvm$]
- npm publish

This builds both `x86` and `x64` versions with [N-API](#n-api) support.
For older Node.js versions standalone binary utility is built.

## See also

- [OpenSSL::Win::Root][] for Ruby version
- [mac-ca][] for Mac OS version

## Credits

Uses [node-forge][]
and used to use [node-ffi-napi][] (ancestor of [node-ffi][]).

[node-ffi]: https://github.com/node-ffi/node-ffi
[node-ffi-napi]: https://github.com/node-ffi-napi/node-ffi-napi
[node-forge]: https://github.com/digitalbazaar/forge
[OpenSSL::Win::Root]: https://github.com/ukoloff/openssl-win-root
[Node.js]: http://nodejs.org/
[Buffer]: https://nodejs.org/api/buffer.html
[Ruby]: https://www.ruby-lang.org/
[node.pem]: https://github.com/nodejs/node/blob/master/src/node_root_certs.h
[node/4175]: https://github.com/nodejs/node/issues/4175
[OpenSSL]: https://www.openssl.org/
[nvm$]: https://github.com/ukoloff/nvms
[N-API]: https://nodejs.org/api/n-api.html
[N-API-support]: https://github.com/nodejs/node-addon-api/blob/master/index.js#L17
[VS Code]: https://code.visualstudio.com/
[mac-ca]: https://github.com/jfromaniello/mac-ca
[Electron]: https://electronjs.org/
[electron-win-ca]: https://github.com/ukoloff/electron-win-ca
[win.lazy]: https://social.technet.microsoft.com/wiki/contents/articles/3147.pki-certificate-chaining-engine-cce.aspx
[asar]: https://github.com/electron/asar
