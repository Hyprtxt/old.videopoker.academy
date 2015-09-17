# inner global
_hand = _hand

socket = io '/'

$result = $ '.result'

socket
  .on 'connect', ->
    console.log 'connected, ID:' + socket.io.engine.id
    return
  .on 'disconnect', ->
    console.log 'disconnected'
    return
  .on 'cards', ( data ) ->
    init = false
    # is this init?
    if _hand.length is 0
      init = true
    # console.log _hand.length, init, 'length'
    # setup global _hand here
    _hand = data.map ( v ) ->
      return new Card v.opts
    renderHand _hand
    if init
      _$events.trigger 'new_game'
    return
  .on 'score', ( data ) ->
    console.log data
    $result.text data.status + ' win:' + data.win
