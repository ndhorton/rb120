require 'psych'
require 'io/console'

# Load English language text from YAML file
TEXT_DATA = Psych.load_file("#{__dir__}/rps_bonus_features.yml")
TEXT = TEXT_DATA['english']

# Terminal Colors
BLACK = "\e[30m"
RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
BLUE = "\e[34m"
MAGENTA = "\e[35m"
CYAN = "\e[36m"
WHITE = "\e[37m"
RESET = "\e[0m"

module Displayable
  private

  # Common methods
  def display_appropriate_footer(max_y, text_size)
    colors = { cyan: CYAN, reset: RESET }
    puts
    if max_y < text_size - 1
      print format(TEXT['pager_scroll'], colors)
    else
      print format(TEXT['pager_return'], colors)
    end
  end

  def display_banner
    $stdout.clear_screen
    puts format(TEXT['banner'],
                { blue: BLUE, yellow: YELLOW, reset: RESET })
  end

  def display_history
    log.display
  end

  def display_lines(start_y, max_y, lines)
    print YELLOW
    puts lines[start_y..max_y]
    print RESET
  end

  def display_round
    puts "#{CYAN}#{TEXT['round']}#{log.round}#{RESET}"
  end

  def display_rules
    rules_lines = TEXT['rules'].split("\n")
    page(rules_lines)
  end

  # RPSGame methods
  def game_winner_data
    { rounds_played: log.round, human_color: GREEN, human_player: human.name,
      human_score: human.score, computer_color: RED,
      computer_player: computer.name, computer_score: computer.score,
      reset: RESET }
  end

  def game_winner_with_color
    if human.score > computer.score
      "#{GREEN}#{human.name}#{RESET}"
    else
      "#{RED}#{computer.name}#{RESET}"
    end
  end

  def display_round_winner
    human_move = human.move
    computer_move = computer.move
    puts "\n#{GREEN}#{human.name}#{RESET}#{TEXT['chose']}#{human_move}\n" \
         "#{RED}#{computer.name}#{RESET}#{TEXT['chose']}#{computer_move}\n"

    if human_move == computer_move
      puts TEXT['tie']
    else
      puts "#{round_winner_with_color}#{TEXT['is_winner']}\n\n"
    end
  end

  def display_winner
    puts format(TEXT['preamble_winner'], game_winner_data)
    puts "#{game_winner_with_color}#{TEXT['is_winner']}"
  end

  def round_winner_with_color
    if human.move > computer.move
      "#{GREEN}#{human.name}#{RESET}"
    else
      "#{RED}#{computer.name}#{RESET}"
    end
  end
end

module Promptable
  private

  def prompt_for_choice
    choice = nil
    puts TEXT['move_prompt']
    loop do
      choice = gets.chomp.strip.downcase
      break if TEXT['move_choices'].include?(choice)
      puts TEXT['invalid_move']
    end
    choice
  end

  def prompt_for_play_again
    puts TEXT['play_again']
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if TEXT['yes_or_no_help_log'].include?(answer)
      puts TEXT['invalid_choice']
    end
    answer
  end

  def prompt_for_rules
    puts TEXT['rules_prompt']
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if TEXT['yes_or_no'].include?(answer)
      puts TEXT['invalid_choice']
    end
    answer
  end

  def prompt_for_winning_points
    points = nil
    puts TEXT['winning_points']
    loop do
      points = gets.chomp.strip.to_i
      break if (1..10).cover?(points)
      puts TEXT['invalid_points']
    end
    self.winning_points = points
  end
end

module Pageable
  private

  def page(lines)
    paging_loop(0, page_length, lines)
    $stdout.clear_screen
  end

  def page_content(start_y, max_y, lines)
    $stdout.clear_screen
    display_banner
    display_lines(start_y, max_y, lines)
    display_appropriate_footer(max_y, lines.size)
  end

  def page_length
    max_y, = $stdout.winsize # current size of terminal; only need rows/y axis
    max_y - 7 # subtract 7 to accomodate header and footer
  end

  def paging_loop(start_y, max_y, lines)
    loop do
      page_content(start_y, max_y, lines)
      input = $stdin.getch
      if input == ' ' && max_y < lines.size - 1
        start_y += 1
        max_y += 1
      elsif input == TEXT['quit']
        break
      end
    end
  end
end

class Log
  include Pageable
  include Displayable

  attr_accessor :round, :game

  @@event_number = 0

  def initialize
    @history = [] # array of LogEvents
    @game = 0
    @rounds = 0
    @total_hands_played = 0
  end

  def add_event(human, computer)
    @@event_number += 1
    history << LogEvent.new(human, computer, @@event_number, @round, @game)
  end

  def display
    if history.empty?
      puts "No moves have been made yet.\n\n"
    else
      page(event_lines)
    end
  end

  private

  attr_accessor :history

  def event_lines
    text = history.reverse.join
    text.split("\n")
  end
end

class LogEvent
  attr_reader(:human_name, :human_move, :computer_name, :computer_move,
              :event_number, :round, :game)

  def initialize(human, computer, event_number, round, game)
    @human_name = human.name
    @human_move = human.move
    @computer_name = computer.name
    @computer_move = computer.move
    @event_number = event_number
    @round = round
    @game = game
  end

  def to_s
    "#{BLUE}Game #{game}#{RESET}, #{CYAN}Round #{round}#{RESET}\n" \
      "#{GREEN}#{human_name}#{RESET}: #{human_move}\n" \
      "#{RED}#{computer_name}#{RESET}: #{computer_move}\n\n"
  end
