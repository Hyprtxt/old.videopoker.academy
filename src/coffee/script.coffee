socket = io '/'

$hand = $ '.hand'
$deal = $ '.deal'
$draw = $ '.draw'
$result = $ '.result'

# Defined in simple.coffee
# events = {}
# $events = $ events

hand = {}

renderHand = ->
  hand.forEach ( card, i ) ->
    $card = $ '.card-' + ( i + 1 )
    $card
      .removeClass 'hold'
      .text card.text()
      .addClass card.color()
    if card.held
      $card.addClass 'hold'
    return
  return

addHoldEvents = ->
  $hand.on 'click', '.card', ->
    hand[$(this).index()].holdToggle()
    renderHand()
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
    hand = data.map ( v ) ->
      return new Card v.opts
    renderHand()
    return
  .on 'score', ( data ) ->
    console.log data
    $result.text data.status + ' win:' + data.win

$deal.on 'click', ->
  socket.emit 'deal'
  $events.trigger 'new_game'
  $result.text 'Do your best'
  return

$draw.on 'click', ->
  socket.emit 'draw', hand
  $events.trigger 'game_complete'
  return

$events.on 'game_complete', ->
  console.log 'game_complete'
  $draw.attr 'hidden', true
  $deal.removeAttr 'hidden'
  removeHoldEvents()
  return

$events.on 'new_game', ->
  console.log 'new_game'
  $deal.attr 'hidden', true
  $draw.removeAttr 'hidden'
  addHoldEvents()
  return

$events.trigger 'new_game'
