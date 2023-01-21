# Win-CA

Make Trusted Root Certificates in Windows available to VS Code extensions.

## Abstract

This is tiny VS Code extension.
It's only purpose is to run the [win-ca] package,
so all Trusted Root Certificates become
available to other VS Code extensions.

This extensions is useful if you are:

1. Running VS Code on Microsoft Windows, and

2. Trusting some non-standard (not [Mozilla]) root certificates
(in most cases, your Enterprise Trust), and

3. Using another extension that connects to a server
relying on a root-CA signed cert from #2.

In other words,
you can connect to an internet site by browser,
but a VS Code extension fails to connect to it.

This extension can help by fetching a list of Windows'
*Trusted Root Certification Authorities*
and making those certificates available
to other VS Code extensions via [NodeJS][win-ca]
`https.globalAgent.options.ca`
(or `tls.createSecureContext()`).

In some cases, this can help.

## Installation

Install from [here][ukoloff.win-ca] or open VS Code,
hit `Ctrl+Shift+X` (Extensions pane),
search for `win-ca` and press `Install`.

## Parameters

Since v3.0.0 this extension has got some parameters,
available at File / Preferences / Settings / Extensions / win-ca:

- Save (switch)
  - Enables/disables saving fetched certificates to disk

- Method of injection
  + `None`
    - do not inject: turns **off** the extension
  + `Replace` (Default)
       - built-in certificates with what Windows thinks are the root certificates
    (`https.globalAgent.options.ca` method)
  + `Append`
      - new *experimental* method, where both lists are used together
    (`tls.createSecureContext()` method)

The last method can help with the fact
that
[Windows lazily populates root certificate store][win.lazy].
If you connect to popular sites,
their root certificate may be missing
from Windows' Root store.
If using a browser,
Windows will *silently* add
the certifacate to the store,
but not for VS Code extensions.
The simplest remedy is to connect to that site
*once* with your browser.
The second option is to use `append` mode
for this extension.

## Caveats

| Note |
| --- |
| 📝 If you change the parameters, <br/>VS Code must be restarted (e.g., <br/>Command Palette > `Developer: Reload Window`),<br/>since old values are cached too deeply<br/>in the guts of `https` module<br/>and there is no way to update them on the fly.|

[win-ca]: https://github.com/ukoloff/win-ca
[Mozilla]: https://wiki.mozilla.org/CA/Included_Certificates
[ukoloff.win-ca]: https://marketplace.visualstudio.com/items?itemName=ukoloff.win-ca
[win.lazy]: https://social.technet.microsoft.com/wiki/contents/articles/3147.pki-certificate-chaining-engine-cce.aspx
