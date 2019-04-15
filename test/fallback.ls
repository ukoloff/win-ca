require! <[ assert ./common ./me ]>

context "Fallback" !->

  context "sync" !->

    context "callbacks" !->

      for let k, v of common.samples
        <-! specify k
        finished = 0
        me do
          store: v
          fallback: true
          ondata: common.assert509 @
          onend: !-> finished++

        assert.equal finished, 1

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
