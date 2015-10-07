Confidence = require('confidence')
Path = require('path')

store = new Confidence.Store
  connectionConfig:
    $filter: 'env'
    production:
      labels: [ 'main' ]
      host: 'localhost'
      port: 8003
    $default: # for devs
      labels: [ 'main' ]
      host: 'videopoker.dev'
      port: 8003
  connectionSocketConfig:
    $filter: 'env'
    production:
      labels: [ 'socket' ]
      host: 'localhost'
      port: 8004
    $default: # for devs
      labels: [ 'socket' ]
      host: 'socket.videopoker.dev'
      port: 8004

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
