# inner global
# _hand = _hand
_user = _user
# console.log _hand, _user, 'events'

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

# console.log getHoldStatus(), 'pre'
# pre = getHoldStatus()
# clearHolds _hand
# result = simpleStrategy()
# $rule.text result.rule
# post = getHoldStatus()
# console.log getHoldStatus(), 'post'
# console.log result
# if JSON.stringify( pre ) isnt JSON.stringify( post )

# console.log _user
# if mode is 'trainer'
#   # _$events.trigger 'game_over'
#   alert 'Game Over! Correct move was rule ' + result.rule
#   window.location.href = '/'
#   return
# else
#   console.log 'not trainer'

# _$events.on 'game_over', ->
#   alert 'Game Over!'
#   window.location.href = '/'
#   removeHoldEvents()
#   return
