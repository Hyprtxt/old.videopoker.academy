console.log 'MODE: ' + mode, 'SID: ' + session.sid

# inner global
_hand = _hand
_user = _user

# { query: 'sid=' + session.sid + '&mode=' + mode }
socket = io '/'

$result = $ '.result'

socket
  .on 'connect', (  ) ->
    socket.emit 'link', { mode: mode, sid: session.sid }
    console.log 'connected, ID:' + socket.io.engine.id
    return
  .on 'disconnect', ->
    console.log 'disconnected'
    alert 'disconnected from server, please refresh the page and have patience with technical issues'
    return
  .on 'cards', ( user ) ->
    console.log 'cards event, Played?:', user.hand.played
    # console.log user
    _user = user
    _user.hand = new Hand
      deck: user.hand.deck.cards
      cards: user.hand.cards
      played: user.hand.played
    renderHand _user.hand
    if _user.hand.played
      _$events.trigger 'game_complete'
    else
      _$events.trigger 'new_game'
    return

    # is this init?
    # init = false
    # console.log user.hand, 'HAND CARDS'
    # if user.hand.length is 0
    #   init = true
    # console.log _hand.length, init, 'length'
    # setup global _hand here, make it go away!
    # _hand = new Hand
    #   deck: user.hand.deck.cards
    #   cards: user.hand.cards
    # renderHand _hand

    # if init

  .on 'score', ( data ) ->
    updateCreds data.win
    console.log data
    $result.text data.status + ' win:' + data.win
    return
