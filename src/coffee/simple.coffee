# globals
# _hand = _hand
# _$events = _$events
# $buttons = $ '.buttons'

# Based on:
# http://wizardofodds.com/games/video-poker/strategy/jacks-or-better/9-6/simple/

console.log 'simple strategy loaded'

$simpleBtn = $ '<a>'
  .addClass 'btn btn-primary simple'
  .text 'AUTO: Simple Strategy'
$buttons.append $simpleBtn
$simple = $ '.simple'

_$events.on 'new_game', ->
  $simple.removeAttr 'hidden'
  $simple.on 'click', ->
    result = simpleStrategy()
    console.log result
    return

_$events.on 'game_complete', ->
  $simple.attr 'hidden', true
  $simple.off 'click'

outsideStraights = [
	[1,2,3,4]
	[2,3,4,5]
	[3,4,5,6]
	[4,5,6,7]
	[5,6,7,8]
	[6,7,8,9]
	[7,8,9,10]
	[8,9,10,11]
]

fourOfStraights = ->
  allStraights = [
  	[0,9,10,11,12]
  	[1..5]
  	[2..6]
  	[3..7]
  	[4..8]
  	[5..9]
  	[6..10]
  	[7..11]
  	[8..12]
  ]
  result = []
  allStraights.forEach ( arr ) ->
    copy = arr.slice 0
    copy.splice 0, 1
    result.push copy
    return
  allStraights.forEach ( arr ) ->
    copy = arr.slice 0
    copy.splice 1, 1
    result.push copy
    return copy
  allStraights.forEach ( arr ) ->
    copy = arr.slice 0
    copy.splice 2, 1
    result.push copy
    return copy
  allStraights.forEach ( arr ) ->
    copy = arr.slice 0
    copy.splice 3, 1
    result.push copy
    return copy
  allStraights.forEach ( arr ) ->
    copy = arr.slice 0
    copy.splice 4, 1
    result.push copy
    return copy
  return result

# console.log fourOfStraights(), 'fourOfStraights'

copyAndRemoveSingleCard = ( array, index ) ->
  # console.log array, index
  copy = JSON.parse JSON.stringify array
  result = copy.splice index, 1
  # console.log copy, result
  hand = copy.map ( card ) ->
    return new Card card.opts
  return hand

handsWithFourCards = ( hand ) ->
  hands = []
  hands.push copyAndRemoveSingleCard hand, 0
  hands.push copyAndRemoveSingleCard hand, 1
  hands.push copyAndRemoveSingleCard hand, 2
  hands.push copyAndRemoveSingleCard hand, 3
  hands.push copyAndRemoveSingleCard hand, 4
  return hands

getCardValuesOrdered = ( hand ) ->
  values = hand.map ( card ) ->
    return card.value
  return values.sort ( a, b ) ->
    return a - b

getRoyalFlushCards = ( royal, flush ) ->
  royalFlush =
    cards: []
    suit: flush.suit
  royal.cards.forEach ( cardindex ) ->
    if flush.cards.indexOf( cardindex ) isnt -1
      royalFlush.cards.push( cardindex )
    return
  return royalFlush

getHighCards = ( hand ) ->
  high =
    cards: []
  highCards = [10,11,12,0]
  hand.forEach ( card, i ) ->
    highCards.forEach ( val ) ->
      if card.opts.value is val
        high.cards.push( i )
      return
    return
  return high

getRoyalCards = ( hand ) ->
  royal =
    cards: []
  royalCards = [0,9,10,11,12]
  hand.forEach ( card, i ) ->
    royalCards.forEach ( val ) ->
      if card.opts.value is val
        royal.cards.push( i )
      return
    return
  return royal

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

getStraightOutlier = ( hand, type = 'all' ) ->
  result = {}
  result.haveStraight = false
  result.outlierIndex = false
  result.type = type
  fourCardHands = handsWithFourCards( hand )
  # console.log fourCardHands
  straights = []
  if type is 'all'
    # inside straights
    straights = fourOfStraights()
  else
    # outside straights
    straights = outsideStraights
  straights.forEach ( partialStraight, index ) ->
    partialStraightString = JSON.stringify partialStraight
    fourCardHands.forEach ( partialHand, idx ) ->
      partialHandString = JSON.stringify getCardValuesOrdered( partialHand )
      if partialHandString is partialStraightString
        result.haveStraight = true
        result.outlierIndex = idx
      # console.log partialHandString is partialStraightString, partialHandString, partialStraightString, idx
      return
    return
  return result

