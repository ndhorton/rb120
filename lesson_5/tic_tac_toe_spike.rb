# TODO: Lesson 5:4, Part 9: implement LS suggested solution for Board#winning_marker

require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

# TODO: Lesson 5:4, Part 9: implement LS suggested solution for this method

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      markers_in_line = @squares.values_at(*line).map(&:marker)
      first_marker = markers_in_line.first
      next if first_marker == Square::INITIAL_MARKER
      return first_marker if markers_in_line.count(first_marker) == 3
    end
    nil
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def clear
    system('clear')
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def display_result
    display_board
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def display_play_again_message
    clear
    puts "Let's play again!"
  end

  def reset
    board.reset
  end

  def play
    clear
    display_welcome_message
    loop do
      display_board
      loop do
        human_moves
        clear_screen_and_display_board

        break if board.someone_won? || board.full?

        computer_moves
        clear_screen_and_display_board

        break if board.someone_won? || board.full?
      end
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play

# board = Board.new
# board[1] = 'X'
# board[2] = 'X'
# board[3] = 'X'
# board.winning_marker

