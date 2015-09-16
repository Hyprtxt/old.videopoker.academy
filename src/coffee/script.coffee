socket = io '/'

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

$ '.hand'
  .on 'click', '.card', ->
    hand[$(this).index()].holdToggle()
    renderHand()
    return

$ '.deal'
  .on 'click', ->
    socket.emit 'deal'
    return

$ '.draw'
  .on 'click', ->
    socket.emit 'draw', hand
    return
