# Globals
_$events = $ {}
_user = {}
# DOM Globals
$buttons = $ '.buttons'
$credits = $ '.credits'
$rule = $ '.rule'
$hand = $ '.hand'
$deal = $ '.deal'
$draw = $ '.draw'

# DOM Binding Helpers
renderCards = ( cards ) ->
  return cards.forEach ( card, i ) ->
    $card = $ '.card-' + ( i + 1 )
    $card
      .removeClass 'hold red black'
      .text card.text()
      .addClass card.color()
    if card.held
      $card.addClass 'hold'
    return

renderHand = ( hand ) ->
  return hand.cards.forEach ( card, i ) ->
    $card = $ '.card-' + ( i + 1 )
    $card
      .removeClass 'hold red black'
      .text card.text()
      .addClass card.color()
    if card.held
      $card.addClass 'hold'
    return

updateCreds = ( amount ) ->
  return $credits.text amount

# something...
clearHolds = ( cards ) ->
  cards.forEach ( card ) ->
    card.drop()
    return
  return

# AUTO Strategy Functions

# This utility was replaced by card.hold()
# holdIndex = ( hand, indexArrayToHold ) ->
#   hand.forEach ( card, idx ) ->
#     # console.log idx, indexArrayToHold, indexArrayToHold.indexOf idx
#     if indexArrayToHold.indexOf(idx) isnt -1
#       card.hold()
#     return
#   renderHand _user.hand hand
#   return

holdAllExcept = ( cards, index ) ->
  # console.log cards, index
  cards.forEach ( card, i ) ->
    if i isnt index
      card.hold()
    # console.log card, i, index
    return
  renderCards cards
  return

holdSuit = ( cards, suit ) ->
  cards.forEach ( card ) ->
    if card.suit is suit
      card.hold()
    return
  renderCards cards
  return

holdDupes = ( cards, length ) ->
  [0..12].forEach ( v, i ) ->
    holds = []
    cards.forEach ( card, idx ) ->
      if card.value == v
        holds.push( idx )
      return
    if holds.length is length
      cards.forEach ( card, index ) ->
        if card.value is v
          card.hold()
      return
  renderCards cards
  return

holdAll = ( cards ) ->
  cards.forEach ( card ) ->
    card.hold()
    return
  renderCards cards
  return
