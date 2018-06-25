# win-ca @VSCode

Make Trusted Root Certificates @Windows available to VSCode extensions

## Abstract

This is minimal possible VSCode Extension.
It's only purpose is to run [win-ca][] package,
so all Trusted Root Certificates becomes
available to other VSCode extensions.

This extensions may appear usable when all three conditions are met:

1. You run VSCode on Microsoft Windows

2. You trust some non-standard (not [Mozilla][]) root certificates
(in most cases - your Enterprise Trust)

3. You use some other VSCode extensions that connects to some server
that uses certificate, signed by root from 2.

In other words,
you can connect to
(most likely) intranet site
with Internet Explorer or Chrome,
but VSCode fails to connect to it.

In this case you can install this extension.
It fetches list of Windows'
*Trusted Root Certification Authorities*
and make those certitficates available
to other VSCode extensions as `https.globalAgent.options.ca`.

In some cases this can help.

[win-ca]: https://ukoloff@github.com/ukoloff/win-ca
[Mozilla]: https://wiki.mozilla.org/CA/Included_Certificates
