require 'io/console'
require 'psych'

FG_BLACK = "\e[30m"
BG_WHITE = "\e[47m"
RESET = "\e[0m"

TEXT = Psych.load_file("#{__dir__}/ttt_bonus_features.yml")['english']

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :initial_marker
  attr_accessor :human_marker, :computer_marker, :active_turn

  def initialize
    @initial_marker = Square::INITIAL_MARKER
    @squares = {}
    reset_squares
  end

  def [](key)
    @squares[key]
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def computer_turn?
    active_turn == :computer
  end

  def computer_won?
    winning_marker == computer_marker
  end

  def empty_squares
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def end_state?
    someone_won? || full?
  end

  def full?
    empty_squares.empty?
  end

  def human_turn?
    active_turn == :human
  end

  def human_won?
    winning_marker == human_marker
  end

  def middle_square_open?
    @squares[5].unmarked?
  end

  def open_square(marker)
    WINNING_LINES.each do |line|
      markers = @squares.values_at(*line).map(&:marker)
      if markers.count(marker) == 2 &&
         markers.count(initial_marker) == 1
        empty_index = markers.index { |sq| sq != marker }
        return line[empty_index]
      end
    end
    nil
  end

  def someone_won?
    !!(winning_marker)
  end

  def tie?
    full? && !someone_won?
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

  def reset_squares
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Cursor
  SQUARE_POSITIONS = {
    1 => [3, 4], 2 => [9, 4], 3 => [15, 4], 4 => [3, 8], 5 => [9, 8],
    6 => [15, 8], 7 => [3, 12], 8 => [9, 12], 9 => [15, 12]
  }

  attr_accessor :x, :y

  def initialize
    reset
  end

  def down
    @y += 4 unless @y == 12
  end

  def up
    @y -= 4 unless @y == 4
  end

  def left
    @x -= 6 unless @x == 3
  end

  def right
    @x += 6 unless @x == 15
  end

  def reset
    @x, @y = SQUARE_POSITIONS[5]
  end

  def square
    SQUARE_POSITIONS.key([x, y])
  end
end

class Player
  attr_reader :name
  attr_accessor :marker
end

class Human < Player
  attr_writer :name
end

class R2D2 < Player
  def initialize
    @name = 'R2D2'
  end

  def choose(board)
    board.empty_squares.sample
  end
end

class Sonny < Player
  def initialize
    @name = 'Sonny'
  end

  def choose(board)
    computer_marker = board.computer_marker
    human_marker = board.human_marker
    immediate_win = board.open_square(computer_marker)
    immediate_threat = board.open_square(human_marker)
    if immediate_win                then immediate_win
    elsif immediate_threat          then immediate_threat
    elsif board.middle_square_open? then 5
    else
      board.empty_squares.sample
    end
  end
end

class Hal < Player
  def initialize
    @name = 'Hal'
    @choice = nil
  end

  def choose(board)
    minimax(board)
    @choice
  end

  private

  def appropriate_marker(board)
    if board.computer_turn?
      board.computer_marker
    else
      board.human_marker
    end
  end

  def change_board_state!(board, square)
    board[square] = appropriate_marker(board)
    reverse_active_turn!(board)
  end

  def min_or_max(board, squares, scores)
    if board.computer_turn?
      max_score_index = scores.each_with_index.to_a.max.last
      @choice = squares[max_score_index]
      scores[max_score_index]
    else
      min_score_index = scores.each_with_index.min.last
      @choice = squares[min_score_index]
      scores[min_score_index]
    end
  end

  def minimax(board, depth = 0)
    return score(board, depth) if board.end_state?

    scores = []
    squares = board.empty_squares.each do |square|
      change_board_state!(board, square)
      scores << minimax(board, depth + 1)
      revert_board_state!(board, square)
    end

    min_or_max(board, squares, scores)
  end

  def reverse_active_turn!(board)
    computer_active = board.computer_turn?
    board.active_turn = (computer_active ? :human : :computer)
  end

  def revert_board_state!(board, square)
    board[square] = board.initial_marker
    reverse_active_turn!(board)
  end

  def score(board, depth)
    if board.computer_won?
      10 - depth
    elsif board.human_won?
      depth - 10
    else
      0
    end
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

