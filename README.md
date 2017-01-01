# win-ca

[![Build status](https://ci.appveyor.com/api/projects/status/e6xhpp9d7aml95j2?svg=true)](https://ci.appveyor.com/project/ukoloff/win-ca)
[![NPM version](https://badge.fury.io/js/win-ca.svg)](http://badge.fury.io/js/win-ca)

Get Windows System Root certificates

## Usage

Just say `npm install --save win-ca` and then call `require 'win-ca'`.

It is safe to use it under other OSes (not M$ Windows).

## Building

- npm install
- npm test
- npm publish
- cd top
- npm publish

Uses [node-forge][]
and [node-ffi][].

See also [openssl-win-root][].

[node-ffi]: https://github.com/node-ffi/node-ffi
[node-forge]: https://github.com/digitalbazaar/forge
[openssl-win-root]: https://github.com/ukoloff/openssl-win-root
