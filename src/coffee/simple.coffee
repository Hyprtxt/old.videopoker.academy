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

allStraights = [
  [0,9,10,11,12] # aces high
  [0..4] # aces low
  [1..5]
  [2..6]
  [3..7]
  [4..8]
  [5..9]
  [6..10]
  [7..11]
  [8..12]
]

unique = ( a, b ) ->
  if a.indexOf( b ) < 0
    a.push b
  return a

loHi = ( a, b ) ->
  return a - b

parse = ( string ) ->
  return JSON.parse string

# stringify = ( thing ) ->
#   return JSON.stringify thing

stringifyOpts = ( thing ) ->
  return JSON.stringify thing.opts

resurrectCard = ( card ) ->
  return new Card card.opts

holdCard = ( card ) ->
  card.hold()
  return

holdCards = ( thing ) ->
  thing.cards.forEach holdCard
  renderHand _hand

fourOfStraights = ->
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
  hand = copy.map resurrectCard
  return hand

handsWithFourCards = ( hand ) ->
  hands = []
  hands.push copyAndRemoveSingleCard hand, 0
  hands.push copyAndRemoveSingleCard hand, 1
  hands.push copyAndRemoveSingleCard hand, 2
  hands.push copyAndRemoveSingleCard hand, 3
  hands.push copyAndRemoveSingleCard hand, 4
  return hands

sameCard = ( card1, card2 ) ->
  stringOne = JSON.stringify card1.opts
  stringTwo = JSON.stringify card2.opts
  if stringOne is stringTwo
    return true
  else
    return false
  return

getCardValuesOrdered = ( hand ) ->
  values = hand.map ( card ) ->
    return card.value
  return values.sort loHi

getRoyalFlushCards = ( royal, flush ) ->
  royalFlush =
    cards: []
    suit: flush.suit
  if flush.cards.length isnt 0
    royal.cards.forEach ( royalCard ) ->
      flush.cards.forEach ( flushCard ) ->
        if sameCard royalCard, flushCard
          royalFlush.cards.push( royalCard )
        return
      return
  return royalFlush

getHighCards = ( hand ) ->
  high =
    cards: []
  highCards = [10,11,12,0]
  hand.forEach ( card ) ->
    highCards.forEach ( val ) ->
      if card.opts.value is val
        high.cards.push( card )
      return
    return
  return high

getRoyalCards = ( hand ) ->
  royal =
    cards: []
  royalCards = [0,9,10,11,12]
  hand.forEach ( card ) ->
    royalCards.forEach ( val ) ->
      if card.opts.value is val
        royal.cards.push( card )
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
    hand.forEach ( card ) ->
      if card.opts.suit == v
        count++
        cards.push( card )
      return
    if cards.length > 2
      flush.cards = cards
      flush.suit = v
    return
  return flush

getSuitCards = ( hand, suit ) ->
  cards = hand.filter ( card ) ->
    if card.suit is suit
      return true
    return false
  return cards

handHasValue = ( hand, value ) ->
  values = getCardValuesOrdered hand
  result = false
  if values.indexOf value
    result = true
  return result

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

getTriplets = ( things = [] ) ->
  triplets = []
  # All Hold 3 Patterns? *=hold x=discard
  # 0. xx***
  # 1. x*x**
  # 2. x**x*
  # 3. x***x
  # 4. *x**x
  # 5. **x*x
  # 6. ***xx
  # 7. *x*x*
  # 8. *xx**
  # 9. **xx*
  if things.length isnt 5
    return false
  else
    [0..9].forEach ( index ) ->
      clone = things.slice 0
      if index is 0
        # 0. xx***
        clone.splice 0, 2
      if index is 1
        # 1. x*x**
        clone.splice 2, 1
        clone.splice 0, 1
      if index is 2
        # 2. x**x*
        clone.splice 3, 1
        clone.splice 0, 1
      if index is 3
        # 3. x***x
        clone.splice 4, 1
        clone.splice 0, 1
      if index is 4
        # 4. *x**x
        clone.splice 4, 1
        clone.splice 1, 1
      if index is 5
        # 5. **x*x
        clone.splice 4, 1
        clone.splice 2, 1
      if index is 6
        # 6. ***xx
        clone.splice 3, 2
      if index is 7
        # 7. *x*x*
        clone.splice 3, 1
        clone.splice 1, 1
      if index is 8
        # 8. *xx**
        clone.splice 1, 2
      if index is 9
        clone.splice 2, 2
        # 9. **xx*
      triplets.push clone
  return triplets

getStraightTriplets = ->
  straightTriplets = []
  allStraights.forEach ( straight ) ->
    singleStraightTriplets = getTriplets straight
    singleStraightTriplets.forEach ( triplet ) ->
      tripletString = JSON.stringify triplet
      straightTriplets.push tripletString
      return
    return
  # Don't need to parse, using JSON.stringify for comparison
  return straightTriplets.reduce( unique, [] ).map parse

