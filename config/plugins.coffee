Path = require('path')
loggly = require('./secret').get('/loggly')

# This file is fed to server.require()

module.exports = [
  # static file serving
    register: require('inert')
  ,
  # view serving
    register: require('vision')
  ,
  # jade helper
    register: require('../plugins/jadeHelper')
  ,
  # jade auth helper
    register: require('../plugins/jadeAuthHelper')
  ,
  # social login
    register: require('bell')
  ,
  # sessions
    register: require('hapi-auth-cookie')
  ,
  # combines social login with sessions
    register: require('../plugins/auth')
  ,
  # sockets
    register: require('../plugins/sockets')
  ,
  # event logging
    register: require('good')
    options:
      opsInterval: 1000
      reporters:[
        reporter: require('good-console')
        events:
          log: '*'
          response: '*'
      ,
        reporter: require('good-file')
        events:
          log: '*'
          response: '*'
        config: Path.join( __dirname, '../log', 'good.log' )
      ,
        reporter: require('good-loggly')
        events:
          log: '*'
          response: '*'
          request: '*'
        config: loggly
      ]
]
