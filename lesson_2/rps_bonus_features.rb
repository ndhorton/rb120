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
  def display_history
    puts "display history"
  end

  def display_rules
    rules_lines = TEXT['rules'].split("\n")
    page(rules_lines)
  end

  def page(text)
    start_y = 0
    max_y = page_length
    input = nil
    loop do
      $stdout.clear_screen
      display_banner
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
    max_y - 7
  end

  def display_lines(start_y, max_y, text)
    print YELLOW
    puts text[start_y..max_y]
    print RESET
  end

  def display_appropriate_footer(max_y, text_size)
    colors = {cyan: CYAN, reset: RESET}
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

  def display_countdown
    # print "3"
    # ellipsis
    # print "2"
    # ellipsis
    # print "1"
    # ellipsis
    # puts TEXT['countdown']
    # sleep 1
  end

  def ellipsis
    3.times do
      print "."
      sleep 0.5
    end
    print " "
  end

  def display_round
    puts "#{CYAN}#{TEXT['round']}#{log.rounds}#{RESET}"
  end

  # RPSGame methods
  def display_round_winner
  end

  def display_winner
  end
end

module Promptable
  private

  def prompt_for_rules
    puts TEXT['rules_prompt']
    answer = get_rules_answer
    if answer.start_with?(TEXT['affirmative'])
      display_rules
      display_banner
    else
      puts
    end
  end

  def get_rules_answer
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
end

class Log
  attr_accessor :history, :rounds

  def initialize
    @history = [] # Array for LogEvents
    @rounds = 0
    @total_hands_played = 0
  end
end

class LogEvent
end

class Player
  attr_reader :name, :move

  private

  attr_writer :name, :move
end

class Human < Player
  include Displayable
  include Promptable

  def initialize(log)
    @log = log
    set_name
  end

  def choose
    loop do
      choice = prompt_for_choice
      if choice == TEXT['history']
        display_history
        revert_display
      elsif choice == TEXT['help']
        display_rules
        revert_display
      else
        self.move = Move.new(expand_choice(choice))
        break
      end
    end
  end

  private

  attr_reader :log

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

  def revert_display
    display_banner
    display_round
  end

  def expand_choice(choice)
    TEXT['move_abbreviations'][choice]
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
    when 0...20   then TEXT['rock']
    when 20...40  then TEXT['paper']
    when 40...60  then TEXT['scissors']
    when 60...80  then TEXT['lizard']
    when 80...100 then TEXT['spock']
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
   when 0...20   then TEXT['rock']
   when 20...40  then TEXT['paper']
   when 40...60  then TEXT['scissors']
   when 60...80  then TEXT['lizard']
   when 80...100 then TEXT['spock']
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
   when 0...20   then TEXT['rock']
   when 20...40  then TEXT['paper']
   when 40...60  then TEXT['scissors']
   when 60...80  then TEXT['lizard']
   when 80...100 then TEXT['spock']
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
   when 0...20   then TEXT['rock']
   when 20...40  then TEXT['paper']
   when 40...60  then TEXT['scissors']
   when 60...80  then TEXT['lizard']
   when 80...100 then TEXT['spock']
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

  def initialize
    self.log = Log.new
    self.computer = set_computer_player
  end

  def play
    setup
    loop do
      reset_scores
      display_banner
      play_round until winner?
      display_winner
      break unless play_again?
    end
    goodbye
  end

  private

  attr_accessor :human, :computer, :log, :winning_points

  def setup
    display_banner
    puts TEXT['welcome']
    self.human = Human.new(log)
    make_introductions
    prompt_for_rules
    prompt_for_winning_points
    display_countdown
  end

  def play_round
    log.rounds += 1
    display_round
    human.choose
    computer.choose
    log_moves
    display_round_winner
    update_scores
  end

  def reset_scores
    log.rounds = 0
  end

  def winner?
  end

  def play_again?
  end

  def goodbye
  end

  def set_computer_player
    random_number = rand(100)
    case random_number
    when 0...20   then R2D2.new
    when 20...40  then Hal.new
    when 40...60  then Sonny.new
    when 60...80  then Chappie.new
    when 80...100 then Number5.new
    end
  end

  def make_introductions
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
    log.add_event(human.name, human.move, computer.name, computer.move)
  end

  def update_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end
end

RPSGame.new.play
