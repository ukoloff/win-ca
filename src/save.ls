require! <[ fs path ./der2 ./hash ]>

module.exports = save

toPEM = der2 der2.txt
to$ = hash!

function save(dst)
  unless dst
    dst = defaults!
  else unless Array.isArray dst
    dst = [dst]

function defaults
  return
    path.join __dirname, \../pem
    path.join process.env.USERPROFILE, \.local/win-ca/pem
