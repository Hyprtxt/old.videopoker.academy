# modules
Hapi = require('hapi')
Path = require('path')

# functions
setupTmp = require('./functions/setupTmp')
throwErr = require('./functions/throwErr')

# server
server = new Hapi.Server()

server.connection require('./config/connection').get('/connectionConfig')

setupTmp() # creates `./logs/good.log` if needed

server.register require('./config/plugins'), throwErr

server.views require('./config/views').get('/viewConfig')

# Homepage
server.route
  method: 'GET'
  path: '/'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'index', request.pre
      return

# Classic Mode
server.route
  method: 'GET'
  path: '/classic'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'classic', request.pre
      return

# Kiddie Mode
server.route
  method: 'GET'
  path: '/kiddie'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'kiddie', request.pre
      return

# Trainer Mode
server.route
  method: 'GET'
  path: '/trainer'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'trainer', request.pre
      return

# Rules Page
server.route
  method: 'GET'
  path: '/rules'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'rules', request.pre
      return

server.route
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

server.route
  method: 'GET'
  path: '/logout'
  config:
    auth: 'session'
    handler: ( request, reply ) ->
      request.auth.session.clear()
      return reply.redirect('/login')

# Static
server.route
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
  console.log 'Server running at:', server.info.uri
  return
