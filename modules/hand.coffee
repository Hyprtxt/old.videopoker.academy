'use strict'

Deck = require './deck'
Card = require './card'

Hand = ( options ) ->
  @opts = options or {}
  if @opts.deck is undefined
    @deck = new Deck()
  else
    @deck = new Deck cards: @opts.deck
  @size = @opts.size or 5
  if @opts.cards is undefined
    @cards = []
  else
    @cards = @opts.cards.map ( card ) ->
      return new Card card
  # console.log @deck instanceof Deck, 'INSTANCE CHECK'
  while @cards.length < @size
    @cards.push @deck.draw()
  return @

Hand::replace = ( index ) ->
  idx = index or 0
  @cards.splice( idx, 1, @deck.draw() )
  return

Hand::keepArray = ( array ) ->
  self = @
  # console.log array
  array.map ( i ) ->
    self.replace( i )
  return

Hand::keepOne = ( index ) ->
  idx = index or 0
  [0..4].map ( v ) ->
    if idx != v
      @replace( idx )
  return

module.exports = Hand
