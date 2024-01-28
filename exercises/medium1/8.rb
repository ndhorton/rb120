# Highest and Lowest Ranking Cards

=begin

notes:
I think the <=> method needs to be implemented in order
for things like sort, min, max, etc to manipulate an object

I am not sure if I need to include Enumerable but I don't think so

An implicit requirement I had not grasped though it now seems obvious
from the test cases, is that I need to add an == method

Ah, the Enumerable module is not needed but the Comparable module
can derive an == method from the <=> method, so including that
is another option as opposed to defining your own == method.
I think i was thinking of Comparable all along, since Enumerable
should surely only be included in collection classes?

P:

Alter the Card class so that it can respond to the Array#min and Array#max
methods and so that it can return a string representation of itself

rules:
  implement to_s method according to use cases
  xxxxxCard needs strings or symbols for non-numeric cards and suits?
  2-10 are worth face value
  jacks are higher than 10
  queens higher than jacks
  kings higher than queens
  aces higher than kings

Etc:

2 of Hearts
10 of Diamonds
Ace of Clubs

DS:

<=> method calls value and compares to other.value
so value should be at most protected but not private

A:

subprocess value
given an integer or a string, rank
if rank is an integer from 2-10
  return rank
else <- assuming you are only given correct values, it will be a string
  return evaluate

subprocess evaluate
given a string, rank
if rank == 'Jack'
  return 11
else if rank == 'Queen'
  return 12
...
else if rank == 'Ace'
  return 14

=end

# class Card
#   attr_reader :rank, :suit

#   def initialize(rank, suit)
#     @rank = rank
#     @suit = suit
#   end

#   def <=>(other)
#     value <=> other.value
#   end

#   def ==(other)
#     value == other.value
#   end

#   def to_s
#     "#{rank} of #{suit}"
#   end

#   protected # optional

#   def value
#     if (2..10).cover?(rank)
#       rank
#     else
#       evaluate
#     end
#   end

#   private

#   def evaluate
#     case rank
#     when 'Jack'  then 11
#     when 'Queen' then 12
#     when 'King'  then 13
#     when 'Ace'   then 14
#     end
#   end
# end

# LS solution

class Card
  include Comparable

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }
  SUIT_VALUES = { 'Diamonds' => 1, 'Clubs' => 2, 'Hearts' => 3, 'Spades' => 4 }

  attr_reader :rank, :suit

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

  def suit_value
    SUIT_VALUES[suit]
  end

  def <=>(other_card)
    if rank == other_card.rank
      suit_value <=> other_card.suit_value
    else
      value <=> other_card.value
    end
  end
end

cards = [Card.new(2, 'Hearts'),
  Card.new(10, 'Diamonds'),
  Card.new('Ace', 'Clubs')]
puts cards
puts cards.min == Card.new(2, 'Hearts')
puts cards.max == Card.new('Ace', 'Clubs')

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
  Card.new(4, 'Diamonds'),
  Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
  Card.new('Jack', 'Diamonds'),
  Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'

cards = [Card.new(8, 'Diamonds'),
  Card.new(8, 'Clubs'),
  Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8

cards = [Card.new('Ace', 'Spades'), Card.new('Ace', 'Diamonds')]
puts cards.min
puts cards.max
