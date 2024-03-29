$simpleBtn = $ '<a>'
  .addClass 'btn btn-primary simple'
  .text 'AUTO: Simple Strategy'
$buttons.append $simpleBtn
$simple = $ '.simple'

_$events.on 'new_game', ->
  $simple.removeAttr 'hidden'
  $rule.text ''
  $simple.on 'click', ->
    # console.log _user.hand.cards
    clearHolds _user.hand.cards
    result = simpleStrategy()
    $rule.text result.rule
    console.log result
    return

_$events.on 'game_complete', ->
  $simple.attr 'hidden', true
  $simple.off 'click'
