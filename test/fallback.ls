require! <[ ./common ./me ]>

context "Fallback" !->

  context "sync" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: true

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: true
          generator: true

  context "async" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: true
          async: true

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        common.assert509 @
        me do
          store: v
          fallback: true
          generator: true
          async: true

      context "slow" !->

        for let k, v of common.samples
          <- specify k
          common.assert509 @
          me do
            store: v
            fallback: true
            generator: true
            async: true
