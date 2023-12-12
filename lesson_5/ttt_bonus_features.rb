require 'io/console'
require 'psych'

FG_BLACK = "\e[30m"
BG_WHITE = "\e[47m"
BG_BLACK = "\e[40m"
RESET = "\e[0m"

TEXT = Psych.load_file("#{__dir__}/ttt_bonus_features.yml")['english']

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  SKELETON = TEXT['board_skeleton'].join.freeze

  attr_reader :computer_active, :first_move
  attr_accessor :human_marker, :computer_marker, :active_turn

  def initialize(comp_act = false)
    @computer_active = comp_act
    set_active_player
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
    human_won? || computer_won? || full?
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

  def new_state(square)
    state = Board.new(!computer_active)
    state.squares = @squares.map { |k, v| [k, v.dup] }.to_h
    state[square] = (human_turn? ? human_marker : computer_marker)
    state.human_marker = human_marker
    state.computer_marker = computer_marker
    state
  end

  def someone_won?
    !!(winning_marker)
  end

  def tie?
    full? && !(human_won?) && !(computer_won?)
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

  protected

  def squares=(squares)
    @squares = squares
  end

  private

  def reset_squares
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def set_active_player
    if computer_active
      @active_turn = :computer
    else
      @active_turn = :human
    end
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Cursor
  SQUARE_POSITIONS = {
    1 => [3, 2], 2 => [9, 2], 3 => [15, 2], 4 => [3, 6], 5 => [9, 6],
    6 => [15, 6], 7 => [3, 10], 8 => [9, 10], 9 => [15, 10]
  }

  attr_accessor :x, :y

  def initialize
    reset
  end

  def reset
    @x, @y = SQUARE_POSITIONS[5] # middle square position
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

  def choose_square(board)
    # board.active_turn = :human
    board.empty_squares.sample
  end
end

class Hal < Player
  def initialize
    @name = 'Hal'
  end

  def choose(board)
    # board.active_turn = :human
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

class Roy < Player
  def initialize
    @name = 'Roy'
    @choice = nil
  end

  def choose(board)
    minimax(board)
    # board.active_turn = :human
    @choice
  end

  private

  def minimax(board, depth = 1)
    return score(board, depth) if board.end_state?
    scores = []
    squares = []

    board.empty_squares.each do |square|
      possible_board = board.new_state(square)
      scores.push minimax(possible_board, depth + 1)
      squares.push square
    end

    if board.computer_turn?
      max_score_index = scores.each_with_index.to_a.max[1]
      @choice = squares[max_score_index]
      return scores[max_score_index]
    else
      min_score_index = scores.each_with_index.min[1]
      @choice = squares[min_score_index]
      return scores[min_score_index]
    end
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

  def initialize(m = INITIAL_MARKER)
    @marker = m
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
  attr_accessor :x, :y

  def initialize
    @x = 1
    @y = 1
    @cursor = Cursor.new
  end

  def draw_board(board)
    $stdout.clear_screen
    draw_skeleton
    draw_squares(board)
    draw_cursor(board)
  end

  def goodbye
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def human_choose(board)
    board.acitve_turn = :computer
    loop do
      draw_board(board_state)
      draw_cursor(board_state)
      choice = read_input
      return choice if choice
    end
  end

  def init_tui
    system('tput init')
    system('tput civis')
    $stdout.clear_screen
  end

  def prompt_for_difficulty
    puts "Would you like to play against an (e)asy, (m)edium, or (h)ard opponent?"
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if %w(e m h easy medium hard).include?(answer)
      puts "Sorry, must be (e)asy, (m)edium, or (h)ard"
    end
    answer[0]
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

  def read_input
    ch = $stdin.getch
    case ch.downcase
    when 'h' then @cursor.x -= 6 unless @cursor.x == 3
    when 'j' then @cursor.y += 4 unless @cursor.y == 10
    when 'k' then @cursor.y -= 4 unless @cursor.y == 2
    when 'l' then @cursor.x += 6 unless @cursor.x == 15
    when ' ' then return @cursor.square
    when 'q' then return :quit
    end
    nil
  end

  def revert_terminal
    system('tput cnorm')
    $stdin.echo = true
    $stdout.clear_screen
  end

  def welcome
    puts "Welcome to Tic Tac Toe!"
  end

  private

  def draw_cursor(board)
    set_pos(@cursor.x, @cursor.y)
    print_char("#{FG_BLACK}#{BG_WHITE}#{board[@cursor.square]}#{RESET}")
    # move terminal cursor off the board in case `tput civis` failed
    set_pos(1, 15)
  end

  def draw_skeleton
    set_pos(1, 1)
    print_string(Board::SKELETON)

    set_pos(1, 13)
    puts "k/j - up/down, h/l - left/right, <space> to mark a square"
    set_pos(1, 14)
    puts "q to quit at any time"
  end

  def draw_squares(board)
    Cursor::SQUARE_POSITIONS.values.each_with_index do |(x, y), index|
      set_pos(x, y)
      print_char(board[index + 1])
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
  attr_reader :user_interface, :board, :quit

  def initialize
    @user_interface = UserInterface.new
    @human = Human.new
    @board = Board.new
    scores = {
      human: 0,
      computer: 0,
      tie: 0
    }
  end

  def play
      user_interface.welcome
      user_dependent_setup
      main_game
      user_interface.goodbye
  end

  private

  def game_over?
    board.full? || board.someone_won?
  end

  def play_again?
  end

  def play_game
    loop do
      user_interface.draw_board(board)
      player_moves
      break if game_over? || quit
    end
  end

  def player_moves
    move = user_interface.read_input
    if move == :quit
      @quit = true
      return
    end
    board[move] = board.human_marker if (1..9).cover?(move)
  end

  def main_game
    begin
      user_interface.init_tui
      loop do
        play_game
        break unless play_again?
      end
    ensure
      user_interface.revert_terminal
    end
  end

  def set_difficulty_level
    difficulty = user_interface.prompt_for_difficulty
    @computer = case difficulty
                when 'e' then R2D2.new
                when 'm' then Hal.new
                when 'h' then Roy.new
                end
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

  def user_dependent_setup
    # get name
    set_player_markers
    # difficulty level
    set_difficulty_level
    # who goes first
  end
end

TTTGame.new.play