class UserInterface
  BOARD_SKELETON = TEXT['board_skeleton'].join.freeze

  attr_accessor :x, :y

  def initialize
    @x = 1
    @y = 1
    @cursor = Cursor.new
  end

  def announce_opponent(computer)
    puts "Your opponent today will be #{computer.name}"
  end

  def draw_board(human, computer, board, cursor: true)
    $stdout.clear_screen
    draw_header(human, computer, board)
    draw_skeleton
    draw_squares(board)
    draw_footer(board, computer)
    draw_cursor(board) if cursor
  end

  def goodbye
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def init_tui
    system('tput init')
    # system('tput civis')
    $stdout.clear_screen
  end

  def prompt_for_difficulty
    puts "Would you like an (e)asy, (m)edium, or (h)ard opponent?"
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if %w(e m h easy medium hard).include?(answer)
      puts "Sorry, must be (e)asy, (m)edium, or (h)ard"
    end
    answer[0]
  end

  def prompt_for_name
    puts "Please enter your name:"
    answer = nil
    loop do
      answer = gets.chomp.strip
      break unless answer.empty?
      puts "Sorry, name must be at least one character"
    end
    answer
  end

  def prompt_for_marker
    puts "Would you like to play as X or O?"
    answer = nil
    loop do
      answer = gets.chomp.strip.upcase
      break if ['X', 'O'].include?(answer)
      puts "Sorry, must be X or O"
    end
    answer
  end

  def prompt_for_play_again
    puts "Would you like to play again (y or n)?"
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      puts "Sorry, must be y or n"
    end
    answer[0]
  end

  def prompt_for_who_goes_first
    puts "Which player should go first, (h)uman or (c)omputer?"
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if %w(h c human computer).include?(answer)
      puts "Sorry, must be (h)uman or (c)omputer"
    end
    answer[0]
  end

  def read_input
    char = $stdin.getch

    return @cursor.square if char == ' '
    return :quit if char == 'q'

    move_cursor(char)
    nil
  end

  def display_scores(final_scores, human, computer)
    puts "At the end of play:"
    puts "\t#{human.name} won #{pluralize(final_scores[:human])},"
    puts "\t#{computer.name} won #{pluralize(final_scores[:computer])},"
    puts "\twith #{pluralize(final_scores[:tie])} tied."
  end

  def pluralize(number)
    if number == 1
      "#{number} game"
    else
      "#{number} games"
    end
  end

  def reset_cursor
    @cursor.x, @cursor.y = Cursor::SQUARE_POSITIONS[5]
  end

  def revert_terminal
    system('tput cnorm')
    $stdin.echo = true
    $stdout.clear_screen
  end

  def welcome
    $stdout.clear_screen
    puts "Welcome to Tic Tac Toe!"
  end

  private

  def draw_cursor(board)
    set_pos(@cursor.x, @cursor.y)
    print_char("#{FG_BLACK}#{BG_WHITE}#{board[@cursor.square]}#{RESET}")
    # move terminal cursor off the board in case `tput civis` failed
    set_pos(1, 17)
  end

  def draw_footer(board, computer)
    if board.human_turn? && !board.end_state?
      set_pos(1, 15)
      print_string "k/j - up/down, h/l - left/right, <space> to mark a square\n"
      print_string "q to quit\n"
    elsif !board.end_state?
      set_pos(1, 15)
      print_string "#{computer.name} is thinking..."
    else
      set_pos(1, 15)
    end
  end

  def draw_header(human, computer, board)
    set_pos(1, 1)
    print_string "#{human.name} is #{board.human_marker}. " \
                 "#{computer.name} is #{board.computer_marker}.\n\n"
  end

  def draw_skeleton
    set_pos(1, 3)
    print_string(BOARD_SKELETON)
  end

  def draw_squares(board)
    Cursor::SQUARE_POSITIONS.values.each_with_index do |(x, y), index|
      set_pos(x, y)
      print_char(board[index + 1])
    end
  end

  def move_cursor(char)
    case char.downcase
    when 'h' then @cursor.left
    when 'j' then @cursor.down
    when 'k' then @cursor.up
    when 'l' then @cursor.right
    end
  end

  def print_char(char)
    if char == "\n"
      print char
      @x = 1
      @y += 1
    elsif char != "\t"
      print char
      @x += 1
    end
  end

  def print_string(string)
    string.each_char { |char| print_char(char) }
  end

  def set_pos(x, y)
    print("\e[#{y};#{x}H")
    @x = x
    @y = y
  end
