require! <[ ./me ]>

context "Empty" !->

  context "sync" !->

    context "callbacks" !->

      specify "None" !->
        me do
          disabled: true

    context "generators" !->

      specify "None" !->
        me do
          disabled: true
          generator: true

  context "async" !->

    context "callbacks" !->

      specify "None" !->
        me do
          disabled: true
          async: true

    context "generators" !->

      specify "None" !->
        me do
          disabled: true
          generator: true
          async: true
