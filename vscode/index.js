var fs = require('fs')
var path = require('path')
var https = require('https')
var spawn = require('child_process').spawn

var split = require('split')

exports.activate = activate

function activate() {
  var roots = https.globalAgent.options
  roots = roots.ca || (roots.ca = [])
  var out = fs.createWriteStream(path.join(__dirname, 'roots.pem'))

  spawn(path.join(__dirname, 'exe/roots'))
  .stdout.pipe(split(onCrt))

  function onCrt(blob) {
    if(!blob) return
    blob = pem(bufferFrom(blob, 'hex'))
    roots.push(blob)
    out.write(blob)
  }
}

var bufferFrom = Buffer.from || function(data, encoding) {
  return new Buffer(data, encoding);
};

function pem(blob) {
  var lines = ['-----BEGIN CERTIFICATE-----']
  var str = blob.toString('base64')
  // Split by 64
  while(str.length) {
    lines.push(str.substr(0, 64))
    str = str.substr(64)
  }
  lines.push('-----END CERTIFICATE-----', '')
  return lines.join("\r\n")
}
