# globals
# _hand = _hand
# _$events = _$events
# $buttons = $ '.buttons'

console.log 'simple strategy loaded'

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

getFlushCards = ( hand ) ->
  flush =
    cards: []
    suit: ''
  [0..3].forEach ( v ) ->
    count = 0
    cards = []
    hand.forEach ( card, idx ) ->
      if card.opts.suit == v
        count++
        cards.push( idx )
      return
    if cards.length > 2
      flush.cards = cards
      flush.suit = v
      return
  return flush

simpleStrategy = ->
  result = {}
  result.rule = 'Hold Nothing - default'
  score = Poker _hand
  console.log _hand, 'simpleStrategy'

  if score.status is 'royalflush'
    holdAll _hand
    result.rule = 'Hold - royalflush'
    return result

  if score.status is 'straightflush'
    holdAll _hand
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
    holdDupes _hand, 3
    result.rule = 'Hold - 3kind'
    return result

  if score.status is 'straight'
    holdAll _hand
    result.rule = 'Hold - straight'
    return result

  if score.status is 'flush'
    holdAll _hand
    result.rule = 'Hold - flush'
    return result

  if score.status is 'fullhouse'
    holdAll _hand
    result.rule = 'Hold - fullhouse'
    return result

  # Two pair
  if score.status is '2pair'
    holdDupes _hand, 2
    result.rule = 'Hold 2 Pair'
    return result

  # High pair
  if score.status is 'jacksbetter'
    holdDupes _hand, 2
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

  # 4 to a flush
  flush = getFlushCards _hand
  if flush.cards.length > 3
    holdSuit _hand, flush.suit
    result.rule = '4 to a flush'
    return result

  # Low pair
  if score.status is 'lowpair'
    holdDupes _hand, 2
    result.rule = 'Hold the Low Pair'
    return result

  return result
