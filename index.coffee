# modules
Hapi = require('hapi')
Path = require('path')

# functions
setupTmp = require('./functions/setupTmp')
throwErr = require('./functions/throwErr')

# server
server = new Hapi.Server()

server.connection require('./config/connection').get('/connectionConfig')

server.connection require('./config/connection').get('/connectionSocketConfig')

setupTmp() # creates `./logs/good.log` if needed

server.register require('./config/plugins'), throwErr

srvr = server.select( 'main' )

srvr.views require('./config/views').get('/viewConfig')

# Homepage
srvr.route
  method: 'GET'
  path: '/'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'index', request.pre
      return

# Classic Mode
srvr.route
  method: 'GET'
  path: '/classic'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'classic', request.pre
      return

# Kiddie Mode
srvr.route
  method: 'GET'
  path: '/kiddie'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'kiddie', request.pre
      return

# Trainer Mode
srvr.route
  method: 'GET'
  path: '/trainer'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'trainer', request.pre
      return

# Rules Page
srvr.route
  method: 'GET'
  path: '/rules'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'rules', request.pre
      return

# Profile Page
srvr.route
  method: 'GET'
  path: '/profile'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'profile', request.pre
      return

srvr.route
  method: 'GET'
  path: '/login'
  config:
    auth:
      strategy: 'session'
      mode: 'try'
    plugins:
      'hapi-auth-cookie':
        redirectTo: false
    pre: [
      server.plugins['jadeHelper'].jadeRouteSetup
      server.plugins['jadeAuthHelper'].jadeLoginRouteSetup
    ]
    handler: ( request, reply ) ->
      reply.view 'login', request.pre
      return

srvr.route
  method: 'GET'
  path: '/logout'
  config:
    auth: 'session'
    handler: ( request, reply ) ->
      request.auth.session.clear()
      return reply.redirect('/login')

# Static
srvr.route
  method: 'GET'
  path: '/{param*}'
  handler:
    directory:
      path: [
        Path.join __dirname, '/static/'
        Path.join __dirname, '/static_generated/'
      ]
      redirectToSlash: true
      listing: true

# Start the server
server.start ->
  console.log 'Server running at:', srvr.info.uri
  console.log 'Server running at:', server.select( 'socket' ).info.uri
  return
