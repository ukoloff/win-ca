const me = require('./me')

context("Async iteration", function() {

  beforeEach(function(){
    if ('undefined' == typeof Symbol || !Symbol.asyncIterator)
      this.skip()
  })

  specify("works either", function() {
    return require('./async/generator')()
  })

})
