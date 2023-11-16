# Rock Paper Scissors - Keep score

=begin
Make changes to Move class:
-add 'lizard' and 'spock' to values array
-add #lizard? and #spock? methods
-add rules
=end

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

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
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
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

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

  def beats_rock?
    @value == 'paper' || @value == 'spock'
  end

  def beats_paper?
    @value == 'scissors' || @value == 'lizard'
  end

  def beats_scissors?
    @value == 'rock' || @value == 'spock'
  end

  def beats_lizard?
    @value == 'rock' || @value = 'scissors'
  end

  def beats_spock?
    @value == 'paper' || @value = 'lizard'
  end

# TODO: reduce cyclomatic complexity if possible
  def >(other_move)
    (beats_rock? && other_move.rock?) ||
      (beats_paper? && other_move.paper?) ||
      (beats_scissors? && other_move.scissors?) ||
      (beats_lizard? && other_move.lizard?) ||
      (beats_spock? && other_move.spock?)
  end

  def <(other_move)
    (rock? && other_move.beats_rock?) ||
      (paper? && other_move.beats_paper?) ||
      (scissors? && other_move.beats_scissors?) ||
      (lizard? && other_move.beats_lizard?) ||
      (spock? && other_move.beats_spock?)
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
      rounds_loop
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer, :rounds_played

  WINNING_SCORE = 1

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_winner
    winner = (human.score > computer.score ? human : computer)
    puts "At the end of #{rounds_played} rounds,\n" \
         "#{human.name} has won #{human.score} rounds,\n" \
         "#{computer.name} has won #{computer.score} rounds,\n" \
         "#{winner.name} is the winner!"
  end

  def rounds_loop
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
