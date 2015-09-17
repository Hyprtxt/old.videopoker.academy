$testBtn = $ '<a>'
  .addClass 'btn btn-primary test'
  .text 'TEST'
$buttons.append $testBtn
$test = $ '.test'

$test.on 'click', ->
  socket.emit 'test', '4toOusideStraight'
  return
