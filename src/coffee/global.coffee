# Globals
_$events = $ {}
_hand = []

# DOM Globals
$buttons = $ '.buttons'
$credits = $ '.credits'
$rule = $ '.rule'
$hand = $ '.hand'
$deal = $ '.deal'
$draw = $ '.draw'

# DOM Binding Helpers
renderHand = ( hand ) ->
  hand.forEach ( card, i ) ->
    $card = $ '.card-' + ( i + 1 )
    $card
      .removeClass 'hold red black'
      .text card.text()
      .addClass card.color()
    if card.held
      $card.addClass 'hold'
    return
  return

updateCreds = ( amount ) ->
  creds = parseInt $credits.text()
  # console.log creds, amount
  $credits.text creds + amount
  # console.log $credits.text
  return

# something...
clearHolds = ( hand ) ->
  hand.forEach ( card ) ->
    card.drop()
    return

# AUTO Strategy Functions

# This utility was replaced by card.hold()
# holdIndex = ( hand, indexArrayToHold ) ->
#   hand.forEach ( card, idx ) ->
#     # console.log idx, indexArrayToHold, indexArrayToHold.indexOf idx
#     if indexArrayToHold.indexOf(idx) isnt -1
#       card.hold()
#     return
#   renderHand hand
#   return

holdAllExcept = ( hand, index ) ->
  # console.log hand, index
  hand.forEach ( card, i ) ->
    if i isnt index
      card.hold()
    # console.log card, i, index
    return
  renderHand hand
  return

holdSuit = ( hand, suit ) ->
  hand.forEach ( card ) ->
    if card.suit is suit
      card.hold()
    return
  renderHand hand
  return

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
  renderHand hand
  return

holdAll = ( hand ) ->
  hand.forEach ( card ) ->
    card.hold()
    return
  renderHand hand
  return
