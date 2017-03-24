var path = require('path')
var edge = require('edge');

var enumCA = edge.func(path.join(__dirname, 'enum.cs'))

console.log(enumCA(0, true))
