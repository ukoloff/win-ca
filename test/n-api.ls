require! <[ ./common ./me ]>

context "N-API" !->

  beforeEach ->
    @skip!  unless me.n-api

  context "sync" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @

  context "async" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
