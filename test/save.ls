require! <[ ./samples \../lib/save ]>

<-! context.skip \Save

specify \mkdir ->
  # save.mkdir!then console.log
  saver = save!
  for , v of samples
    saver v
  saver!
