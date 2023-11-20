# Rock Paper Scissors - Bonus features

require 'io/console'
require 'yaml'

# TODO: rewrite this spike
#       plan to have Displayable, Pageable, and Color functionality
#       available without namespacing for classes
#       Write rules before you start
#       Extract text to YAML before you start
#       Need bios for the robots and use random numbers and range rules
#         for selecting robot choices rather than array constants and #sample
#       Make sure you allow abbreviated input. Put that in the rules
#       Need to have banner there at all times even when paging
#       A robot HAS A personality, but then a robot IS A Computer Player

module Colors
  BLACK = "\u001b[30m"
  RED = "\u001b[31m"
  GREEN = "\u001b[32m"
  YELLOW = "\u001b[33m"
  BLUE = "\u001b[34m"
  MAGENTA = "\u001b[35m"
  CYAN = "\u001b[36m"
  WHITE = "\u001b[37m"

  RESET = "\u001b[0m"
end

module Displayable
  module RPSGame
    include Colors

    CLEAR = "\e[H\e[2J"
    BANNER_WIDTH = 8

    private

    def banner(message)
      space = ' ' * (BANNER_WIDTH / 2)
      puts "#{YELLOW}+=#{'=' * (message.size + BANNER_WIDTH)}=+#{RESET}"
      puts "#{YELLOW}| #{RESET}" \
            "#{BLUE}#{space}#{message}#{space}#{YELLOW} |#{RESET}"
      puts "#{YELLOW}+=#{'=' * (message.size + BANNER_WIDTH)}=+#{RESET}"
      puts
    end

    def display_banner
      $stdout.clear_screen
      banner("Rock, Paper, Scissors, Lizard, Spock")
    end

    def display_goodbye_message
      name_of_game = Move::VALUES.map(&:capitalize).join(', ')
      puts "Thanks for playing #{name_of_game}. Good bye!"
    end

    def display_moves
      puts "#{human.name} chose #{human.move}."
      puts "#{computer.name} chose #{computer.move}."
    end

    def display_round_winner
      if human.move > computer.move
        puts "#{human.name} won!"
      elsif human.move < computer.move
        puts "#{computer.name} won!"
      else
        puts "It's a tie!"
      end
      puts
    end

    def display_overall_winner
      winner = (human.score > computer.score ? human : computer)
      puts "At the end of #{rounds_played} rounds,\n" \
           "#{human.name} has won #{human.score} rounds,\n" \
           "#{computer.name} has won #{computer.score} rounds,\n" \
           "#{winner.name} is the winner!"
    end
  end

  module Log
    include Colors

    def display
      if events.empty?
        puts "No moves have been made yet.\n"
      else
        page(event_lines)
      end
    end
  end

  module Pageable
    include Colors

    private

    def display_lines(start_y, max_y, text)
      puts text[start_y..max_y]
    end

    def display_appropriate_footer(max_y, text_size)
      if max_y < text_size - 1
        print "#{GREEN}[press <space> to scroll down, q to return to game]#{RESET}"
      else
        print "#{GREEN}[press q to return to game]#{RESET}"
      end
    end
  end
end

module Pageable
  include Displayable::Pageable

  def page(text)
    start_y = 0
    max_y = page_length
    input = nil
    loop do
      $stdout.clear_screen
      display_lines(start_y, max_y, text)
      display_appropriate_footer(max_y, text.size)
      input = $stdin.getch
      if input == ' '
        start_y += 1 unless max_y >= text.size - 1
        max_y += 1 unless max_y >= text.size - 1
      elsif input == 'q'
        break
      end
    end
    $stdout.clear_screen
  end

  def page_length
    max_y, = STDOUT.winsize
    max_y - 2
  end
end

class Log
  include Displayable::Log
  include Pageable

  def initialize
    @events = []
  end

  def <<(log_event)
    events << log_event
  end

  private

  attr_reader :events

  def event_lines
    text = events.reverse.join
    text.split("\n")
  end
end

