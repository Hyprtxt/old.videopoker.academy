module.exports =
  title: 'Hypr-Hapi'
  javascripts: [
    '/socket.io/socket.io.js'
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
    title: 'Hyprtxt Video Poker'
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
  timestamp: new Date()
