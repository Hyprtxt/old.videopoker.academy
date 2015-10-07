Confidence = require('confidence')
Path = require('path')

store = new Confidence.Store
  viewConfig:
    $filter: 'env'
    $base:
      engines:
        jade: require('jade')
      path: Path.join( __dirname , '../views' )
    production:
      compileOptions:
        pretty: false
      isCached: false
    $default: # for devs
      compileOptions:
        pretty: true
      isCached: false

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
