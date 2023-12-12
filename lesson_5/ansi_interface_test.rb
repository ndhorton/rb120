require 'io/console'
require 'psych'
require 'pty'

TEXT = Psych.load_file("#{__dir__}/ttt_bonus_features.yml")['english']

module Colors
  FG_BLACK = "\e[30m"
  BG_WHITE = "\e[47m"
  BG_BLACK = "\e[40m"
  RESET = "\e[0m"
end

class UserInterface
  include Colors

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

  # def clear_board(board_state)
  #   print FG_BLACK
  #   print BG_BLACK
  #   draw_skeleton(board_state)
  #   print RESET
  # end

  def draw_skeleton
    set_pos(1, 1)
    print_string(Board::SKELETON)

    set_pos(1, 13)
    print_string "k/j - up/down, h/l - left/right, <space> to mark a square"
    set_pos(1, 14)
    print_string "q to quit at any time"
  end

  def draw_cursor(board_state)
    set_pos(@cursor.x, @cursor.y)
    print_char("#{FG_BLACK}#{BG_WHITE}#{board_state[@cursor.square_index]}#{RESET}")
    set_pos(1, 15) # in case `tput civis` fails to hide terminal cursor 
  end

  def draw_squares(board_state)
    SQUARE_POSITIONS.each_with_index do |(x, y), index|
      set_pos(x, y)
      print_char(board_state[index])
    end
  end

  def draw_board(board_state)
    # clear_board(board_state)
    $stdout.clear_screen
    draw_skeleton
    draw_squares(board_state)
    draw_cursor(board_state)
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

  def mark_square
    board_state[@cursor.square_index] = 'X'
    @cursor.reset
  end

  def read_input
    ch = $stdin.getch
    case ch.downcase
    when 'h' then @cursor.x -= 6 unless @cursor.x == 3
    when 'j' then @cursor.y += 4 unless @cursor.y == 10
    when 'k' then @cursor.y -= 4 unless @cursor.y == 2
    when 'l' then @cursor.x += 6 unless @cursor.x == 15
    when ' ' then return @cursor.square_index
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

class Cursor
  SQUARE_POSITIONS = [
    [3, 2], [9, 2], [15, 2],
    [3, 6], [9, 6], [15, 6],
    [3, 10], [9, 10], [15, 10]
  ]

  attr_accessor :x, :y

  def initialize
    reset
  end

  def reset
    @x, @y = SQUARE_POSITIONS[4]
  end

  def square_index
    SQUARE_POSITIONS.index([x, y])
  end
end

class Board
  INITIAL_MARKER = ' '
  PLAYER1 = 'X'
  PLAYER2 = 'O'
  SKELETON = TEXT['board_skeleton'].join.freeze

  def initialize
    @squares = []
    (0..8).each { |i| @squares[i] = INITIAL_MARKER }
  end

  def [](square)
    @squares[square]
  end

  def []=(square, marker)
    @squares[square] = marker
  end
end


class TTTGame
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    begin
      @ui = UserInterface.new
      $stdin.echo = false
      # system('tput civis')
      loop do
        @ui.draw_board(board)
        move = @ui.read_input 
        break if move == :quit
        if move
          board[move] = 'X'
          # break
        end
      end
      $stdout.clear_screen
    ensure
      revert_terminal
    end
  end

  def revert_terminal
    system('tput cnorm')
    $stdin.echo = true
    # @ui.set_pos(1, 12)
  end
end

TTTGame.new.play

