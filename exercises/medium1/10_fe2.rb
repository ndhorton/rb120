# Poker

=begin

subprocess pair?
Given a hand of 5 cards, @hand
Set ranks := transform @hand to an array of only the ranks of each card
Iterate over each target_value in @hand
  If the count of target_value == 2
    Return true
Return false

=end

# Include Card and Deck classes from the last two exercises.

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

# class PokerHand
#   ROYAL_STRAIGHT = [10, 'Jack', 'Queen', 'King', 'Ace'].freeze

#   def initialize(deck)
#     @hand = []
#     5.times { @hand << deck.draw }
#   end

#   def print
#     puts @hand 
#   end

#   def evaluate
#     case
#     when royal_flush?     then 'Royal flush'
#     when straight_flush?  then 'Straight flush'
#     when four_of_a_kind?  then 'Four of a kind'
#     when full_house?      then 'Full house'
#     when flush?           then 'Flush'
#     when straight?        then 'Straight'
#     when three_of_a_kind? then 'Three of a kind'
#     when two_pair?        then 'Two pair'
#     when pair?            then 'Pair'
#     else                       'High card'
#     end
#   end

#   private

#   def ranks
#     @hand.map(&:rank)
#   end

#   def royal_flush?
#     sorted_ranks = @hand.sort_by(&:value).map(&:rank)
#     sorted_ranks == ROYAL_STRAIGHT && flush?
#   end

#   def straight_flush?
#     straight? && flush?
#   end

#   def four_of_a_kind?
#     counts = Hash.new(0)
#     ranks.each { |rank| counts[rank] += 1 }
#     counts.values.any?(4)
#   end

#   def full_house?
#     pair? && three_of_a_kind?
#   end

#   def flush?
#     @hand.map(&:suit).uniq.size == 1
#   end

#   def straight?
#     sorted_values = @hand.map(&:value).sort
#     sorted_values.each_cons(2) do |a, b|
#       return false unless (b - a) == 1
#     end
#     true
#   end

#   def three_of_a_kind?
#     counts = Hash.new(0)
#     ranks.each { |rank| counts[rank] += 1 }
#     counts.values.any?(3)
#   end

#   def two_pair?
#     counts = Hash.new(0)
#     ranks.each { |rank| counts[rank] += 1 }
#     counts.values.count(2) == 2
#   end

#   def pair?
#     counts = Hash.new(0)
#     ranks.each { |rank| counts[rank] += 1 }
#     counts.values.any?(2)
#   end
# end

class PokerHand
  include Comparable

  HAND_VALUES = {
    'Royal flush' => 10,
    'Straight flush' => 9,
    'Four of a kind' => 8,
    'Full house' => 7,
    'Flush' => 6,
    'Straight' => 5,
    'Three of a kind' => 4,
    'Two pair' => 3,
    'Pair' => 2,
    'High card' => 1
  }

  def initialize(cards)
    @cards = []
    @rank_count = Hash.new(0)

    5.times do
      card = cards.draw
      @cards << card
      @rank_count[card.rank] += 1
    end
  end

  def print
    puts @cards
  end

  def evaluate
    if    royal_flush?     then 'Royal flush'
    elsif straight_flush?  then 'Straight flush'
    elsif four_of_a_kind?  then 'Four of a kind'
    elsif full_house?      then 'Full house'
    elsif flush?           then 'Flush'
    elsif straight?        then 'Straight'
    elsif three_of_a_kind? then 'Three of a kind'
    elsif two_pair?        then 'Two pair'
    elsif pair?            then 'Pair'
    else
      'High card'
    end   
  end

  def <=>(other_hand)
    HAND_VALUES[evaluate] <=> HAND_VALUES[other_hand.evaluate]
  end

  def compare(other_hand)
    if self > other_hand
      self
    else
      other_hand
    end
  end

  private

  def flush?
    suit = @cards.first.suit
    @cards.all? { |card| card.suit == suit }
  end

  def straight?
    return false if @rank_count.any? { |_, count| count > 1 }

    @cards.min.value == @cards.max.value - 4
  end

  def n_of_a_kind?(number)
    @rank_count.one? { |_, count| count == number }
  end

  def straight_flush?
    flush? && straight?
  end

  def royal_flush?
    straight_flush? && @cards.min.rank == 10
  end

  def four_of_a_kind?
    n_of_a_kind?(4)
  end

  def full_house?
    n_of_a_kind?(3) && n_of_a_kind?(2)
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_pair?
    @rank_count.select { |_, count| count == 2 }.size == 2
  end

  def pair?
    n_of_a_kind?(2)
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand1 = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand1.evaluate == 'Royal flush'

hand2 = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand2.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'

puts hand1.compare(hand2).print