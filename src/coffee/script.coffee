socket = io '/'

hand = {}

renderHand = ->
  hand.forEach ( card, i ) ->
    # console.log card, i
    # console.log card.text()
    i++
    $card = $ '.card-' + i
    $card
      .removeClass 'hold'
      .text card.text()
      .addClass card.color()
    if card.held
      $card.addClass 'hold'

socket
  .on 'connect', ->
    console.log 'connected, ID:' + socket.io.engine.id
    return
  .on 'disconnect', ->
    console.log 'disconnected'
    return
  .on 'news', ( data ) ->
    console.log data
    socket.emit 'client_event', my: 'data is good'
    # socket.emit session.sid, data: 'from specific client'
    return
  .on 'cards', ( data ) ->
    hand = data.map ( v ) ->
      return new Card v.opts
    renderHand()
    return

socket.emit 'client_event', my: 'things are sent from out here'

$ '.hand'
  .on 'click', '.card', ->
    hand[$(this).index()].holdToggle()
    renderHand()

$ '.get_current_cards'
  .on 'click', ->
    socket.emit 'get_current_cards'

$ '.play'
  .on 'click', ->
    socket.emit 'play'

$ '.deal'
  .on 'click', ->
    socket.emit 'deal'

$ '.draw'
  .on 'click', ->
    socket.emit 'draw', hand
