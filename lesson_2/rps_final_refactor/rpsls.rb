require 'psych'
require 'io/console'

# Load English language text from YAML file
TEXT = Psych.load_file("#{__dir__}/rpsls_text.yml")['english']
# Load arrays and hashes containing English language text
DATA = Psych.load_file("#{__dir__}/rpsls_data_structures.yml")['english']

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

module Promptable
  def prompt_for_choice
    choice = nil
    puts TEXT['move_prompt']
    loop do
      choice = gets.chomp.strip.downcase
      break if DATA['move_choices'].include?(choice)
      puts TEXT['invalid_move']
    end
    choice
  end

  def prompt_for_name
    name = ""
    loop do
      puts TEXT['name']
      name = gets.chomp.strip
      break unless name.empty?
      puts TEXT['invalid_name']
    end
    name
  end

  def prompt_for_play_again
    puts TEXT['play_again']
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if DATA['yes_or_no_help_log'].include?(answer)
      puts TEXT['invalid_choice']
    end
    answer
  end

  def prompt_for_rules
    puts TEXT['rules_prompt']
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if DATA['yes_or_no'].include?(answer)
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
    points
  end
end

module Pageable
  def display_rules
    rules_lines = TEXT['rules'].split("\n")
    page(rules_lines)
  end

  def page(lines)
    paging_loop(0, page_length, lines)
    $stdout.clear_screen
  end

  private

  def display_appropriate_footer(max_y, text_size)
    colors = { cyan: CYAN, reset: RESET }
    puts
    if max_y < text_size - 1
      print format(TEXT['pager_scroll'], colors)
    else
      print format(TEXT['pager_return'], colors)
    end
  end

  def display_lines(start_y, max_y, lines)
    print YELLOW
    puts lines[start_y..max_y]
    print RESET
  end

  def display_page(start_y, max_y, lines)
    $stdout.clear_screen
    display_banner
    display_lines(start_y, max_y, lines)
    display_appropriate_footer(max_y, lines.size)
  end

  def page_length
    max_y, = $stdout.winsize # current size of terminal; only need rows (y axis)
    max_y - 7 # subtract 7 to accomodate header and footer
  end

  def paging_loop(start_y, max_y, lines)
    loop do
      display_page(start_y, max_y, lines)
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

class UserInterface
  include Pageable
  include Promptable

  def initialize(log)
    @log = log
  end

  def display_banner
    $stdout.clear_screen
    puts format(TEXT['banner'],
                { blue: BLUE, yellow: YELLOW, reset: RESET })
  end

  def display_history
    if log.history.empty?
      $stdout.clear_screen
      display_banner
      puts TEXT['no_moves']
      print format(TEXT['pager_return'], { cyan: CYAN, reset: RESET })
      $stdin.getch
      $stdout.clear_screen
    else
      page(log.event_lines)
    end
  end

  def display_round
    puts "#{CYAN}#{TEXT['round']}#{log.round}#{RESET}"
  end

  def display_round_winner(human, computer)
    human_move = human.move
    computer_move = computer.move
    puts "\n#{GREEN}#{human.name}#{RESET}#{TEXT['chose']}#{human_move}\n" \
         "#{RED}#{computer.name}#{RESET}#{TEXT['chose']}#{computer_move}\n"

    if human_move == computer_move
      puts TEXT['tie']
    else
      puts "#{round_winner_with_color(human, computer)}#{TEXT['is_winner']}"
      puts
    end
  end

  def display_winner(human, computer)
    puts format(preamble_text, game_winner_data(human, computer))
    puts "#{game_winner_with_color(human, computer)}#{TEXT['is_winner']}"
  end

  def goodbye_message
    $stdout.clear_screen
    puts TEXT['goodbye']
  end

  def handle_history
    display_history
    revert_round_display
  end

  def handle_rules
    display_rules
    revert_round_display
  end

  def introduce_opponent(human, computer)
    puts
    puts format(TEXT['opponent'], {
                  human_color: GREEN,
                  computer_color: RED,
                  reset: RESET,
                  human_name: human.name,
                  computer_player: computer.name
                })
  end

  def welcome_message
    puts TEXT['welcome']
  end

  private

  attr_reader :log

  def game_winner_data(human, computer)
    { rounds_played: log.round, human_color: GREEN, human_player: human.name,
      human_score: human.score, computer_color: RED,
      computer_player: computer.name, computer_score: computer.score,
      reset: RESET }
  end

  def game_winner_with_color(human, computer)
    if human.score > computer.score
      "#{GREEN}#{human.name}#{RESET}"
    else
      "#{RED}#{computer.name}#{RESET}"
    end
  end

  def preamble_text
    if log.round == 1
      TEXT['preamble_winner_singular']
    else
      TEXT['preamble_winner_plural']
    end
  end

  def revert_round_display
    display_banner
    display_round
  end

  def round_winner_with_color(human, computer)
    if human.move > computer.move
      "#{GREEN}#{human.name}#{RESET}"
    else
      "#{RED}#{computer.name}#{RESET}"
    end
  end
