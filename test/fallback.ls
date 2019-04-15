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
        <-! specify k
        checker = common.assert509 @
        iterator = me do
          store: v
          fallback: true
          generator: true

        finished = 0
        loop
          item = iterator.next!
          assert.deepEqual Object.keys(item), <[ done value ]>
          if item.done
            if finished++ > 3
              break
          else
            checker item.value

  context "async" !->

    context "callbacks" !->

      for let k, v of common.samples
        <- specify k
        resolve <~! new Promise _
        me do
          store: v
          fallback: true
          async: true
          ondata: common.assert509 @
          onend: resolve

    context "generators" !->

      for let k, v of common.samples
        <- specify k
        checker = common.assert509 @
        iterator = me do
          store: v
          fallback: true
          generator: true
          async: true
        do function fire
          Promise.resolve!
          .then iterator.next
          .then ->
            assert.deepEqual Object.keys(it), <[ done value ]>
            unless it.done
              checker it.value
              fire!

      context "slow" !->

        for let k, v of common.samples
          <- specify k
          common.assert509 @
          me do
            store: v
            fallback: true
            generator: true
            async: true
