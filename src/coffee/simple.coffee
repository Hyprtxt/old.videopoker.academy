console.log 'simple strategy loaded'

events = {}
$events = $ events

$buttons = $ '.buttons'
$simpleBtn = $ '<a>'
  .addClass 'btn btn-primary simple'
  .text 'AUTO: Simple Strategy'
$buttons.append $simpleBtn
$simple = $ '.simple'

$events.on 'new_game', ->
  $simple.removeAttr 'hidden'
  $simple.on 'click', ->
    console.log 'simple clicked'

$events.on 'game_complete', ->
  $simple.attr 'hidden', true
  $simple.off 'click'
