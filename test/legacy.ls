require! <[ assert node-forge ./me ./der2 ]>

context "Legacy API" !->

  context \all, !->

    for let k, v of der2
      <-! specify k
      me.all me.der2[k]
        .for-each v

  context "each" !->

    for let k, v of der2
      <-! specify k
      finished = 0
      me.each do
        me.der2[k]
        !->
          assert it
          v it

    context "async" ->

      for let k, v of der2
        <-! specify k
        finished = 0
        resolve, reject <-! new Promise _
        me.each.async do
          me.der2[k]
          callback

        !function callback(err, value)
          if err
            reject err
          else if value
            v value
          else if finished++
            reject Error 'Multiple ends'
          else
            resolve!