class LogEvent
  include Colors

  @@number_of_moves = 0

  attr_reader :human_name, :human_move, :computer_name, :computer_move, :number

  def initialize(human_name, human_move, computer_name, computer_move)
    @human_name = human_name
    @human_move = human_move

    @computer_name = computer_name
    @computer_move = computer_move

    @@number_of_moves += 1
    @number = @@number_of_moves
  end

  def to_s
    "Hand #{BLUE}#{number}#{RESET})\n" \
    "#{MAGENTA}#{human_name}#{RESET}: #{human_move}\n" \
    "#{RED}#{computer_name}#{RESET}: #{computer_move}\n\n"
  end
end

class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

  RULES = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['rock', 'scissors']
  }

  def initialize(value)
    @value = value
  end

  def >(other)
    RULES[@value].any? { |losing_move| other.value == losing_move }
  end

  def <(other)
    RULES[other.value].any? { |losing_move| @value == losing_move }
  end

  def to_s
    value
  end
end

class Player
  attr_accessor :name, :move, :score

  def initialize(log)
    @log = log
    self.score = 0
  end

  def make_move(value)
    case value
    when 'rock'     then Rock.new
    when 'paper'    then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard'   then Lizard.new
    when 'spock'    then Spock.new
    end
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      print "Please enter your name: "
      n = gets.chomp.strip
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def options
    option_values = Move::VALUES
    option_string = option_values[0..-2].join(', ')
    option_string << ', or ' << option_values.last
  end

  def choose
    choice = nil
    loop do
      puts "Please choose #{options}:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      log_check(choice)
    end
    self.move = Move.new(choice)
  end

  private

  attr_reader :log

  def log_check(answer)
    if answer == 'log'
      log.display
    else
      puts "Sorry, invalid choice."
    end
  end
end

class Computer < Player
  NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].freeze

  HAL_LIST = [
    'scissors', 'scissors', 'scissors', 'scissors',
    'rock', 'lizard', 'lizard', 'spock', 'spock'
  ].freeze

  CHAPPIE_LIST = (Array.new(3, 'lizard') + Move::VALUES).freeze

  SONNY_LIST = (Array.new(48, 'spock') + ['rock', 'scissors']).freeze

  def initialize(log)
    super
    set_name
  end

  def set_name
    self.name = NAMES.sample
  end

  def computer_choice
    case name
    when 'R2D2'     then Move.new('rock')
    when 'Hal'      then Move.new(HAL_LIST.sample)
    when 'Chappie'  then Move.new(CHAPPIE_LIST.sample)
    when 'Sonny'    then Move.new(SONNY_LIST.sample)
    when 'Number 5' then Move.new(Move::VALUES.sample)
    end
  end

  def choose
    self.move = computer_choice
  end
end

class RPSGame
  include Displayable::RPSGame
  include Pageable

  WINNING_SCORE = 2

  def initialize
    @log = Log.new
    @human = Human.new(log)
    @computer = Computer.new(log)
  end

  def play
    display_banner
    introductions
    loop do
      initialize_scores
      play_round until winner?
      display_banner
      display_overall_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer, :rounds_played
  attr_reader :log

  def introductions
    human.set_name
    puts "Hi #{MAGENTA}#{human.name}#{RESET}! " \
         "Your opponent today will be #{RED}#{computer.name}#{RESET}"
    rules_check
  end

  def rules_check
    puts "Would you like to see the rules (y / n)?"
    answer = nil
    loop do
      answer = gets.chomp.downcase.strip
      break if ['y', 'n'].include?(answer)
      puts "Invalid choice. Please answer y or n."
    end
    display_rules if answer == 'y'
  end

  def display_rules
    page(["This is a placeholder for the rules"])
  end

  def play_round
    self.rounds_played += 1
    display_banner
    puts
    puts "#{GREEN}Round #{rounds_played}#{RESET}"
    human.choose
    computer.choose
    record_moves
    display_moves
    display_round_winner
    sleep 1.5
    tally_scores
  end

  def record_moves
    log << LogEvent.new(human.name, human.move, computer.name, computer.move)
  end

  def tally_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def initialize_scores
    self.rounds_played = 0
    human.score = 0
    computer.score = 0
  end

  def winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def log_check(answer)
    if answer == 'log'
      log.display
    else
      puts "Sorry, must be y or n."
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      log_check(answer)
    end

    answer == 'y'
  end
end

# Start game
RPSGame.new.play
