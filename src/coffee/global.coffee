# Globals
_$events = $ {}
_hand = []

# DOM Globals
$buttons = $ '.buttons'

# DOM Binding Helper

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

# AUTO Strategy Functions

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
