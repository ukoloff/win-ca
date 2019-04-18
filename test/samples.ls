require! <[ path ./fs node-forge ]>

buffer-from = Buffer.from || (data, encoding)->
  new Buffer data, encoding

for file in fs.readdirSync folder = path.join __dirname, \pem
  pem = fs.readFileSync path.join folder, file
  @[path.parse file .name] = buffer-from nodeForge.pem.decode(pem)[0].body, \binary