find3toStraightFlush = ( _hand ) ->
  result = {}
  result.foundIt = false
  result.suit = ''
  flush = getFlushCards _hand
  triplets = getTriplets _hand
  if flush.cards.length > 2
    triplets.forEach ( hand_triplet, idx ) ->
      handTripletString = JSON.stringify getCardValuesOrdered hand_triplet
      getStraightTriplets().forEach ( straight_triplet ) ->
        straightTripletString = JSON.stringify straight_triplet
        if straightTripletString is handTripletString
          flushCards = getFlushCards hand_triplet
          # console.log 'MATCH', straightTripletString, hand_triplet, flushCards
          if flushCards.suit
            # Certianly have 3 flush cards, so hold em
            result.suit = flushCards.suit
            result.foundIt = true
        return
      return
  return result

get2SuitedHighCards = ( hand ) ->
  # Double 2 suited high cards is always an outside straight
  # so this function returns the last 2 suited high cards found
  result = {}
  result.success = false
  result.cards = []
  high = getHighCards hand
  if high.cards.length > 1
    [0..3].forEach ( idx ) ->
      suitCards = getSuitCards hand, idx
      highCards = getHighCards suitCards
      # console.log highCards, highCards.cards.length, 'rule 11'
      if highCards.cards.length > 1
        result.cards = highCards.cards
        result.success = true
      return
  if result.success
    holdCards result
  return result

simpleStrategy = ->
  result = {}
  result.rule = 'Error! No rules applied'
  score = Poker _hand

  # 1. Royal Flush
  if score.status is 'royalflush'
    holdAll _hand
    result.rule = '1.1 Hold - royalflush'
    return result

  # 1. Straight Flush
  if score.status is 'straightflush'
    holdAll _hand
    result.rule = '1.2 Hold - straightflush'
    return result

  # 1. 4 of a Kind
  if score.status is '4kind'
    holdDupes hand, 4
    result.rule = '1.3 Hold - 4kind'
    return result

  # 2. Hold 4 to royal flush
  flush = getFlushCards _hand
  royal = getRoyalCards _hand
  royalFlush = getRoyalFlushCards royal, flush
  if royalFlush.cards.length > 3
    holdCards royalFlush
    result.rule = '2. 4 to a royal flush'
    return result

  # 3. 3 of a Kind
  if score.status is '3kind'
    holdDupes _hand, 3
    result.rule = '3.1 Hold - 3kind'
    return result

  # 3. Straight
  if score.status is 'straight'
    holdAll _hand
    result.rule = '3.2 Hold - straight'
    return result

  # 3. Flush
  if score.status is 'flush'
    holdAll _hand
    result.rule = '3.3 Hold - flush'
    return result

  # 3. Full House
  if score.status is 'fullhouse'
    holdAll _hand
    result.rule = '3.4 Hold - fullhouse'
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
  if royalFlush.cards.length > 2
    holdCards royalFlush
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
  rule11 = get2SuitedHighCards _hand
  if rule11.success
    result.rule = '11. 2 suited high cards'
    return result

  # 12. 3 to a straight flush
  rule12 = find3toStraightFlush _hand
  if rule12.foundIt
    holdSuit _hand, rule12.suit
    result.rule = '12. 3 to a straight flush'
    return result

  # 13. 2 unsuited high cards (if more than 2 then pick the lowest 2)
  high = getHighCards _hand
  if high.cards.length is 2
    holdCards high
    result.rule = '13.1 2 unsuited high cards'
    return result
  # remove Aces if 2 cards hold else remove kings if 2 cards hold
  if high.cards.length > 2
    # remove aces
    filteredHigh = {}
    doubleFilteredHigh = {}
    filteredHigh.cards = high.cards.filter ( card ) ->
      if card.value isnt 0
        return true
      else
        return false
    if filteredHigh.cards.length is 2
      # console.log 'keep these', filteredHigh
      holdCards filteredHigh
    # remove kings
    doubleFilteredHigh.cards = filteredHigh.cards.filter ( card ) ->
      console.log card.value
      if card.value isnt 12
        return true
      else
        return false
    if doubleFilteredHigh.cards.length is 2
      # console.log 'keep these', doubleFilteredHigh
      holdCards doubleFilteredHigh
    result.rule = '13.2 2 unsuited high cards (if more than 2 then pick the lowest 2)'
    return result

  # 14. Suited 10/J, 10/Q, or 10/K
  # Never 2 suited highs becuase rule 11
  # Only ever one 10, because pair would be held
  high = getHighCards _hand
  if high.cards.length > 0
    if handHasValue _hand, 9 # has a 10?
      _hand.forEach ( card ) ->
        if card.value is 9
          card.hold()
      holdCards high
      result.rule = '14. Suited 10/J, 10/Q, or 10/K'
      return result

  # 15. One high card
  # only one high card available because rule 13
  if high.cards.length is 1
    result.rule = '15. One high card'
    high.cards[0].hold()
    renderHand _hand
    return result

  # 16. Discard everything
  result.rule = '16. Hold Nothing'
  return result
