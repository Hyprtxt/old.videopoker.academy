SocialAuthConfig = require('../config/secret').get('/socialAuth')

exports.register = ( server, options, next ) ->
  cache = server.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  server.app.cache = cache

  server.bind
    cache: server.app.cache

  _validateFunc = ( request, session, callback ) ->
    cache.get session.sid, ( err, value, cached, log ) ->
      if( err )
        return callback err, false
      if( !cached )
        return callback null, false
      # console.log 'stiff', err, value, cached, log
      return callback null, true, cached.item.account
    return

  _sessionManagement = ( request, reply ) ->
    if !request.auth.isAuthenticated
      return reply('Authentication failed due to: ' + request.auth.error.message);
    # console.log request.auth, 'AUTH'
    self = this
    account = request.auth.credentials
    sid = '' + account.profile.id
    getQuery = {
      sql: 'SELECT * FROM `users` WHERE ?',
      timeout: 40000, # 40s
      values: [
        sid: sid
      ]
    }
    server.plugins['mysql'].query getQuery, ( rows ) ->
      if rows.length is 0
        # Create User
        if account.provider is 'facebook'
          picURL = 'https://graph.facebook.com/' + account.profile.id + '/picture?width=50&height=50'
          emailAddress = account.profile.email
        if account.provider is 'google'
          picURL = account.profile.raw.image.url
          emailAddress = account.profile.emails[0].value
          # console.log account.profile.raw
        createQuery = {
          sql: 'INSERT INTO `users` SET ?',
          timeout: 40000, # 40s
          values: [
            sid: sid
            displayName: account.profile.displayName
            email: emailAddress
            provider: account.provider
            pic: picURL
          ]
        }
        server.plugins['mysql'].query createQuery, ( rows ) ->
          # console.log rows
          if rows.affectedRows is 1
            console.log 'Account Created'
            # createdQuery = {
            #   sql: 'SELECT * FROM `users` WHERE ?',
            #   timeout: 40000, # 40s
            #   values: [
            #     sid: sid
            #   ]
            # }
            server.plugins['mysql'].query getQuery, ( rows ) ->
              if rows.length is 1
                self.cache.set sid, account: rows, null, ( err ) ->
                  if( err )
                    reply( err )
                  request.auth.session.set 'sid': sid
                  return reply.redirect '/'
          return
      else
        console.log 'Found Account!'
        self.cache.set sid, account: rows, null, ( err ) ->
          if( err )
            reply( err )
          request.auth.session.set 'sid': sid
          return reply.redirect '/'
      return
    return

  server.auth.strategy 'session', 'cookie',
    password: SocialAuthConfig.cookie.password
    cookie: 'sid-hapiauth'
    redirectTo: '/login'
    isSecure: false
    validateFunc: _validateFunc

  for provider of SocialAuthConfig.route
    config = SocialAuthConfig[provider]
    config.provider = provider
    config.password = SocialAuthConfig.cookie.password

    server.auth.strategy provider, 'bell', config

    server.route
      path: SocialAuthConfig.route[provider].callbackURL
      method: 'GET'
      config:
        auth: provider
        handler: _sessionManagement

  next()

exports.register.attributes =
  name: 'auth'
  version: '0.1.0'
