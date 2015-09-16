Hand = require '../modules/hand'

exports.register = ( server, options, next ) ->
  cache = server.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  server.app.cache = cache

  server.bind
    cache: server.app.cache

  io = require('socket.io')(server.listener)

  io.on 'connection', ( socket ) ->

    # console.log server.cache

    server.app.cache.set socket.id,
      hand: new Hand()
    , null, ( err ) ->
      if err
        throw err
      return

    # console.log socket
    # console.log socket.id, socket.connected

    socket
      .emit 'news', hello: 'world man'
      .on 'client_event', ( data ) ->
        console.log data, 'from', socket.id
        return
      .on 'disconnect', ->
        console.log socket.id + ' disconnected'
        server.app.cache.drop socket.id, ( err ) ->
          if err
            throw err
        return
      .on 'get_current_cards', ( data ) ->
        console.log 'get_current_cards for ' + socket.id
        server.app.cache.get socket.id, ( err, value ) ->
          if err
            throw err
          socket.emit('cards', value.hand.cards );
          return
        return
      .on 'draw', ( data ) ->
        console.log 'draw for ' + socket.id
        server.app.cache.get socket.id, ( err, value ) ->
          if err
            throw err
          hand = new Hand(
            deck: value.hand.deck.cards
            size: value.hand.size
            cards: value.hand.cards
          )
          # console.log hand.cards
          data.forEach ( card, i ) ->
            # console.log card.opts, card.held, i
            if !card.held
              hand.replace i
              console.log "Replaced " + i
            return
          socket.emit('cards', hand.cards );
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
