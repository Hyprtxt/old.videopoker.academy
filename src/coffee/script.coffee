socket = io '/'

$hand = $ '.hand'
$deal = $ '.deal'
$draw = $ '.draw'
$result = $ '.result'

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
      console.log v.opts.opts
      return new Card v.opts
    renderHand()
    return
  .on 'score', ( data ) ->
    console.log data
    $result.text data.status + ' win:' + data.win


addHoldEvents()

$deal.on 'click', ->
  socket.emit 'deal'
  $deal.attr 'hidden', true
  $draw.removeAttr 'hidden'
  addHoldEvents()
  $result.text 'Do your best'
  return

$draw.on 'click', ->
  socket.emit 'draw', hand
  $draw.attr 'hidden', true
  $deal.removeAttr 'hidden'
  removeHoldEvents()
  return
