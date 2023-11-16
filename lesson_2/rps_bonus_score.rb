# Rock Paper Scissors - Keep score

=begin
Keep score of who wins each round. A point is awarded for a win.
Whoever reaches 10 points first wins

round - should a round have a seperate class
        (pretty much the RPSGame class as is)?
score - should a score be a seperate class?

RPSGame
-play

game_winner?
display_game_winner

RPSGame class
Round class
how does Round communicate scores to RPSGame?

So the simplest way might be to add a second loop

    display_welcome_message

    loop do
      loop do
        play_round
        break if game_winner?
      end
      diplay_game_winner

      break unless play_again?
    end

    display_goodbye_message

So, I simply enlarged the engine class to include logic for
the rounds and seperate methods for the game
but I think it might be better to seperate out into Round class

Round

responsibilities:
must play round
must adjust scores for Human and Computer Players

collaborators:
Human
Computer

must pass in Human and Computer objects

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
  VALUES = ['rock', 'paper', 'scissors']

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

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
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

  WINNING_SCORE = 10

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
