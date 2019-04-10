require! \../n-api

x = n-api.sync <[ x yz  ]>

for til 12
  console.log x.next!

y = n-api.sync <[ q wer ]>

y.run ->
  console.log \= it
