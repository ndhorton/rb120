# We generally want a hand to be sorted in order of magnitude
# the ace confuses the issue though. You could have a property
# of a card and a sorting method that calls something like
# player.hand.sort_by { |card| card.max_value }.reverse
# A sorting operation is fairly expensive, particularly sort_by
# so I assume the player cards are kept in an unsorted array
# and only get sorted on display

# Are there really two types of player? The only difference really,
# unless the semantic of Dealer#deal is actually mandatory, is that
# the human Player has to choose cards based on human reasoning
# with an IO loop to show cards and get actions.
# The dealer simply accepts more and more cards until the score
# of his hand is >= 17. Are we likely to encapsulate the
# logic of the IO loop etc in Player?

# The dealer dealing is a bit hard to think about.
# If player.hit is to accrue an additional card to the player.hand
# then how is the interface if the dealer is involved

# class Player:
# def hit
#   @hand << @dealer.deal
# end

# class Dealer:
# def deal
#   @deck.remove_top_card!
# end

# so player needs access to the Dealer who needs access to the Deck

# Should both players have access to a common @deck? Should the deck
# be passed? So then we have player.hit(deck)

# Maybe just have Player.new(deck) and pass a ref to the deck at creation

class Participant
  attr_reader :hand

  def busted?
    total > 21
  end

  def hit
    hand << @deck.deal
  end

  def show_hand
    card_descriptions = hand.map(&:to_s)
    case card_descriptions.size
    when 0 then ""
    when 1 then card_descriptions.first
    when 2 then "#{card_descriptions.first} and #{card_descriptions.last}"
    else
      "#{card_descriptions[0..-2].join(', ')}, and #{card_descriptions.last}"
    end
  end

  def stick
    @stuck = true
  end

  def sticks?
    @stuck
  end

  def reset(common_deck)
    @deck = common_deck
    @hand = []
    @stuck = false
  end

  def total
    aces, other_cards = @hand.partition { |card| card.face == :ace }

    other_card_sum = other_cards.reduce(0) { |acc, card| acc + card.max_value }
    aces.reduce(other_card_sum) do |acc, card|
      (acc + card.max_value > 21) ? (acc + 1) : (acc + card.max_value)
    end
  end

  def initialize(common_deck)
    reset(common_deck)
  end
end

class Player < Participant
  attr_accessor :name
end

class Dealer < Participant
  def show_partial_hand
    "#{visible_card}, and #{pluralize_others}"
  end

  private

  def number_of_hidden_cards
    hand.size - 1
  end

  def pluralize_others
    case number_of_hidden_cards
    when 1 then "#{number_of_hidden_cards} other card"
    else
      "#{number_of_hidden_cards} other cards"
    end
  end

  def visible_card
    hand.first
  end
end

class Deck
  SUITS = [:spades, :clubs, :diamonds, :hearts]
  FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

  def initialize
    @cards = []
    setup_cards
  end
  
  def deal
    @cards.pop
  end

  private

  def setup_cards
    SUITS.each do |suit|
      FACES.each do |face|
        @cards << Card.new(face, suit)
      end
    end
    @cards.shuffle!
  end
end

class Card
  ROYALS = [:jack, :queen, :king]

  attr_reader :face, :suit

  def initialize(face, suit)
    @face = face
    @suit = suit 
  end

  def max_value
    if face == :ace             then 11
    elsif ROYALS.include?(face) then 10
    else
      face
    end
  end

  def to_s
    "the #{face.to_s.capitalize} of #{suit.capitalize}"
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @player = Player.new(deck)
    @dealer = Dealer.new(deck)
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn unless player.busted?
    show_result
  end

  private

  def deal_cards
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def dealer_turn
    dealer.hit while dealer.total < 17
    dealer.stick
  end

  def player_turn
    loop do
      puts "Do you want to (h)it or (s)tick?"
      answer = nil
      loop do
        answer = gets.chomp.strip.downcase
        break if %w(h s hit stick).include?(answer)
        puts "Sorry, must be (h)it or (s)tick"
      end
      player.hit if answer.start_with? 'h'
      player.stick if answer.start_with? 's'
      break if player.sticks? || player.busted?
      show_initial_cards
    end
  end

  def show_initial_cards
    puts "The dealer has #{dealer.show_partial_hand}"
    puts "You have #{player.show_hand}, for a total of #{player.total} points"
    puts ""
  end

  def show_result
    puts "The dealer has #{dealer.show_hand}, " \
         "for a total of #{dealer.total} points.\n" \
         "You have #{player.show_hand}, for a total of #{player.total} points."
    if dealer.busted?
      puts "The dealer is busted! You won!"
    elsif player.busted?
      puts "You are busted! The dealer won!"
    elsif player.total > dealer.total
      puts "You won!"
    elsif player.total < dealer.total
      puts "The dealer won!"
    else
      puts "It's a tie!"
    end
  end
end

Game.new.start
