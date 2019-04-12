#
# Skip duplicates
#
require! <[ crypto ]>

module.exports = unique

function unique
  seen = new Set

  function pass
    sha = crypto.createHash 'sha256'
      .update it
      .digest \base64
    unless seen.has sha
      seen.add sha
      true
