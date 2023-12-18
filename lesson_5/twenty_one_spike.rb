require 'psych'

CARD_ART = Psych.load_file("#{__dir__}/twenty_one_card_art.yaml")

VISUAL_CARDS = {
  'A' => 'ace',
  'K' => 'royal',
  'Q' => 'royal',
  'J' => 'royal',
  10 => 'ten',
  9 => 'nine',
  8 => 'eight',
  7 => 'seven',
  6 => 'six',
  5 => 'five',
  4 => 'four',
  3 => 'three',
  2 => 'two',
}

RED = "\e[31m"
RESET = "\e[0m"

HEART = "#{RED}\u2665#{RESET}"
DIAMOND = "#{RED}\u2666#{RESET}"
CLUB = "\u2667"
SPADE = "\u2664"

SUIT_ICONS = {
  hearts: HEART,
  diamonds: DIAMOND,
  clubs: CLUB,
  spades: SPADE
}

class Participant
  attr_reader :hand

  def initialize(common_deck)
    reset(common_deck)
  end

  def busted?
    total > 21
  end

  def hit
    hand << @deck.deal
  end

  def show_hand
    hand.each_slice(6) do |chunk_of_hand|
      visual_cards = represent_cards(chunk_of_hand)
      (0...visual_cards.first.size).each do |line_index|
        line = ''
        visual_cards.each { |card| line << ' ' << card[line_index] }
        puts line
      end
    end
  end

  def stay
    @stuck = true
  end

  def stays?
    @stuck
  end

  def reset(common_deck)
    @deck = common_deck
    @hand = []
    @stuck = false
  end

  def total
    aces, other_cards = @hand.partition { |card| card.face == 'A' }

    other_card_sum = other_cards.reduce(0) { |acc, card| acc + card.max_value }
    aces.reduce(other_card_sum) do |acc, card|
      (acc + card.max_value > 21) ? (acc + 1) : (acc + card.max_value)
    end
  end

  private

  def represent_cards(chunk_of_hand)
    chunk_of_hand.map do |card|
      art_key = VISUAL_CARDS[card.face]
      card_value = card.to_s
      suit_icon = SUIT_ICONS[card.suit]
      CARD_ART[art_key].map do |line|
        format(line, face: card_value, suit: suit_icon)
      end
    end
  end
end

class Player < Participant
  attr_accessor :name
end

class Dealer < Participant
  def show_partial_hand
    cards = [represent_first_card]
    (hand.size - 1).times { cards << CARD_ART['turned'] }
    cards.each_slice(6) do |visual_cards|
      (0...visual_cards.first.size).each do |line_index|
        line = ''
        visual_cards.each { |card| line << ' ' << card[line_index] }
        puts line
      end
    end
  end

  private

  def represent_first_card
    first_card = hand.first
    art_key = VISUAL_CARDS[first_card.face]
    card_value = first_card.to_s
    suit_icon = SUIT_ICONS[first_card.suit]
    CARD_ART[art_key].map do |line|
      format(line, face: card_value, suit: suit_icon)
    end
  end
end

class Deck
  SUITS = [:spades, :clubs, :diamonds, :hearts]
  FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']

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
  ROYALS = ['J', 'Q', 'K']
  RED_SUITS = [:hearts, :diamonds]

  attr_reader :face, :suit

  def initialize(face, suit)
    @face = face
    @suit = suit 
  end

  def max_value
    if face == 'A'              then 11
    elsif ROYALS.include?(face) then 10
    else
      face
    end
  end

  def to_s
    RED_SUITS.include?(suit) ? "#{RED}#{face}#{RESET}" : face
  end
end

class TwentyOne
  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @player = Player.new(deck)
    @dealer = Dealer.new(deck)
  end

  def start
    welcome
    set_player_name
    deal_cards
    loop do
      player_turn
      dealer_turn unless player.busted?
      show_result
      break unless play_again?
    end
    goodbye
  end

  private

  def welcome
    system('clear')
    puts "Welcome to Twenty-One!"
  end

  def goodbye
    system('clear')
    puts "Thanks for playing Twenty-One! Good bye!"
  end

  def play_again?
    puts "Would you like to play again (y or n)?"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      puts "Sorry, must be y or n"
    end
    answer[0] == 'y'
  end

  def deal_cards
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def dealer_turn
    loop do
      show_cards
      print "Dealer is thinking"
      3.times do
        print '.'
        sleep 0.5
      end
      if dealer.total < 17
        print " Dealer hits!\n"
        sleep 1
        dealer.hit
        next
      end
      print " Dealer stays!\n"
      dealer.stay
      sleep 1
      break
    end
  end

  def player_turn
    loop do
      show_cards
      puts "Do you want to (h)it or (s)tay?"
      answer = nil
      loop do
        answer = gets.chomp.strip.downcase
        break if %w(h s hit stay).include?(answer)
        puts "Sorry, must be (h)it or (s)tay"
      end
      player.hit if answer.start_with? 'h'
      player.stay if answer.start_with? 's'
      break if player.stays? || player.busted?
    end
  end

  def set_player_name
    puts "Please enter your name: "
    answer = nil
    loop do
      answer = gets.chomp.strip
      break unless answer.empty?
      puts "Sorry, name must contain at least one character"
    end
    player.name = answer
  end

  def show_cards
    system('clear')
    puts "Dealer's hand: (? points)"
    dealer.show_partial_hand

    puts "#{player.name}'s hand: (#{player.total} points)"
    player.show_hand
  end

  def show_result
    system('clear')
    puts "Dealer's hand: (#{dealer.total} points)"
    dealer.show_hand
    puts "#{player.name}'s hand:"
    player.show_hand
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

TwentyOne.new.start
