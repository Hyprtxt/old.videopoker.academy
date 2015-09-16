'use strict'

# !!! This is a shared module, used both server and client side

Card = ( options ) ->
  @opts = options or {}
  @suit = @opts.suit or 0
  @value = @opts.value or 0
  @held = false
  return @

Card::hold = ->
  @held = true
  return @

Card::drop = ->
  @held = false
  return @

Card::holdToggle = ->
  @held = !@held
  return @

Card::isHigh = ->
  if @value is 0
    return true
  if @value is 9
    return true
  if @value is 10
    return true
  if @value is 11
    return true
  if @value is 12
    return true
  return false

Card::valueLetter = ->
  valueLetter = [
    'A'
    '2'
    '3'
    '4'
    '5'
    '6'
    '7'
    '8'
    '9'
    'T'
    'J'
    'Q'
    'K'
  ]
  return valueLetter[@value]

Card::valueNames = ->
  valueNames = [
    'ace'
    'two'
    'three'
    'four'
    'five'
    'six'
    'seven'
    'eight'
    'nine'
    'ten'
    'jack'
    'queen'
    'king'
  ]
  return valueNames[@value]

Card::suitName = ->
  suitNames = [
    'hearts'
    'diamonds'
    'clubs'
    'spades'
  ]
  return suitNames[@suit]

Card::unicodeSuit = ->
  suitUnicodeOutline = [
    '\u2661'
    '\u2662'
    '\u2667'
    '\u2664'
  ]
  return suitUnicodeOutline[@suit]

Card::color = ->
  # console.log( @suit )
  if @suit == 0 or @suit == 1
    return 'red'
  else
    return 'black'

Card::text = ->
  return @valueLetter() + @unicodeSuit()

if typeof window is 'undefined'
	module.exports = Card
else
	window.Card = Card
