require! \../fallback

x = fallback.sync <[ x yz  ]>

for til 12
  console.log x.next!

y = fallback.sync <[ q wer ]>

y.run ->
  console.log \= it
