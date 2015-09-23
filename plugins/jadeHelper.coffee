exports.register = ( server, options, next ) ->
  server.expose 'jadeRouteSetup', ( request, reply ) ->
    request.pre = require '../config/frontend'
    request.pre.auth = request.auth
    request.pre.session = request.auth.artifacts
    return reply()
  return next()

exports.register.attributes =
  name: 'jadeHelper'
  version: '0.1.0'
