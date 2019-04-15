var vscode = require('vscode')
console.log('CFG', vscode.workspace.getConfiguration('win-ca'))

require('win-ca/fallback')

exports.activate = activate

function activate() {
}
