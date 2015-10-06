'use strict'

if typeof window is 'undefined'
  Card = require './card'

Deck = ( options ) ->
  @opts = options or {}
  @suits = [0..3]
  @values = [0..12]
  if @opts.cards is undefined
    @cards = @init().shuffle()
  else
    @cards = @opts.cards.map ( card ) ->
      return new Card card
  @shuffled = false
  return @

Deck::init = ->
  self = @
  @cards = @suits.map( ( suit, i ) ->
    return self.values.map( ( value, val_i ) ->
      return new Card(
        suit: suit
        value: value
      )
    )
  )
  .reduce( ( a, b ) ->
    return a.concat( b )
  )
  return @

Deck::shuffle = ->
  array = @cards
  counter = @cards.length
  temp = undefined
  index = undefined
  while counter > 0
    index = Math.random() * counter-- | 0
    temp = array[counter]
    array[counter] = array[index]
    array[index] = temp
  @shuffled = true
  return array

Deck::draw = ->
  return @cards.shift()

if typeof window is 'undefined'
	module.exports = Deck
else
	window.Deck = Deck
