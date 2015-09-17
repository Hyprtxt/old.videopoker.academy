# globals
_hand = _hand
_$events = _$events

socket = io '/'

$hand = $ '.hand'
$deal = $ '.deal'
$draw = $ '.draw'
$result = $ '.result'
$test = $ '.test'

console.log _hand, '_HAND'

# Defined here, used in simple.coffee

renderHand = ( hand ) ->
  hand.forEach ( card, i ) ->
    $card = $ '.card-' + ( i + 1 )
    $card
      .removeClass 'hold red black'
      .text card.text()
      .addClass card.color()
    if card.held
      $card.addClass 'hold'
    return
  return

addHoldEvents = ( hand ) ->
  $hand.on 'click', '.card', ->
    hand[$(this).index()].holdToggle()
    renderHand hand
    return

removeHoldEvents = ->
  $hand.off 'click', '.card'

socket
  .on 'connect', ->
    console.log 'connected, ID:' + socket.io.engine.id
    return
  .on 'disconnect', ->
    console.log 'disconnected'
    return
  .on 'cards', ( data ) ->
    console.log _hand
    _hand = data.map ( v ) ->
      return new Card v.opts
    renderHand _hand
    return
  .on 'score', ( data ) ->
    console.log data
    $result.text data.status + ' win:' + data.win

$test.on 'click', ->
  socket.emit 'test', '4toFlush'
  return

$deal.on 'click', ->
  socket.emit 'deal'
  _$events.trigger 'new_game'
  $result.text 'Do your best'
  return

$draw.on 'click', ->
  socket.emit 'draw', _hand
  _$events.trigger 'game_complete'
  return

_$events.on 'game_complete', ->
  # console.log 'game_complete'
  $draw.attr 'hidden', true
  $deal.removeAttr 'hidden'
  removeHoldEvents()
  return

_$events.on 'new_game', ->
  # console.log 'new_game'
  $deal.attr 'hidden', true
  $draw.removeAttr 'hidden'
  addHoldEvents()
  return

_$events.trigger 'new_game'