getFlushOutlier = ( hand ) ->
  flush = getFlushCards hand
  outlierIndex = -1
  if flush.cards.length isnt 4
    return false
  else
    hand.forEach ( card, idx ) ->
      if card.suit isnt flush.suit
        outlierIndex = idx
      return
  return outlierIndex

simpleStrategy = ->
  result = {}
  result.rule = 'Error! No rules applied'
  score = Poker _hand

  # 1. Royal Flush
  if score.status is 'royalflush'
    holdAll _hand
    result.rule = '1. Hold - royalflush'
    return result

  # 1. Straight Flush
  if score.status is 'straightflush'
    holdAll _hand
    result.rule = '1. Hold - straightflush'
    return result

  # 1. 4 of a Kind
  if score.status is '4kind'
    holdDupes hand, 4
    result.rule = '1. Hold - 4kind'
    return result

  # 2. Hold 4 to royal flush
  flush = getFlushCards _hand
  royal = getRoyalCards _hand
  royalFlush = getRoyalFlushCards royal, flush
  if royalFlush.cards.length > 3
    holdIndex _hand, royal.cards
    result.rule = '2. 4 to a royal flush'
    return result

  # 3. 3 of a Kind
  if score.status is '3kind'
    holdDupes _hand, 3
    result.rule = '3. Hold - 3kind'
    return result

  # 3. Straight
  if score.status is 'straight'
    holdAll _hand
    result.rule = '3. Hold - straight'
    return result

  # 3. Flush
  if score.status is 'flush'
    holdAll _hand
    result.rule = '3. Hold - flush'
    return result

  # 3. Full House
  if score.status is 'fullhouse'
    holdAll _hand
    result.rule = '3. Hold - fullhouse'
    return result

  # 4. 4 to straight flush
  flushOutlier = getFlushOutlier _hand
  straightOutlier = getStraightOutlier _hand
  # console.log flushOutlier, 'getFlushOutlier'
  # console.log straightOutlier, 'getStraightOutlier'
  if flushOutlier
    if straightOutlier.haveStraight
      if flushOutlier is straightOutlier.outlierIndex
        holdSuit _hand, flush.suit
        result.rule = '4. 4 to straight flush'
        return result

  # 5. Two pair
  if score.status is '2pair'
    holdDupes _hand, 2
    result.rule = '5. Hold 2 Pair'
    return result

  # 6. High pair
  if score.status is 'jacksbetter'
    holdDupes _hand, 2
    result.rule = '6. high pair'
    return result

  # 7. 3 to a royal flush
  # !!! holds too many cards when high non flush cards present
  if royalFlush.cards.length > 2
    # need to cross check royal.cards and flush.cards
    # only save the dupes
    holdIndex _hand, royal.cards
    result.rule = '7. 3 to a royal flush'
    return result

  # 8. 4 to a flush
  if flush.cards.length > 3
    holdSuit _hand, flush.suit
    result.rule = '8. 4 to a flush'
    return result

  # 9. Low pair
  if score.status is 'lowpair'
    holdDupes _hand, 2
    result.rule = '9. Hold the Low Pair'
    return result

  # 10. 4 to an outside straight
  rule10 = getStraightOutlier _hand, 'outside'
  if rule10.haveStraight
    holdAllExcept _hand, rule10.outlierIndex
    result.rule = '10. 4 to an outside straight'
    return result

  # 11. 2 suited high cards
  high = getHighCards _hand
  # if high.cards.length > 1
  #   # THINK: 3 high, 2 suited
  #   result.rule = '11. 2 suited high cards'
  #   # console.log high.cards
  #   high.cards.forEach ( card ) ->
  #     console.log card
  #   return result

  # 12. 3 to a straight flush
  # @todo


  # 13. 2 unsuited high cards (if more than 2 then pick the lowest 2)
  # !!! INCOMPLETE
  if high.cards.length is 2
    result.rule = '13. 2 unsuited high cards (if more than 2 then pick the lowest 2)'
    holdIndex _hand, high.cards
    return result
  # if high.cards.length > 1
  #   result.rule = '13. 2 unsuited high cards (if more than 2 then pick the lowest 2)'
  #   console.log _hand
  #   if
  #   return result


  # 14. Suited 10/J, 10/Q, or 10/K
  # @todo

  # 15. One high card
  if high.cards.length is 1
    result.rule = '15. One high card'
    holdIndex _hand, high.cards
    return result

  # 16. Discard everything
  result.rule = '16. Hold Nothing - default'
  return result
