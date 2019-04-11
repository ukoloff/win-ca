require! \../fallback

x = fallback.async <[ x yz  ]>

y = fallback.async <[ q wer ]>

y.run ->
  console.log \= it
  unless it
    gen!

!function gen
  console.log \Generator...

  Z 3
  .then -> console.log "That's all folks!"

  function Z(count)
    Promise.resolve x.next!
    .then ->
      if it or count--
        console.log \> it
        Z count

