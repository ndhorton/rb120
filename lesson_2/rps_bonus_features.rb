# Rock Paper Scissors - Bonus features

class Log
  def initialize
    @events = []
  end

  def <<(log_event)
    events << log_event
  end

  def display
    if events.empty?
      puts "No moves have been made yet.\n"
    else
      display_details
    end
    puts "Press <enter> to return"
    gets
  end

  private

  attr_reader :events

  def display_details
    puts "\nAll rounds played so far this session:"
    events.each do |event|
      puts "#{event.number}\n" \
           "#{event.human_name}: #{event.human_move}\n" \
           "#{event.computer_name}: #{event.computer_move}\n\n"
    end
  end
end

class LogEvent
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
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

  protected

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    super
    @value = 'rock'
  end

  def >(other_move)
    other_move.scissors? || other_move.lizard?
  end

  def <(other_move)
    other_move.paper? || other_move.spock?
  end
end

class Paper < Move
  def initialize
    super
    @value = 'paper'
  end

  def >(other_move)
    other_move.rock? || other_move.spock?
  end

  def <(other_move)
    other_move.scissors? || other_move.spock?
  end
end

class Scissors < Move
  def initialize
    super
    @value = 'scissors'
  end

  def >(other_move)
    other_move.paper? || other_move.lizard?
  end

  def <(other_move)
    other_move.rock? || other_move.spock?
  end
end

class Lizard < Move
  def initialize
    super
    @value = 'lizard'
  end

  def >(other_move)
    other_move.paper? || other_move.spock?
  end

  def <(other_move)
    other_move.rock? || other_move.scissors?
  end
end

class Spock < Move
  def initialize
    super
    @value = 'spock'
  end

  def >(other_move)
    other_move.rock? || other_move.scissors?
  end

  def <(other_move)
    other_move.paper? || other_move.lizard?
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize(log)
    @log = log
    self.score = 0
    set_name
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
      puts "What's your name?"
      n = gets.chomp
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
    self.move = make_move(choice)
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

  def set_name
    self.name = NAMES.sample
  end

  def computer_choice
    case name
    when 'R2D2'     then Rock.new
    when 'Hal'      then make_move(HAL_LIST.sample)
    when 'Chappie'  then make_move(CHAPPIE_LIST.sample)
    when 'Sonny'    then make_move(SONNY_LIST.sample)
    when 'Number 5' then make_move(Move::VALUES.sample)
    end
  end

  def choose
    self.move = computer_choice
  end
end

class Round
  def initialize(human, computer, log)
    @log = log
    @human = human
    @computer = computer
  end

  def play
    human.choose
    computer.choose
    log << LogEvent.new(human.name, human.move, computer.name, computer.move)
    display_moves
    display_winner
    tally_scores
  end

  private

  attr_accessor :human, :computer
  attr_reader :log

  def tally_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    puts
  end
end

# Orchestration Engine class
class RPSGame
  def initialize
    @log = Log.new
    @human = Human.new(log)
    @computer = Computer.new(log)
  end

  def play
    display_welcome_message
    loop do
      initialize_scores
      play_rounds
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer, :rounds_played
  attr_reader :log

  WINNING_SCORE = 10

  def display_welcome_message
    name_of_game = Move::VALUES.map(&:capitalize).join(', ')
    system('clear')
    puts "Hi #{human.name}! Welcome to #{name_of_game}!"
    puts "(Enter 'log' at any time to view the log of moves)"
    puts
  end

  def display_goodbye_message
    name_of_game = Move::VALUES.map(&:capitalize).join(', ')
    puts "Thanks for playing #{name_of_game}. Good bye!"
  end

  def display_winner
    winner = (human.score > computer.score ? human : computer)
    puts "At the end of #{rounds_played} rounds,\n" \
         "#{human.name} has won #{human.score} rounds,\n" \
         "#{computer.name} has won #{computer.score} rounds,\n" \
         "#{winner.name} is the winner!"
  end

  def play_rounds
    loop do
      self.rounds_played += 1
      puts "Round #{rounds_played}"
      Round.new(human, computer, log).play
      break if winner?
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
