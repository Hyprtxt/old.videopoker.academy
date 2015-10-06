# inner global
_user = _user
# console.log _user, 'events'

holdEvent =  ->
  # console.log $(this).index(), _user.hand.cards[$(this).index()]
  _user.hand.cards[$(this).index()].holdToggle()
  renderHand _user.hand
  return

addHoldEvents = ->
  $hand.on 'click', '.card', holdEvent
  return

removeHoldEvents = ->
  $hand.off 'click', '.card'
  return

getHoldStatus = ->
  return _user.hand.cards.map ( card ) ->
    return card.held

$deal.on 'click', ->
  console.log 'DEALLLLLLLL'
  socket.emit 'deal', _user
  $result.text 'Do your best'
  return

$draw.on 'click', ->
  socket.emit 'draw', _user
  return

_$events.on 'new_game', ->
  console.log 'new_game'
  # console.log _user
  $deal.attr 'hidden', true
  $draw.removeAttr 'hidden'
  addHoldEvents()
  return

_$events.on 'game_complete', ->
  console.log 'game_complete'
  # console.log $draw, $deal
  $draw.attr 'hidden', true
  $deal.removeAttr 'hidden'
  removeHoldEvents()
  return
