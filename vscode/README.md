# win-ca @VS Code

Make Trusted Root Certificates @Windows available to VS Code extensions

## Abstract

This is tiny VS Code Extension.
It's only purpose is to run [win-ca] package,
so all Trusted Root Certificates becomes
available to other VSCode extensions.

This extensions may appear usable when *all* three conditions are met:

1. You run VS Code on Microsoft Windows

2. You trust some non-standard (not [Mozilla]) root certificates
(in most cases - your Enterprise Trust)

3. You use some other VS Code extensions that connects to some server
that uses certificate, signed by root from 2.

In other words,
you can connect to
(most likely) intranet site
with Internet Explorer or Chrome,
but VS Code fails to connect to it.

In this case you can install this extension.
It fetches list of Windows'
*Trusted Root Certification Authorities*
and make those certificates available
to other VS Code extensions via
`https.globalAgent.options.ca`
(or `tls.createSecureContext()`).

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
    (`https.globalAgent.options.ca` method)
  + `Append`, new *experimental* method, where both list are used together
    (`tls.createSecureContext()` method)

The last method can help with the fact,
that
[Windows lazily populates root certificate store][win.lazy].
If you connect to popular site,
its root certificate may be missing
from Windows' Root store.
If using Internet Explorer or Chrome,
Windows will *silently* add
the certifacate to store,
but not for VS Code extension.
The simplest remedy is to connect to that site
*once* with MSIE / Chrome.
The second option is to use `append` mode
for this extension.

## Caveats

Note,
that if you change the parameters,
VS Code must be restarted,
since old values are cached too deeply
in the guts of `https` module
and there is no way to update them on the fly.

[win-ca]: https://github.com/ukoloff/win-ca
[Mozilla]: https://wiki.mozilla.org/CA/Included_Certificates
[ukoloff.win-ca]: https://marketplace.visualstudio.com/items?itemName=ukoloff.win-ca
[win.lazy]: https://social.technet.microsoft.com/wiki/contents/articles/3147.pki-certificate-chaining-engine-cce.aspx
