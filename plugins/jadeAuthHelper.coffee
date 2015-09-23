SocialAuthConfig = require('../config/secret').get('/socialAuth')
exports.register = ( server, options, next ) ->
  server.expose 'jadeLoginRouteSetup', ( request, reply ) ->
    request.pre.socialLogin = SocialAuthConfig.route
    return reply()
  return next()

exports.register.attributes =
  name: 'jadeAuthHelper'
  version: '0.1.0'
