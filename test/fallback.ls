require! <[ ./common ]>

context "Fallback" !->

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
