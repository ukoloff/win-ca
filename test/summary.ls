require! <[ appveyor-mocha ./me ]>

<-! after
start = +new Date
me do
  ondata: dups = []
  unique: false
stop = +new Date
dedups = me.all me.der2.pem

<-! Promise.resolve!then
appveyor-mocha.log """
  N-API:\t#{if me.n-api then \Yes else \No}
  Total:\t#{dups.length}
  Unique:\t#{dedups.length}
  Took:\t#{stop - start} ms
  Saved:\t#{me.path ? "-"}
"""
