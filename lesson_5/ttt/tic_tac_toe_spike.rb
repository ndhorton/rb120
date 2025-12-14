# TODO: perhaps for 3) you could have three difiiculty levels, each with a
# different computer opponent
# easy (random choice) could be a basic robot called... ?
# medium: the offensive/defensive one-move-ahead from RB101
# hard: the minimax algorithm

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  OPPOSITE_MARKER = {
    'X' => 'O',
    'O' => 'X'
  }

  def initialize
    @squares = {}
    reset
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # Ok to disable these cops since this is a simple display method -- reducing
  # the number of method calls will only make the code less legible
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
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def full?
    unmarked_keys.empty?
  end

  def middle_square_open?
    @squares[5].unmarked?
  end

  def open_square(marker)
    WINNING_LINES.each do |line|
      markers = @squares.values_at(*line).map(&:marker)
      if markers.count(marker) == 2 &&
         markers.count(OPPOSITE_MARKER[marker]) == 0
        empty_index = markers.index { |sq| sq != marker }
        return line[empty_index]
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def someone_won?
    !!winning_marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :name
end

class TTTGame
  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    computer.name = ['R2D2', 'Roy', 'Hal'].sample
    @scores = {
      human: 0,
      computer: 0
    }
  end

  def play
    clear
    display_welcome_message
    ask_player_for_name
    determine_player_order
    main_game
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer

  def ask_player_for_name
    name = ''
    puts "Please enter your name:"
    loop do
      name = gets.chomp.strip
      break unless name.empty?
    end
    human.name = name
  end

  def determine_player_order
    set_who_goes_first
    set_player_marker
  end

  def set_player_marker
    answer = prompt_for_player_marker
    case answer
    when 'X'
      human.marker = 'X'
      computer.marker = 'O'
    when 'O'
      human.marker = 'O'
      computer.marker = 'X'
    end
  end

  def clear
    system('clear')
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def immediate_win?
    !!(board.open_square(computer.marker))
  end

  def immediate_threat?
    !!(board.open_square(human.marker))
  end

  def computer_moves
    if immediate_win?
      board[board.open_square(computer.marker)] = computer.marker
    elsif immediate_threat?
      board[board.open_square(human.marker)] = computer.marker
    elsif board.middle_square_open?
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_player = computer
    else
      computer_moves
      @current_player = human
    end
  end

  def display_board
    puts "#{human.name} is #{human.marker}. " \
         "#{computer.name} is #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_play_again_message
    clear
    puts "Let's play again!"
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

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def human_turn?
    @current_player == human
  end

  def joinor(array, delimiter = ', ', conjunction = 'or')
    case array.size
    when 0 then ""
    when 1 then array.first.to_s
    when 2 then "#{array.first} #{conjunction} #{array.last}"
    else
      main_list = array[0..-2].join(delimiter)
      "#{main_list}#{delimiter}#{conjunction} #{array.last}"
    end
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      update_scores
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
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

  def reset
    board.reset
    determine_player_order
  end

  def prompt_for_computer_chooses
    puts "Would you like the computer to choose who goes first (y or n)?"
    answer = ''
    loop do
      answer = gets.chomp.strip.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n"
    end
    answer
  end

  def prompt_for_player_marker
    puts "Would you like your marker to be 'X' or 'O'?"
    answer = ''
    loop do
      answer = gets.chomp.strip.upcase
      break if ['X', 'O'].include?(answer)
      puts "Sorry, must be 'X' or 'O'"
    end
    answer
  end

  def prompt_for_who_goes_first
    puts "Would you like to go first (y or n)?"
    answer = ''
    loop do
      answer = gets.chomp.strip.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n"
    end
    answer
  end

  def set_who_goes_first
    if prompt_for_computer_chooses == 'y'
      @current_player = [human, computer].sample
      return
    end
    if prompt_for_who_goes_first == 'y'
      @current_player = human
    else
      @current_player = computer
    end
  end

  def update_scores
    case board.winning_marker
    when human.marker    then @scores[:human] += 1
    when computer.marker then @scores[:computer] += 1
    end
  end
end

game = TTTGame.new
game.play
