require! <[ ./common ./me ]>

context "Iteration" !->

  context "sync" !->

    handler = require './iteration/sync'

    for let k, v of common.samples
      <-! specify k
      handler do
        me do
          store: v
          generator: true
        common.assert509 @

  context "async" !->

    if Symbol?.asyncIterator
      handler = require './iteration/async'

    beforeEach !->
      @skip!  unless handler

    for let k, v of common.samples
      <- specify k
      handler do
        me do
          store: v
          generator: true
          async: true
        common.assert509 @
