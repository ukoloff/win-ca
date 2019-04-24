# win-ca @VSCode

Make Trusted Root Certificates @Windows available to VSCode extensions

## Abstract

This is tiny VSCode Extension.
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
to other VSCode extensions via
`https.globalAgent.options.ca`.

In some cases this helps.

## Installation

Install from [here][ukoloff.win-ca] or open VS Code,
hit `Ctrl+Shift+X` (Extensions pane),
search for `win-ca` and press `Install`.

## Parameters

Since v3.0.0 this extension has got some parameters,
available at File / Preferences / Settings / Extensions / win-ca:

- Save or not certificates to disk

- Method of injection
  + `None` (do not inject; there is no point in this option)
  + `Replace` built-in certificates with what Windows thinks are the root certificates
  + `Append`, new *experimental* method, where both list are used together

Note,
that if you change the parameters,
VS Code must be restarted,
since old values are cached too deeply
in the guts of `https` module
and there is no way to update them on the fly.

[win-ca]: https://ukoloff@github.com/ukoloff/win-ca
[Mozilla]: https://wiki.mozilla.org/CA/Included_Certificates
[ukoloff.win-ca]: https://marketplace.visualstudio.com/items?itemName=ukoloff.win-ca
