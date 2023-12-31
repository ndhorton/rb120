# Rock Paper Scissors - Lizard, Spock

class Player
  attr_accessor :move, :name, :score

  def initialize
    self.score = 0
    set_name
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
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  ROCK_RULE = {
    'scissors' => true,
    'lizard' => true
  }
  ROCK_RULE.default = false

  PAPER_RULE = {
    'rock' => true,
    'spock' => true
  }
  PAPER_RULE.default = false

  SCISSORS_RULE = {
    'paper' => true,
    'lizard' => true
  }
  SCISSORS_RULE.default = false

  LIZARD_RULE = {
    'spock' => true,
    'paper' => true
  }
  LIZARD_RULE.default = false

  SPOCK_RULE = {
    'rock' => true,
    'scissors' => true
  }
  SPOCK_RULE.default = false

  def initialize(value)
    @value = value
  end

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

  def >(other_move)
    other_value = other_move.value
    if rock?        then ROCK_RULE[other_value]
    elsif paper?    then PAPER_RULE[other_value]
    elsif scissors? then SCISSORS_RULE[other_value]
    elsif lizard?   then LIZARD_RULE[other_value]
    elsif spock?    then SPOCK_RULE[other_value]
    end
  end

  def <(other_move)
    if other_move.rock?        then ROCK_RULE[value]
    elsif other_move.paper?    then PAPER_RULE[value]
    elsif other_move.scissors? then SCISSORS_RULE[value]
    elsif other_move.lizard?   then LIZARD_RULE[value]
    elsif other_move.spock?    then SPOCK_RULE[value]
    end
  end

  def to_s
    @value
  end
end

class Round
  attr_accessor :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
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

  def play
    human.choose
    computer.choose
    display_moves
    display_winner
    tally_scores
  end

  def tally_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end
end

# Orchestration Engine class
class RPSGame
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

  WINNING_SCORE = 3

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    name_of_game = Move::VALUES.map(&:capitalize).join(', ')
    system('clear')
    puts "Hi #{human.name}! Welcome to #{name_of_game}!"
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
      Round.new(human, computer).play
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

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end
end

RPSGame.new.play
