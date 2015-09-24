Confidence = require('confidence')

store = new Confidence.Store
  loggly:
    token     : '',
    subdomain : '',
    name      : 'hypr-hapi',
    hostname  : 'auth.hyprtxt.com'
    tags      : ['hapi']
  socialAuth:
    $filter: 'env'
    $base:
      cookie:
        password: 'hapiauth'
      route:
        twitter:
          callbackURL: '/login/twitter'
          btn: 'btn-info-outline'
          icon: 'fa-twitter'
          name: 'Twitter'
        google:
          callbackURL: '/login/google'
          btn: 'btn-danger-outline'
          icon: 'fa-google'
          name: 'Google'
        github:
          callbackURL: '/login/github'
          btn: 'btn-warning-outline'
          icon: 'fa-github'
          name: 'Github'
        facebook:
          callbackURL: '/login/facebook'
          btn: 'btn-primary-outline'
          icon: 'fa-facebook'
          name: 'Facebook'
    production:
      twitter:
        clientId: ''
        clientSecret: ''
        isSecure: true
      google:
        clientId: ''
        clientSecret: ''
        isSecure: true
      github:
        clientId: ''
        clientSecret: ''
        isSecure: true
      facebook:
        clientId: ''
        clientSecret: ''
        isSecure: true
    $default: # for devs
      twitter:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
      google:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
      github:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
      facebook:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
  mysql:
    $filter: 'env'
    production:
      connectionLimit: 100
      host: 'localhost'
      user: ''
      password: ''
      database: ''
      debug: false
    $default: # for devs
      connectionLimit: 10
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'hapi'
      debug: false

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