end

class Player
  attr_reader :name, :move
  attr_accessor :score

  private

  attr_writer :name, :move
end

class Human < Player
  include Displayable
  include Promptable
  include Pageable

  def initialize(log)
    @log = log
    set_name
  end

  def choose
    loop do
      choice = prompt_for_choice
      case choice
      when TEXT['history'] then handle_history
      when TEXT['help']    then handle_rules
      else
        self.move = Move.new(expand_choice(choice))
        break
      end
    end
  end

  private

  attr_reader :log

  def expand_choice(choice)
    TEXT['move_abbreviations'][choice]
  end

  def handle_history
    display_history
    revert_display
  end

  def handle_rules
    display_rules
    revert_display
  end

  def revert_display
    display_banner
    display_round
  end

  def set_name
    n = ""
    loop do
      puts TEXT['name']
      n = gets.chomp.strip
      break unless n.empty?
      puts TEXT['invalid_name']
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    self.move = Move.new(robot_choice)
  end
end

class R2D2 < Computer
  def initialize
    self.name = 'R2D2'
  end

  private

  def robot_choice
    random_number = rand(100)
    case random_number
    when 0...99   then TEXT['rock']
    when 99       then TEXT['spock']
    end
  end
end

class Hal < Computer
  def initialize
    self.name = 'Hal'
  end

  private

  def robot_choice
    random_number = rand(100)
    case random_number
    when 0...20   then TEXT['rock']
    when 20...40  then TEXT['paper']
    when 40...60  then TEXT['scissors']
    when 60...80  then TEXT['lizard']
    when 80...100 then TEXT['spock']
    end
  end
end

class Sonny < Computer
  def initialize
    self.name = 'Sonny'
  end

  private

  def robot_choice
    random_number = rand(100)
    case random_number
    when 0...12   then TEXT['rock']
    when 12...25  then TEXT['paper']
    when 25...37  then TEXT['scissors']
    when 37...50  then TEXT['lizard']
    when 50...100 then TEXT['spock']
    end
  end
end

class Chappie < Computer
  def initialize
    self.name = 'Chappie'
  end

  private

  def robot_choice
    random_number = rand(100)
    case random_number
    when 0...15   then TEXT['rock']
    when 15...35  then TEXT['paper']
    when 35...50  then TEXT['scissors']
    when 50...85  then TEXT['lizard']
    when 85...100 then TEXT['spock']
    end
  end
end

class Number5 < Computer
  def initialize
    self.name = 'Number 5'
  end

  private

  def robot_choice
    random_number = rand(100)
    case random_number
    when 0...25   then TEXT['rock']
    when 25...35  then TEXT['paper']
    when 35...60  then TEXT['scissors']
    when 60...85  then TEXT['lizard']
    when 85...100 then TEXT['spock']
    end
  end
end

class Move
  attr_reader :value

  def initialize(v)
    @value = v
  end

  def >(other)
    rules(@value).any? { |losing_move| other.value == losing_move }
  end

  def <(other)
    rules(other.value).any? { |losing_move| @value == losing_move }
  end

  def ==(other)
    value == other.value
  end

  def to_s
    value
  end

  private

  def rules(value)
    TEXT['move_rules'][value]
  end
end

class RPSGame
  include Displayable
  include Promptable
  include Pageable

  def initialize
    self.log = Log.new
    self.computer = select_computer_player
  end

  def play
    setup
    loop do
      log.game += 1
      play_all_rounds
      break unless play_again?
    end
    goodbye
  end

  private

  attr_accessor :human, :computer, :log, :winning_points

  def goodbye
    $stdout.clear_screen
    puts TEXT['goodbye']
  end

  def introduce_opponent
    puts
    puts format(TEXT['opponent'], {
                  human_color: GREEN,
                  computer_color: RED,
                  reset: RESET,
                  human_name: human.name,
                  computer_player: computer.name
                })
  end

  def log_moves
    log.add_event(human, computer)
  end

  def play_again?
    loop do
      answer = prompt_for_play_again
      case answer
      when 'history' then display_history
      when 'help'    then display_rules
      else
        return answer.start_with?(TEXT['affirmative'])
      end
    end
  end

  def play_all_rounds
    reset_scores
    display_banner
    play_round until winner?
    display_winner
  end

  def play_round
    log.round += 1
    display_round
    human.choose
    computer.choose
    log_moves
    display_round_winner
    update_scores
  end

  def reset_scores
    log.round = 0
    human.score = 0
    computer.score = 0
  end

  def rules_check
    answer = prompt_for_rules
    if answer.start_with?(TEXT['affirmative'])
      display_rules
      display_banner
    else
      puts
    end
  end

  def select_computer_player
    random_number = rand(100)
    case random_number
    when 0...20   then R2D2.new
    when 20...40  then Hal.new
    when 40...60  then Sonny.new
    when 60...80  then Chappie.new
    when 80...100 then Number5.new
    end
  end

  def setup
    display_banner
    puts TEXT['welcome']
    self.human = Human.new(log)
    introduce_opponent
    rules_check
    prompt_for_winning_points
  end

  def update_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def winner?
    (human.score >= winning_points) ||
      (computer.score >= winning_points)
  end
end

RPSGame.new.play