end

class TTTGame
  attr_reader :user_interface, :board, :quit, :human, :computer

  def initialize
    @user_interface = UserInterface.new
    @human = Human.new
    @board = Board.new
    @scores = {
      human: 0,
      computer: 0,
      tie: 0
    }
  end

  def play
    user_interface.welcome
    user_dependent_setup
    main_game
    show_scores
    user_interface.goodbye
  end

  private

  def computer_moves
    move = computer.choose(board)
    board[move] = board.computer_marker
    board.active_turn = :human
  end

  def game_over?
    board.full? || board.someone_won?
  end

  def human_moves
    move = user_interface.read_input
    @quit = true if move == :quit

    return unless board.empty_squares.include?(move)

    board[move] = board.human_marker
    user_interface.reset_cursor
    board.active_turn = :computer
  end

  def play_again?
    user_interface.draw_board(human, computer, board, cursor: false)
    answer = user_interface.prompt_for_play_again
    answer == 'y'
  end

  def play_game
    loop do
      show_board
      player_moves
      break if game_over? || quit
    end
  end

  def player_moves
    if board.human_turn?
      human_moves
    else
      computer_moves
    end
  end

  def main_game
    user_interface.init_tui
    loop do
      play_game
      break if quit
      update_scores
      break unless play_again?
      reset
    end
  ensure
    user_interface.revert_terminal
  end

  def reset
    board.reset_squares
    who_goes_first = @first_player
    if who_goes_first == :human
      @first_player = :computer
      board.active_turn = :computer
    else
      @first_player = :human
      board.active_turn = :human
    end
  end

  def set_difficulty_level
    difficulty = user_interface.prompt_for_difficulty
    @computer = case difficulty
                when 'e' then R2D2.new
                when 'm' then Sonny.new
                when 'h' then Hal.new
                end
    user_interface.announce_opponent(computer)
  end

  def set_player_markers
    marker = user_interface.prompt_for_marker
    if marker == 'X'
      board.human_marker = 'X'
      board.computer_marker = 'O'
    else
      board.human_marker = 'O'
      board.computer_marker = 'X'
    end
  end

  def set_human_name
    answer = user_interface.prompt_for_name
    human.name = answer
  end

  def set_who_goes_first
    answer = user_interface.prompt_for_who_goes_first
    @first_player = (answer == 'h' ? :human : :computer)
    board.active_turn = @first_player
  end

  def show_board
    if board.human_turn?
      user_interface.draw_board(human, computer, board)
    else
      user_interface.draw_board(human, computer, board, cursor: false)
    end
  end

  def show_scores
    user_interface.display_scores(@scores, human, computer)
  end

  def update_scores
    if board.human_won?
      @scores[:human] += 1
    elsif board.computer_won?
      @scores[:computer] += 1
    else
      @scores[:tie] += 1
    end
  end

  def user_dependent_setup
    set_human_name
    set_player_markers
    set_difficulty_level
    set_who_goes_first
  end
end

TTTGame.new.play
