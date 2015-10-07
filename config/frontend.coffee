# Static route globals
module.exports =
  title: 'Video Poker Academy'
  javascripts: [
    '/js/jquery.min.js'
    '/js/global.js'
    '/js/card.js'
    '/js/deck.js'
    '/js/hand.js'
    '/js/simple.js'
    '/js/poker.js'
    '/js/script.js'
    '/js/events.js'
    # '/js/test.js'
  ]
  stylesheets: [
    '/css/font-awesome.css'
    '/css/style.css'
  ]
  navbarBrand:
    title: 'Video Poker Academy'
    link: '/'
  navigation: [
    title: 'Simple Strategy Rules'
    link: '/rules'
  ,
    title: 'Logout'
    link: '/logout'
  # ,
  #   title: 'Profile'
  #   link: '/profile'
  ]
  env: process.env.NODE_ENV
  timestamp: new Date()
