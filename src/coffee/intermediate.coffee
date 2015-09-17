# globals
# _hand = _hand
# _$events = _$events
# $buttons = $ '.buttons'

# Based on:
# http://wizardofodds.com/games/video-poker/strategy/jacks-or-better/9-6/intermediate/

console.log 'simple strategy loaded'

$intermediateBtn = $ '<a>'
  .addClass 'btn btn-primary intermediate'
  .text 'AUTO: Intermediate'
$buttons.append $intermediateBtn
$intermediate = $ '.intermediate'

_$events.on 'new_game', ->
  $simple.removeAttr 'hidden'
  $simple.on 'click', simpleStrategy

_$events.on 'game_complete', ->
  $simple.attr 'hidden', true
  $simple.off 'click', simpleStrategy

getRoyalFlushCards = ( high, flush ) ->
  royalFlush =
    cards: []
    suit: flush.suit
  high.cards.forEach ( cardindex ) ->
    if flush.cards.indexOf( cardindex ) isnt -1
      royalFlush.cards.push( cardindex )
    return
  return royalFlush

getHighCards = ( hand ) ->
  high =
    cards: []
  highCards = [0,9,10,11,12]
  hand.forEach ( card, i ) ->
    highCards.forEach ( val ) ->
      if card.opts.value is val
        high.cards.push( i )
      return
    return
  return high

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
  high = getHighCards _hand
  flush = getFlushCards _hand
  royal = getRoyalFlushCards high, flush
  # console.log _hand, flush, high, royal, 'simpleStrategy'

  # Royal Flush
  if score.status is 'royalflush'
    holdAll _hand
    result.rule = 'Hold - royalflush'
    return result

  # Straight Flush
  if score.status is 'straightflush'
    holdAll _hand
    result.rule = 'Hold - straightflush'
    return result

  # 4 of a Kind
  if score.status is '4kind'
    holdDupes hand, 4
    result.rule = 'Hold - 4kind'
    return result

  # Hold 4 to royal flush
  if royal.cards.length > 3
    holdIndex _hand, royal.cards
    result.rule = '4 to a royal flush'
    return result

  # 3 of a Kind
  if score.status is '3kind'
    holdDupes _hand, 3
    result.rule = 'Hold - 3kind'
    return result

  # Straight
  if score.status is 'straight'
    holdAll _hand
    result.rule = 'Hold - straight'
    return result

  # Flush
  if score.status is 'flush'
    holdAll _hand
    result.rule = 'Hold - flush'
    return result

  # Full House
  if score.status is 'fullhouse'
    holdAll _hand
    result.rule = 'Hold - fullhouse'
    return result

  # 4 to straight flush

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

  # 3 to a royal flush
  if royal.cards.length > 2
    holdIndex _hand, royal.cards
    result.rule = '3 to a royal flush'
    return result

  # 4 to a flush
  if flush.cards.length > 3
    holdSuit _hand, flush.suit
    result.rule = '4 to a flush'
    return result

  # Low pair
  if score.status is 'lowpair'
    holdDupes _hand, 2
    result.rule = 'Hold the Low Pair'
    return result

  # 3 to straight flush [type1]

  # AKQJ unsuited

  # 2 Suited High Cards

  # 4 to an inside straight with 3 high cards

  # 3 to straight flush [type2]

  # KQJ unsuited

  # QJ unsuited

  # JT unsuited

  # KQ, KJ unsuited

  # QT suited

  # AK, AQ, AJ unsuited

  # KT suited

  # One high card

  # 3 to straight flush [type3]

  # Discard everything

  return result
