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

class PokerHand
  def self.flush?(cards)
    suit = cards.first.suit
    cards.all? { |card| card.suit == suit }
  end

  def self.straight?(cards)
    return false if rank_count(cards).any? { |_, count| count > 1 }

    cards.min.value == cards.max.value - 4
  end

  def self.straight_flush?(cards)
    flush?(cards) && straight?(cards)
  end

  def self.royal_flush?(cards)
    straight_flush?(cards) && cards.min.rank == 10
  end

  def self.four_of_a_kind?(cards)
    n_of_a_kind?(cards, 4)
  end

  def self.full_house?(cards)
    n_of_a_kind?(cards, 3) && n_of_a_kind?(cards, 2)
  end

  def self.three_of_a_kind?(cards)
    n_of_a_kind?(cards, 3)
  end

  def self.two_pair?(cards)
    rank_count(cards).select { |_, count| count == 2 }.size == 2
  end

  def self.pair?(cards)
    n_of_a_kind?(cards, 2)
  end

  private_class_method def self.rank_count(cards)
    result = Hash.new(0)
    cards.each { |card| result[card.rank] += 1 }
    result
  end
  
  private_class_method def self.n_of_a_kind?(cards, number)
    rank_count(cards).one? { |_, count| count == number }
  end
end



p PokerHand.royal_flush?([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])

p PokerHand.straight_flush?([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])

p PokerHand.four_of_a_kind?([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])

p PokerHand.full_house?([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])

p PokerHand.flush?([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])

p PokerHand.straight?([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])

p PokerHand.straight?([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])


p PokerHand.three_of_a_kind?([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])


p PokerHand.two_pair?([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])


p PokerHand.pair?([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
