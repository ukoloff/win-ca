require! <[ ./common ./me ]>

context "N-API" !->

  beforeEach ->
    @skip!  unless me.n-api

  context "sync" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: false

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: false
          generator: true

  context "async" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: false
          async: true

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: false
          generator: true
          async: true
