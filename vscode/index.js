var cfg = require('vscode').workspace.getConfiguration('win-ca')

var api= require('win-ca/api')

if (!api.disabled)
  api({
    async: true,
    fallback: true,
    $ave: cfg.save,
    inject: 'append' == cfg.inject ? '+' : 'none' != cfg.inject
  })

exports.activate = activate

function activate() {
}
