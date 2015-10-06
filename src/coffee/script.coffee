console.log 'MODE: ' + mode, 'SID: ' + session.sid

# inner global
_hand = _hand
_user = _user

socket = io '/'

$result = $ '.result'

socket
  .on 'connect', (  ) ->
    console.log 'connected, ID:' + socket.io.engine.id
    return socket.emit 'link', { mode: mode, sid: session.sid }
  .on 'link_complete', ->
    return console.log 'link_complete'
  .on 'disconnect', ->
    console.log 'disconnected'
    return setTimeout ->
      window.location = '/'
    , 3000
  .on 'cards', ( user ) ->
    updateCreds user[user.mode + 'Creds']
    console.log 'cards event, Played?:', user.hand.played
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
  .on 'score', ( data ) ->
    return $result.text data.status + ' win:' + data.win
