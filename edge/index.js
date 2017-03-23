var path = require('path')
var edge = require('edge');

var enumCA = edge.func(path.join(__dirname, 'enum.cs'))

enumCA(0, function (error, result) {
    if (error) throw error
    console.log(result)
})
