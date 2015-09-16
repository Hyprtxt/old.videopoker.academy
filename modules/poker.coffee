'use strict'
# Jacks or Better scoring

# !!! This is a shared module, used both server and client side
# This module is just a function, different from the others

Poker = ( cards, bet ) ->
  self = @
  bet = bet || 5

  values = cards.map ( card, i ) ->
    return card.value

  values.sort ( a, b ) ->
    return a - b

  suits = cards.map ( card, i ) ->
    return card.suit

  # console.log suits, values
  # , suits.sort( sortNumber )

  score =
    status: 'ulose'
    win: 0

  straights = [
    [1..5]
    [2..6]
    [3..7]
    [4..8]
    [5..9]
    [6..10]
    [7..11]
    [8..12]
  ]
  royal_straight = [0,9,10,11,12]
  royal = false
  straight = false
  flush = false
  pair1 = false
  pair2 = false
  triple = false
  quad = false
  jacksorbetter = false

  # console.log( values )

  # royal straigt checker
  if JSON.stringify( values ) is JSON.stringify( royal_straight )
    royal = true

  # straight checker
  straights.forEach ( v, i ) ->
    if JSON.stringify( values ) is JSON.stringify( v )
      straight = true
    return

  # dupe checker, pair, 2pair, 3kind, 4kind, fullhouse
  [0..12].forEach ( v, i ) ->
    # console.log( v )
    count = 0
    values.forEach ( val, idx ) ->
      if val == v
        count++
      return
    if count is 2
      if v >= 9 or v is 0
        jacksorbetter = true
      if pair1 is true
        pair2 = true
      else
        pair1 = true
    if count is 3
      triple = true
    if count is 4
      quad = true
    return

  # flush checker
  [0..3].forEach ( v, i ) ->
    count = 0
    suits.forEach ( val, idx ) ->
      if val == v
        count++
      return
    if count is 5
      flush = true
    return

  # Score Reporter
  if royal and flush
    score.status = 'royalflush'
    score.win = bet * 800
    return score
  else if straight and flush
    score.status = 'straightflush'
    score.win = bet * 50
    return score
  else if quad
    score.status = '4kind'
    score.win = bet * 25
    return score
  else if triple and pair1
    score.status = 'fullhouse'
    score.win = bet * 9
    return score
  else if flush
    score.status = 'flush'
    score.win = bet * 6
    return score
  else if straight or royal
    score.status = 'straight'
    score.win = bet * 4
    return score
  else if triple
    score.status = '3kind'
    score.win = bet * 3
    return score
  else if pair1 and pair2
    score.status = '2pair'
    score.win = bet * 2
    return score
  else if jacksorbetter
    score.status = 'jacksbetter'
    score.win = bet * 1
    return score
  else if pair1
    score.status = 'lowpair'
    score.win = 0
    return score
  return score

if typeof window is 'undefined'
  module.exports = Poker
else
  window.Poker = Poker
