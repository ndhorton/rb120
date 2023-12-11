require 'io/console'
require 'psych'

TEXT = Psych.load_file("#{__dir__}/ttt_bonus_features.yml")['english']

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :human_marker, :computer_marker, :active_turn

  def initialize
    @squares = {}
    reset_squares
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def computer_turn?
    active_turn == :computer
  end

  def computer_won?
  end

  def empty_squares
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def end_state?
  end

  def human_turn?
    acitve_turn == :human
  end

  def human_won?
  end

  def new_state(square)
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

  def reset_squares
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Cursor
  attr_accessor :x, :y

  def initialize
    reset
  end

  def reset
    @x, @y = UserInterface::SQUARE_POSITIONS[4] # middle square position
  end

  def square
    UserInterface::SQUARE_POSITIONS.index([x, y]) + 1 # index to key offset
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
    board.active_turn = :human
    board.empty_squares.sample
  endend

class Hal < Player
  def initialize
    @name = 'Hal'
  end

  def choose(board)
    board.active_turn = :human
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
    board.active_turn = :human
    @choice
  end

  private

  def minimax(board, depth = 1)
    return score(board, depth) if board.end_state?
    scores = []
    squares = []

    board.empty_squares.each do |square|
      possible_board = board.new_state(square)
      scores << minimax(possible_board, depth + 1)
      squares << square
    end

    if board.computer_turn?
      max_score_index = scores.each_with_index.to_a.max[1]
      @choice = squares[max_score_index]
      return scores[max_score_index]
    else
      min_score_index = scores.each_with_index.min[1]
      @computer_choice = squares[min_score_index]
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

class TTTGame
  def initialize
  end

  def play
  end

  private
end

class UserInterface
  SQUARE_POSITIONS = [
    [3, 2], [9, 2], [15, 2],
    [3, 6], [9, 6], [15, 6],
    [3, 10], [9, 10], [15, 10]
  ]

  attr_accessor :x, :y

  def initialize
    system('tput civis')
    $stdout.clear_screen
    @x = 1
    @y = 1
    @cursor = Cursor.new
  end

  def draw_board(board)
    $stdout.clear_screen
    draw_skeleton
    draw_squares(board)
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

  private

  def draw_cursor(board_state)
    set_pos(@cursor.x, @cursor.y)
    print_char("#{FG_BLACK}#{BG_WHITE}#{board_state[@cursor.square]}#{RESET}")
    set_pos(1, 15) # in case `tput civis` fails to hide console cursor 
  end

  def draw_skeleton
    set_pos(1, 1)
    print_string(Board::SKELETON)

    set_pos(1, 13)
    puts "k/j - up/down, h/l - left/right, <space> to mark a square"
    set_pos(1, 14)
    puts "q to quit at any time"
  end

  def draw_squares(board_state)
    SQUARE_POSITIONS.each_with_index do |(x, y), index|
      set_pos(x, y)
      print_char(board_state[index])
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

  def set_pos(x, y)
    print("\e[#{y};#{x}H")
    @x = x
    @y = y
  end
end

TTTGame.new.play