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
      .on 'test', ( data ) ->
        console.log data, 'Test'
        if data is '4toFlush'
          test = new Hand
            cards: [
              suit: 0
              value: 2
            ,
              suit: 1
              value: 3
            ,
              suit: 0
              value: 4
            ,
              suit: 0
              value: 5
            ,
              suit: 0
              value: 3
            ]
        if data is '3toRoyalFlush'
          test = new Hand
            cards: [
              suit: 0
              value: 10
            ,
              suit: 0
              value: 11
            ,
              suit: 0
              value: 12
            ,
              suit: 1
              value: 5
            ,
              suit: 1
              value: 3
            ]
        if data is '4toOusideStraight'
          test = new Hand
            cards: [
              suit: 0
              value: 4
            ,
              suit: 1
              value: 6
            ,
              suit: 0
              value: 12
            ,
              suit: 3
              value: 5
            ,
              suit: 1
              value: 7
            ]
        if data is '2highCards'
          test = new Hand
            cards: [
              suit: 3
              value: 0
            ,
              suit: 2
              value: 1
            ,
              suit: 1
              value: 12
            ,
              suit: 1
              value: 11
            ,
              suit: 0
              value: 9
            ]
        if data is 'insideStraight'
          test = new Hand
            cards: [
              suit: 3
              value: 6
            ,
              suit: 1
              value: 7
            ,
              suit: 2
              value: 9
            ,
              suit: 0
              value: 12
            ,
              suit: 1
              value: 8
            ]
        if data is '4toStraightFlush'
          test = new Hand
            cards: [
              suit: 1
              value: 5
            ,
              suit: 1
              value: 7
            ,
              suit: 1
              value: 9
            ,
              suit: 0
              value: 12
            ,
              suit: 1
              value: 8
            ]
        if data is '3toStraightFlush'
          test = new Hand
            cards: [
              suit: 1
              value: 5
            ,
              suit: 1
              value: 7
            ,
              suit: 1
              value: 9
            ,
              suit: 0
              value: 12
            ,
              suit: 0
              value: 8
            ]
        if data is '3toStraightFlushAlt'
          test = new Hand
            cards: [
              suit: 0
              value: 4
            ,
              suit: 2
              value: 8
            ,
              suit: 0
              value: 5
            ,
              suit: 0
              value: 3
            ,
              suit: 3
              value: 9
            ]
        if data is 'suited10Q'
          test = new Hand
            cards: [
              suit: 0
              value: 5
            ,
              suit: 0
              value: 7
            ,
              suit: 1
              value: 9
            ,
              suit: 1
              value: 11
            ,
              suit: 0
              value: 8
            ]
        if data is 'lowUnsuited'
          test = new Hand
            cards: [
              suit: 3
              value: 12
            ,
              suit: 3
              value: 5
            ,
              suit: 2
              value: 11
            ,
              suit: 1
              value: 7
            ,
              suit: 0
              value: 10
            ]
        socket.emit( 'cards', test.cards )
        return
    return

  next()
  return

exports.register.attributes =
  name: 'sockets'
  version: '0.1.0'
