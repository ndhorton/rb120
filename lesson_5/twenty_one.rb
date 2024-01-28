require 'io/console'
require 'psych'

TEXT = Psych.load_file("#{__dir__}/twenty_one_text.yaml")['english']
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
  2 => 'two'
}

RED = "\e[31m"
RESET = "\e[0m"

HEART = "#{RED}\u2665#{RESET}"
DIAMOND = "#{RED}\u2666#{RESET}"
CLUB = "\u2667"
SPADE = "\u2664"

module Pageable
  private

  def display_appropriate_footer(max_row, text_size)
    color = { color: RED, reset: RESET }
    puts
    if max_row < text_size - 1
      print format(TEXT['pager_scroll'], color)
    else
      print format(TEXT['pager_return'], color)
    end
  end

  def display_lines(start_row, max_row, lines)
    puts lines[start_row..max_row]
  end

  def display_page(start_row, max_row, lines)
    $stdout.clear_screen
    display_lines(start_row, max_row, lines)
    display_appropriate_footer(max_row, lines.size)
  end

  def page(lines)
    system('tput init')
    system('tput civis')
    paging_loop(0, page_length, lines)
    $stdout.clear_screen
  ensure
    system('tput cnorm')
  end

  def page_length
    max_row, = $stdout.winsize
    max_row - 3 # accomodate footer
  end

  def paging_loop(start_row, max_row, lines)
    loop do
      display_page(start_row, max_row, lines)
      input = $stdin.getch
      if input == ' ' && max_row < lines.size - 1
        start_row += 1
        max_row += 1
      elsif input == TEXT['quit']
        break
      end
    end
  end
end

module Displayable
  private

  SUIT_ICONS = { hearts: HEART, diamonds: DIAMOND, clubs: CLUB, spades: SPADE }

  def ellipsis
    3.times do
      print '.'
      sleep 0.5
    end
  end

  def goodbye
    $stdout.clear_screen
    show_final_scores
    puts TEXT['goodbye']
  end

  def show_banner
    $stdout.clear_screen
    print RED
    puts TEXT['banner']
    puts RESET
  end

  def show_cards
    $stdout.clear_screen
    puts TEXT['dealer_partial_hand']
    show_partial_hand(dealer.hand)

    puts format(TEXT['player_hand'],
                player_name: player.name, player_total: player.total)
    show_hand(player.hand)
  end

  def show_dealer_busted
    puts format(TEXT['busted_dealer'], player_name: player.name)
  end

  def show_dealer_won
    puts TEXT['dealer_won']
  end

  def show_player_busted
    puts format(TEXT['busted_player'], player_name: player.name)
  end

  def show_player_won
    puts format(TEXT['player_won'], player_name: player.name)
  end

  def show_tie
    puts TEXT['tie']
  end

  def show_final_cards
    $stdout.clear_screen
    puts format(TEXT['dealer_full_hand'], final_cards_data)
    show_hand(dealer.hand)
    puts format(TEXT['player_hand'], final_cards_data)
    show_hand(player.hand)
  end

  def show_final_scores
    data = final_score_data
    TEXT['final_scores'].each { |line| puts format(line, data) }
  end

  def show_hand(hand)
    hand.each_slice(6) do |card_group|
      visual_cards = represent_cards(card_group)
      (0...visual_cards.first.size).each do |line_index|
        line = ''
        visual_cards.each { |card| line << ' ' << card[line_index] }
        puts line
      end
    end
  end

  def show_partial_hand(hand)
    cards = [represent_first_card(hand)]
    (hand.size - 1).times { cards << CARD_ART['turned'] }
    cards.each_slice(6) do |visual_cards|
      (0...visual_cards.first.size).each do |line_index|
        line = ''
        visual_cards.each { |card| line << ' ' << card[line_index] }
        puts line
      end
    end
  end

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

  def represent_first_card(hand)
    first_card = hand.first
    art_key = VISUAL_CARDS[first_card.face]
    card_value = first_card.to_s
    suit_icon = SUIT_ICONS[first_card.suit]
    CARD_ART[art_key].map do |line|
      format(line, face: card_value, suit: suit_icon)
    end
  end

  def welcome
    show_banner
    puts TEXT['welcome_message']
  end
