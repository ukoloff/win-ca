require! \../fallback

x = fallback.async <[ x yz  ]>
gen!

y = fallback.async <[ q wer ]>

console.log \Run2
y.run ->
  console.log \= it?.toString!

!function gen
  console.log \Generator...

  Z 3
  .then -> console.log "That's all folks!"

  function Z(count)
    Promise.resolve x.next!
    .then delay
    .then ->
      if it or count--
        console.log \> it?.toString!
        Z count

function delay(value)
  resolve <-! new Promise _
  <-! setTimeout _, 300
  resolve value
