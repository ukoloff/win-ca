require! <[ appveyor-mocha ./me ]>

<-! after
start = +new Date
me ondata: dedup = []
stop = +new Date
dups = me.all me.der2.pem

<-! Promise.resolve!then
appveyor-mocha.log """
  N-API:\t#{if me.n-api then \Yes else \No}
  Total:\t#{dups.length}
  Unique:\t#{dedup.length}
  Took:\t#{stop - start} ms
"""
