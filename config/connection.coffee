Confidence = require('confidence')
Path = require('path')

store = new Confidence.Store
  connectionConfig:
    $filter: 'env'
    production:
      host: 'localhost'
      port: 8001
    $default: # for devs
      host: 'auth.hyprtxt.dev'
      port: 8001

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
