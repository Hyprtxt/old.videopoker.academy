mysqlConfig = require('../config/secret').get('/mysql')
Mysql = require('mysql')

exports.register = ( server, options, next ) ->
  pool = Mysql.createPool mysqlConfig
  pool.getConnection ( err ) ->
    if !err
      server.log ['success', 'database', 'connection'], "MySQL DB Connected"
    else
      server.log ['error', 'database', 'connection'], err
  server.expose 'pool', pool
  server.expose 'query', ( query, callback ) ->
    server.plugins['mysql'].pool.getConnection ( err, connection ) ->
      if err
        connection.release()
        server.log ['error', 'database', 'connection'], err
        return
      connection.query query, ( err, rows ) ->
        connection.release()
        if err
          server.log ['error', 'database', 'query'], err
        callback rows
        return
      # connection.on 'error', ( err ) ->
      #   connection.off 'error'
      #   connection.release()
      #   server.log ['error', 'database', 'connection'], err
      #   return
      return
    return

  next()
  return

exports.register.attributes =
  name: 'mysql'
  version: '0.1.0'