end

module Promptable
  private

  def play_again?
    puts TEXT['play_again']
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if TEXT['yes_or_no'].include?(answer)
      puts TEXT['yes_or_no_error']
    end
    answer[0] == 'y'
  end

  def prompt_for_player_name
    puts TEXT['name_message']
    answer = nil
    loop do
      answer = gets.chomp.strip
      break unless answer.empty?
      puts TEXT['name_error']
    end
    answer
  end

  def prompt_for_hit_or_stay
    puts TEXT['hit_or_stay_message']
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if TEXT['hit_or_stay_options'].include?(answer)
      puts TEXT['hit_or_stay_error']
    end
    answer
  end

  def see_rules?
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if TEXT['yes_or_no'].include?(answer)
      puts TEXT['yes_or_no_error']
    end
    answer.start_with?(TEXT['affirmative'])
  end
end

class Participant
  attr_accessor :name
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

  def stay
    @stay = true
  end

  def stayed?
    @stay
  end

  def reset(common_deck)
    @deck = common_deck
    @hand = []
    @stay = false
  end

  def total
    result = hand.sum(&:max_value)
    number_of_aces = hand.count { |card| card.face == 'A' }
    number_of_aces.times { result -= 10 if result > 21 }
    result
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
  include Displayable
  include Pageable
  include Promptable

  def initialize
    @deck = Deck.new
    @player = Participant.new(deck)
    @dealer = Participant.new(deck)
    @scores = {
      player: 0,
      dealer: 0,
      tie: 0
    }
  end

  def play
    welcome
    set_player_name
    rules_check
    game_loop
    goodbye
  end

  private

  attr_reader :player, :dealer, :deck, :scores

  def announce_winner
    show_final_cards
    declare_winner
  end

  def deal_cards
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def dealer_hits
    puts TEXT['dealer_hits']
    sleep 1
    dealer.hit
  end

  def dealer_stays
    puts TEXT['dealer_stays']
    dealer.stay
    sleep 1
  end

  def dealer_turn
    until dealer.busted? || dealer.stayed?
      show_cards
      print TEXT['dealer_thinking']
      ellipsis
      if dealer.total < 17
        dealer_hits
      else
        dealer_stays
      end
    end
  end

  def dealer_won?
    !dealer.busted? && (player.total < dealer.total)
  end

  def declare_winner
    if player.busted?    then show_player_busted
    elsif dealer.busted? then show_dealer_busted
    elsif player_won?    then show_player_won
    elsif dealer_won?    then show_dealer_won
    else
      show_tie
    end
  end

  def final_cards_data
    {
      player_name: player.name,
      player_total: player.total,
      dealer_total: dealer.total
    }
  end

  def final_score_data
    {
      player_name: player.name,
      player: pluralize_game(scores[:player]),
      dealer: pluralize_game(scores[:dealer]),
      tie: pluralize_game(scores[:tie])
    }
  end

  def game_loop
    loop do
      deal_cards
      player_turn
      dealer_turn unless player.busted?
      tally_scores
      announce_winner
      break unless play_again?
      reset
    end
  end

  def player_turn
    loop do
      show_cards
      answer = prompt_for_hit_or_stay
      player.hit if answer.start_with? TEXT['hit']
      player.stay if answer.start_with? TEXT['stay']
      break if player.stayed? || player.busted?
    end
  end

  def player_won?
    !player.busted? && (player.total > dealer.total)
  end

  def pluralize_game(number_of_games)
    case number_of_games
    when 0 then TEXT['games_none']
    when 1 then "#{number_of_games} #{TEXT['game']}"
    else
      "#{number_of_games} #{TEXT['games']}"
    end
  end

  def reset
    @deck = Deck.new
    player.reset(deck)
    dealer.reset(deck)
  end

  def rules_check
    puts TEXT['rules_check']
    page(TEXT['rules']) if see_rules?
  end

  def set_player_name
    player.name = prompt_for_player_name
  end

  def tally_scores
    if dealer.busted? || player_won?
      scores[:player] += 1
    elsif player.busted? || dealer_won?
      scores[:dealer] += 1
    else
      scores[:tie] += 1
    end
  end
end

TwentyOne.new.play
