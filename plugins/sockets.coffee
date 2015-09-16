Hand = require '../modules/hand'
Poker = require '../modules/poker'

exports.register = ( server, options, next ) ->
  cache = server.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  server.app.cache = cache

  server.bind
    cache: server.app.cache

  io = require('socket.io')(server.listener)

  io.on 'connection', ( socket ) ->
    new_hand = new Hand()

    server.app.cache.set socket.id,
      hand: new_hand
    , null, ( err ) ->
      if err
        throw err
      return

    socket
      .emit 'cards', new_hand.cards
      .on 'disconnect', ->
        console.log socket.id + ' disconnected'
        server.app.cache.drop socket.id, ( err ) ->
          if err
            throw err
        return
      .on 'draw', ( data ) ->
        console.log 'draw for ' + socket.id
        server.app.cache.get socket.id, ( err, value ) ->
          if err
            throw err
          hand = new Hand
            deck: value.hand.deck.cards
            size: value.hand.size
            cards: value.hand.cards.map ( card ) ->
              return card.opts
          data.forEach ( card, i ) ->
            if !card.held
              hand.replace i
              console.log "Replaced " + i
            return
          # console.log hand.cards
          socket.emit 'cards', hand.cards

          ## Scoring Here
          socket.emit 'score', Poker hand.cards, 5

          return
        return
      .on 'deal', ( data ) ->
        console.log 'deal for ' + socket.id
        server.app.cache.drop socket.id, ( err ) ->
          if err
            throw err
          hand = new Hand()
          # console.log hand
          server.app.cache.set socket.id,
            hand: hand
          , null, ( err ) ->
            if err
              throw err
            socket.emit('cards', hand.cards );
            return
          return
        return
    return

  next()
  return

exports.register.attributes =
  name: 'sockets'
  version: '0.1.0'
