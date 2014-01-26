
{AltKeyRing} = require('gpg-wrapper').keyring
path = require 'path'

#===================================================

class Keypool

  constructor : () -> 
    @_keyring = new AltKeyRing path.join __dirname, "..", "keypool"
    @_keys = null

  load : (cb) ->
    await @_keyring.find_keys_full { secret : true }, defer err, @_keys
    cb err

  grab : (cb) -> 
    err = ret = null
    if @_keys?.length then ret = @_keys.shift()
    else err = new Error "no keys lefts"
    cb err, ret

#===================================================

_keypool = null
exports.grab = grab = (cb) ->
  err = key = null
  if not _keypool
    _keypool = new Keypool
    await _keypool.load defer err
  unless err?
    await _keypool.grab defer err, key
  cb err, key

#===================================================

await grab defer err, k0
console.log err
console.log k0
await grab defer err, k1
console.log err
console.log k1
