'use strict'

if typeof window is 'undefined'
  Card = require './card'
  Deck = require './deck'
# Else we assume we have Globals

Hand = ( options ) ->
  # options =
  #   deck: [ Card ]
  #   cards: [ Card ]
  #   played: Boolean
  #   length: Int
  @opts = options or {}
  if @opts.deck is undefined
    @deck = new Deck()
  else
    @deck = new Deck cards: @opts.deck
  @played = @opts.played or false
  if @opts.cards is undefined
    @cards = []
  else
    @cards = @opts.cards.map ( card ) ->
      return new Card card
  # console.log @deck instanceof Deck, 'INSTANCE CHECK'
  @size = @opts.size or 5
  while @cards.length < @size
    @cards.push @deck.draw()
  return @

Hand::replace = ( index ) ->
  idx = index or 0
  @cards.splice( idx, 1, @deck.draw() )
  return

if typeof window is 'undefined'
	module.exports = Hand
else
	window.Hand = Hand
