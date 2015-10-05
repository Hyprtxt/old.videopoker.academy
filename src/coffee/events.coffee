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

getHoldStatus = ->
  return _hand.map ( card ) ->
    return card.held

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
  # console.log _hand, 'game_complete'
  if mode is 'trainer'
    console.log getHoldStatus(), 'pre'
    pre = getHoldStatus()
    clearHolds _hand
    result = simpleStrategy()
    $rule.text result.rule
    post = getHoldStatus()
    console.log getHoldStatus(), 'post'
    console.log result
    if JSON.stringify( pre ) isnt JSON.stringify( post )
      # _$events.trigger 'game_over'
      alert 'Game Over! Correct move was rule ' + result.rule
      window.location.href = '/'
      return
  else
    console.log 'not trainer'
  $draw.attr 'hidden', true
  $deal.removeAttr 'hidden'
  removeHoldEvents()
  return

_$events.on 'new_game', ->
  # console.log _hand, 'new_game'
  $deal.attr 'hidden', true
  $draw.removeAttr 'hidden'
  addHoldEvents()
  return

# _$events.on 'game_over', ->
#   alert 'Game Over!'
#   window.location.href = '/'
#   removeHoldEvents()
#   return