end


class Log
  attr_accessor :round, :game
  attr_reader :history

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

  def event_lines
    text = history.reverse.join
    text.split("\n")
  end

  private

  attr_reader :user_interface
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
    "#{BLUE}#{TEXT['game_str']} #{game}#{RESET}, " \
      "#{CYAN}#{TEXT['round_str']} #{round}#{RESET}\n" \
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
  # rubocop:disable Lint/MissingSuper
  def initialize(user_interface)
    @user_interface = user_interface
    set_name
  end
  # rubocop:enable Lint/MissingSuper

  def choose
    loop do
      choice = user_interface.prompt_for_choice
      case choice
      when TEXT['history'] then user_interface.handle_history
      when TEXT['help']    then user_interface.handle_rules
      else
        self.move = Move.new(expand_choice(choice))
        break
      end
    end
  end

  private

  attr_reader :user_interface

  def expand_choice(choice)
    DATA['move_abbreviations'][choice]
  end

  def set_name
    self.name = user_interface.prompt_for_name
  end
end

class Computer < Player
  def choose
    self.move = Move.new(robot_choice)
  end
end

class R2D2 < Computer
  # rubocop:disable Lint/MissingSuper
  def initialize
    self.name = 'R2D2'
  end
  # rubocop:enable Lint/MissingSuper

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
  # rubocop:disable Lint/MissingSuper
  def initialize
    self.name = 'Hal'
  end
  # rubocop:enable Lint/MissingSuper

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
  # rubocop:disable Lint/MissingSuper
  def initialize
    self.name = 'Sonny'
  end
  # rubocop:enable Lint/MissingSuper

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
  # rubocop:disable Lint/MissingSuper
  def initialize
    self.name = 'Chappie'
  end
  # rubocop:enable Lint/MissingSuper

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
  # rubocop:disable Lint/MissingSuper
  def initialize
    self.name = 'Number 5'
  end
  # rubocop:enable Lint/MissingSuper

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
    DATA['move_rules'][value]
  end
end

class RPSGame
  def initialize
    @computer = select_computer_player
    @log = Log.new
    @user_interface = UserInterface.new(log)
  end

  def play
    setup
    loop do
      log.game += 1
      play_all_rounds
      break unless play_again?
    end
    user_interface.goodbye_message
  end

  private

  attr_accessor :human, :winning_points
  attr_reader :computer, :log, :user_interface

  def play_again?
    loop do
      answer = user_interface.prompt_for_play_again
      case answer
      when TEXT['history'] then user_interface.display_history
      when TEXT['help']    then user_interface.display_rules
      else
        return answer.start_with?(TEXT['affirmative'])
      end
    end
  end

  def play_all_rounds
    reset_scores
    user_interface.display_banner
    play_round until winner?
    user_interface.display_winner(human, computer)
  end

  def play_round
    log.round += 1
    user_interface.display_round
    human.choose
    computer.choose
    log.add_event(human, computer)
    user_interface.display_round_winner(human, computer)
    update_scores
  end

  def reset_scores
    log.round = 0
    human.score = 0
    computer.score = 0
  end

  def rules_check
    answer = user_interface.prompt_for_rules
    if answer.start_with?(TEXT['affirmative'])
      user_interface.display_rules
      user_interface.display_banner
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
    user_interface.display_banner
    user_interface.welcome_message
    self.human = Human.new(user_interface)
    user_interface.introduce_opponent(human, computer)
    rules_check
    self.winning_points = user_interface.prompt_for_winning_points
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
