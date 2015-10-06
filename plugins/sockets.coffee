Hand = require '../modules/hand'
Poker = require '../modules/poker'
# Strategy = require '../mod'

getHoldStatus = ( cards ) ->
  return cards.map ( card ) ->
    return card.held

exports.register = ( server, options, next ) ->
  cache = server.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  server.app.cache = cache

  server.bind
    cache: server.app.cache

  io = require('socket.io')(server.listener)

  io.use ( socket, next ) ->
    console.log socket.handshake.query
    return next();

  io.on 'connection', ( socket ) ->

    socket
      .on 'link', ( data ) ->
        console.log data
        getQuery = {
          sql: 'SELECT * FROM `users` WHERE ?',
          values: [
            sid: data.sid
          ]
        }
        server.plugins['mysql'].query getQuery, ( rows ) ->
          user = rows[0]
          # Check for cached data
          server.app.cache.get user.sid, ( err, userCache ) ->
            if err
              throw err
            if userCache is null
              user.mode = data.mode
              user.hand = new Hand()
              server.app.cache.set user.sid, user, null, ( err ) ->
                if err
                  throw err
                socket.emit 'cards', user
                return
            else
              socket.emit 'cards', userCache
          return
      .on 'disconnect', ->
        console.log socket.id + ' disconnected'
        # Don't drop the cache, it's good stuff
        # server.app.cache.drop socket.id, ( err ) ->
        #   if err
        #     throw err
        # return
      .on 'draw', ( client ) ->
        ## Hand is over
        console.log 'draw for ' + socket.id
        server.app.cache.get client.sid, ( err, user ) ->
          if err
            throw err
          # console.log 'draw for ', user
          # console.log user.hand.cards
          secure = {}
          secure.hand = new Hand
            deck: user.hand.deck.cards
            cards: user.hand.cards
            played: true
          delete user.hand

          startHand = secure.hand.cards.map ( card ) ->
            return card.databaseText()
          console.log 'Server Hand:', startHand
          console.log 'Client Hand:', client.hand.cards.map ( card ) ->
            return card.opts
          # pre = getHoldStatus( secure.hand.cards )
          client.hand.cards.forEach ( card, i ) ->
            if !card.held
              secure.hand.replace i
            return
          endHand = secure.hand.cards.map ( card ) ->
            return card.databaseText()
          console.log 'Server New Hand:', endHand
          # post = getHoldStatus( hand.cards )
          user.hand = secure.hand
          # console.log pre, post
          strategy = false
          # if JSON.stringify( pre ) is JSON.stringify( post )
          #   strategy = true
          # console.log startHand, endHand, strategy
          score = Poker user.hand.cards, 5
          saveCards = {
            sql: 'INSERT INTO `hands` SET ?',
            values: [
              user: user.id
              mode: user.mode
              start: startHand.join()
              end: endHand.join()
              win: score.win
              status: score.status
              strategy: strategy
            ]
          }
          server.plugins['mysql'].query saveCards, ( rows ) ->
            # console.log rows, 'saveCards rows'
            socket.emit 'cards', user
            socket.emit 'score', score
            return
          return
        return
      .on 'deal', ( client ) ->
        server.app.cache.get client.sid, ( err, user ) ->
          delete user.hand
          user.hand = new Hand()
          server.app.cache.set user.sid, user, null, ( err ) ->
            if err
              throw err
            socket.emit('cards', user );
            return
          return
        return
      # .on 'test', ( data ) ->
      #   console.log data, 'Test'
      #   if data is '4toFlush'
      #     test = new Hand
      #       cards: [
      #         suit: 0
      #         value: 2
      #       ,
      #         suit: 1
      #         value: 3
      #       ,
      #         suit: 0
      #         value: 4
      #       ,
      #         suit: 0
      #         value: 5
      #       ,
      #         suit: 0
      #         value: 3
      #       ]
      #   if data is '3toRoyalFlush'
      #     test = new Hand
      #       cards: [
      #         suit: 0
      #         value: 10
      #       ,
      #         suit: 0
      #         value: 11
      #       ,
      #         suit: 0
      #         value: 12
      #       ,
      #         suit: 1
      #         value: 5
      #       ,
      #         suit: 1
      #         value: 3
      #       ]
      #   if data is '4toOusideStraight'
      #     test = new Hand
      #       cards: [
      #         suit: 0
      #         value: 4
      #       ,
      #         suit: 1
      #         value: 6
      #       ,
      #         suit: 0
      #         value: 12
      #       ,
      #         suit: 3
      #         value: 5
      #       ,
      #         suit: 1
      #         value: 7
      #       ]
      #   if data is '2highCards'
      #     test = new Hand
      #       cards: [
      #         suit: 3
      #         value: 0
      #       ,
      #         suit: 2
      #         value: 1
      #       ,
      #         suit: 1
      #         value: 12
      #       ,
      #         suit: 1
      #         value: 11
      #       ,
      #         suit: 0
      #         value: 9
      #       ]
      #   if data is 'insideStraight'
      #     test = new Hand
      #       cards: [
      #         suit: 3
      #         value: 6
      #       ,
      #         suit: 1
      #         value: 7
      #       ,
      #         suit: 2
      #         value: 9
      #       ,
      #         suit: 0
      #         value: 12
      #       ,
      #         suit: 1
      #         value: 8
      #       ]
      #   if data is '4toStraightFlush'
      #     test = new Hand
      #       cards: [
      #         suit: 1
      #         value: 5
      #       ,
      #         suit: 1
      #         value: 7
      #       ,
      #         suit: 1
      #         value: 9
      #       ,
      #         suit: 0
      #         value: 12
      #       ,
      #         suit: 1
      #         value: 8
      #       ]
      #   if data is '3toStraightFlush'
      #     test = new Hand
      #       cards: [
      #         suit: 1
      #         value: 5
      #       ,
      #         suit: 1
      #         value: 7
      #       ,
      #         suit: 1
      #         value: 9
      #       ,
      #         suit: 0
      #         value: 12
      #       ,
      #         suit: 0
      #         value: 8
      #       ]
      #   if data is '3toStraightFlushAlt'
      #     test = new Hand
      #       cards: [
      #         suit: 0
      #         value: 4
      #       ,
      #         suit: 2
      #         value: 8
      #       ,
      #         suit: 0
      #         value: 5
      #       ,
      #         suit: 0
      #         value: 3
      #       ,
      #         suit: 3
      #         value: 9
      #       ]
      #   if data is 'suited10Q'
      #     test = new Hand
      #       cards: [
      #         suit: 0
      #         value: 5
      #       ,
      #         suit: 0
      #         value: 7
      #       ,
      #         suit: 1
      #         value: 9
      #       ,
      #         suit: 1
      #         value: 11
      #       ,
      #         suit: 0
      #         value: 8
      #       ]
      #   if data is 'lowUnsuited'
      #     test = new Hand
      #       cards: [
      #         suit: 3
      #         value: 12
      #       ,
      #         suit: 3
      #         value: 5
      #       ,
      #         suit: 2
      #         value: 11
      #       ,
      #         suit: 1
      #         value: 7
      #       ,
      #         suit: 0
      #         value: 10
      #       ]
      #   socket.emit( 'cards', test.cards )
      #   return
    return

  next()
  return

exports.register.attributes =
  name: 'sockets'
  version: '0.1.0'
