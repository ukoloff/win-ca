require! <[ assert ./me ./common ./samples ]>

context \Empty !->

  context \sync !->

    context \callbacks !->

      for let k, v of common.samples
        <-! specify k
        count = 0
        finished = 0
        me do
          store: v
          disabled: true
          ondata: -> count++
          onend: -> finished++
        assert.equal 0, count
        assert.equal 1, finished

    context \generators !->

      for let k, v of common.samples
        <-! specify k
        iter = me do
          store: v
          disabled: true
          generator: true
        for til 10
          x = iter.next!
          assert.deepEqual <[ done value ]> Object.keys x
          assert x.done

  context \async !->

    context \callbacks !->

      for let k, v of common.samples
        <- specify k
        resolve, reject <~! new Promise _
        me do
          store: v
          disabled: true
          async: true
          ondata: reject
          onend: resolve

    context \generators !->

      for let k, v of common.samples
        <-! specify k
        resolve, reject <~! new Promise _
        iter = me do
          store: v
          disabled: true
          generator: true
          async: true
        count = 0
        do function fire
          Promise.resolve!
          .then iter.next
          .then ->
            assert.deepEqual <[ done value ]> Object.keys it
            assert it.done
            if count++ < 10
              fire!

      context \slow !->

        for let k, v of common.samples
          <-! specify k
          resolve, reject <~! new Promise _
          iter = me do
            store: v
            disabled: true
            generator: true
            async: true
          count = 0
          do function fire
            Promise.resolve!
            .then iter.next
            .then delay
            .then ->
              assert.deepEqual <[ done value ]> Object.keys it
              assert it.done
              if count++ < 10
                fire!

function delay(value)
  resolve <-! new Promise _
  <-! setTimeout _, 12
  resolve value
