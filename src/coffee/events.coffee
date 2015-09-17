# inner global
_hand = _hand
console.log _hand, 'events'

$hand = $ '.hand'
$deal = $ '.deal'
$draw = $ '.draw'

holdEvent =  ->
  _hand[$(this).index()].holdToggle()
  renderHand _hand
  return

addHoldEvents = ->
  $hand.on 'click', '.card', holdEvent

removeHoldEvents = ->
  $hand.off 'click', '.card'

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
  console.log _hand, 'game_complete'
  $draw.attr 'hidden', true
  $deal.removeAttr 'hidden'
  removeHoldEvents()
  return

_$events.on 'new_game', ->
  console.log _hand, 'new_game'
  $deal.attr 'hidden', true
  $draw.removeAttr 'hidden'
  addHoldEvents()
  return
