# Deck of Cards

=begin

P:

The Deck class should provide a #draw method to deal one card.
The Deck should be shuffled when it is initialized and, if it runs
out of cards, it should reset itself by generating a new set of 52
shuffled cards.

rules:
  deck must be shuffled at initialization
  if the cards run out, Deck should generate another 52-card deck
    and shuffle it
  #draw method must remove a card from the deck and return it

Etc:

DS:

A:

=end

class Card
  include Comparable

  attr_reader :rank, :suit

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }.freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    VALUES.fetch(rank, rank)
  end

  def <=>(other_card)
    value <=> other_card.value
  end
end

# class Deck
#   RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
#   SUITS = %w(Hearts Clubs Diamonds Spades).freeze

#   def initialize
#     @cards = []
#     SUITS.each do |suit|
#       RANKS.each { |rank| @cards << Card.new(rank, suit) }
#     end
#     @cards.shuffle!
#   end

#   def reset
#     @cards = []
#     SUITS.each do |suit|
#       RANKS.each { |rank| @cards << Card.new(rank, suit) }
#     end
#     @cards.shuffle!
#   end

#   def draw
#     reset if @cards.empty?
#     @cards.pop
#   end
# end

# LS solution
class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reset
  end

  def draw
    reset if @deck.empty?
    @deck.pop
  end

  private

  def reset
    @deck = RANKS.product(SUITS).map do |rank, suit|
      Card.new(rank, suit)
    end

    @deck.shuffle!
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.