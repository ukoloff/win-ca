require! <[ https tls ./der2 ]>

module.exports = i-factory

i-factory.inject = inject

toPEM = der2 der2.pem

agent-options = https.global-agent.options

roots = []

function i-factory(mode)
  inject mode, []
  add

!function add(der)
  der
  |> toPEM
  |> roots.push

patch-mode = 0  # No patch yet
var save-create-secure-context

!function inject(mode, array)
  if array
    roots.length = 0
    roots.push ...array

  mode = if '+' == mode => 2
  else if mode => 1
  else => 0

  if mode == patch-mode
    return

  switch patch-mode
    | 1 =>
      if agent-options.ca == roots
        delete agent-options.ca
    | 2 =>
      if tls.create-secure-context == create-secure-context
        tls.create-secure-context = save-create-secure-context
        save-create-secure-context := void

  switch patch-mode := mode
    | 1 =>
        agent-options.ca = roots
    | 2 =>
      unless save-create-secure-context
        save-create-secure-context := tls.create-secure-context
        tls.create-secure-context = create-secure-context

# https://github.com/capriza/syswide-cas/blob/e0a214f23a072866abf6af540a5b4b88b892a109/index.js#L93
function create-secure-context(options)
  ctx = save-create-secure-context ...
  if 2 == patch-mode and !options?.ca
    for crt in roots
      ctx.context.addCACert crt
  ctx
