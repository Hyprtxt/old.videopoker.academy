console.log 'simple strategy loaded'

events = {}
_$events = $ events

$buttons = $ '.buttons'
$simpleBtn = $ '<a>'
  .addClass 'btn btn-primary simple'
  .text 'AUTO: Simple Strategy'
$buttons.append $simpleBtn
$simple = $ '.simple'

_$events.on 'new_game', ->
  $simple.removeAttr 'hidden'
  $simple.on 'click', simpleStrategy

_$events.on 'game_complete', ->
  $simple.attr 'hidden', true
  $simple.off 'click', simpleStrategy

holdDupes = ( hand, length ) ->
  [0..12].forEach ( v, i ) ->
    holds = []
    hand.forEach ( card, idx ) ->
      if card.value == v
        holds.push( idx )
      return
    if holds.length is length
      hand.forEach ( card, index ) ->
        if card.value is v
          card.hold()
      return
  renderHand()
  return

holdAll = ( hand ) ->
  hand.forEach ( card ) ->
    card.hold()
    return
  renderHand()
  return

simpleStrategy = ->
  # console.log 'simple clicked', _hand
  result = {}
  result.rule = 'Hold Nothing - default'
  score = Poker _hand
  console.log score

  if score.status is 'royalflush'
    holdAll()
    result.rule = 'Hold - royalflush'
    return result

  if score.status is 'straightflush'
    holdAll()
    result.rule = 'Hold - straightflush'
    return result

  if score.status is '4kind'
    holdDupes hand, 4
    result.rule = 'Hold - 4kind'
    return result

  # Hold 4 to royal flush
  # @todo

  # Three of a kind, straight, flush, full house
  # Hold 3 of a kind
  if score.status is '3kind'
    result.hand = holdDupes( _hand, 3 )
    result.rule = 'Hold - 3kind'
    return result

  if score.status is 'straight'
    holdAll()
    result.rule = 'Hold - straight'
    return result

  if score.status is 'flush'
    holdAll()
    result.rule = 'Hold - flush'
    return result

  if score.status is 'fullhouse'
    holdAll()
    result.rule = 'Hold - fullhouse'
    return result

  # Two pair
  if score.status is '2pair'
    result.hand = holdDupes( _hand, 2 )
    result.rule = 'Hold 2 Pair'
    return result

  # High pair
  if score.status is 'jacksbetter'
    result.hand = holdDupes( _hand, 2 )
    result.rule = 'Hold the jacksbetter pair'
    return result

  # # 3 to a royal flush
  # if royalFlush.cards.length > 2
  #   hand.cards.map ( card, i ) ->
  #     if royalFlush.cards.indexOf( card ) is -1
  #       hand.replace( i )
  #     return
  #   result.rule = '3 to a royal flush'
  #   return result

  # # 4 to a flush
  # if flush.cards.length > 3
  #   hand.cards.map ( card, i ) ->
  #     if flush.cards.indexOf( i ) is -1
  #       hand.replace( i )
  #     return
  #   result.rule = '4 to a flush'
  #   return result

  # Low pair
  if score.status is 'lowpair'
    result.hand = holdDupes( _hand, 2 )
    result.rule = 'Hold the Low Pair'
    return result

  console.log result
  return result
