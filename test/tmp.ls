require! <[ ./me ]>

<- context \Temp

<- specify \One

gen = me do
  store: <[ A A ]>
  generator: true
  unique: !false

for til 10
  void
  # console.log \>>> gen.next!

