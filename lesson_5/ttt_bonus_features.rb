require 'io/console'
require 'psych'

TEXT = Psych.load_file("#{__dir__}/ttt_bonus_features.yml")['english']

module Displayable
  private

  FG_BLACK = "\e[30m"
  BG_WHITE = "\e[47m"
  RESET = "\e[0m"

  BOARD_SKELETON = TEXT['board_skeleton'].join.freeze

  def display_board
    draw_board(cursor: board.human_turn?)
  end

  def display_games_won(player_name, player_score)
    puts format(TEXT['display_scores_won'],
                player_name: player_name,
                game_or_games: pluralize(player_score))
  end

  def display_goodbye
    puts TEXT['goodbye']
  end

  def display_opponent
    puts format(TEXT['display_opponent'], computer_name: computer.name)
  end

  def display_scores
    puts TEXT['display_scores_preamble']
    display_games_won(human.name, scores[:human])
    display_games_won(computer.name, scores[:computer])
    puts format(TEXT['display_scores_tie'],
                game_or_games: pluralize(scores[:tie]))
  end

  def display_welcome
    $stdout.clear_screen
    puts TEXT['welcome']
  end

  def display_winner
    if board.human_won?
      puts format(TEXT['display_winner_won'], player_name: human.name)
    elsif board.computer_won?
      puts format(TEXT['display_winner_won'], player_name: computer.name)
    else
      puts TEXT['display_winner_tie']
    end
  end

  def draw_board(cursor: true)
    $stdout.clear_screen
    draw_header
    draw_skeleton
    draw_squares
    draw_footer
    draw_cursor if cursor
  end

  def draw_cursor
    set_pos(cursor.x, cursor.y)
    print("#{FG_BLACK}#{BG_WHITE}#{board[cursor.square]}#{RESET}")
    set_pos(1, 17)
  end

  def draw_footer
    game_not_over = !board.end_state?
    set_pos(1, 15)
    if board.human_turn? && game_not_over
      print TEXT['draw_footer_controls']
      print TEXT['draw_footer_quit']
    elsif game_not_over
      print format(TEXT['computer_is_thinking'], computer_name: computer.name)
    end
  end

  def draw_header
    set_pos(1, 1)
    print format(TEXT['draw_header'], human_name: human.name,
                                      human_marker: board.human_marker,
                                      computer_name: computer.name,
                                      computer_marker: board.computer_marker)
  end

  def draw_skeleton
    set_pos(1, 3)
    print(BOARD_SKELETON)
  end

  def draw_squares
    Cursor::SQUARE_POSITIONS.values.each_with_index do |(x, y), index|
      set_pos(x, y)
      print(board[index + 1])
    end
  end

  def start_terminal_environment
    if $stdout.winsize.first < 17
      raise ConsoleWindowError, TEXT['winsize_error_message']
    end
    system('tput init')
    system('tput civis')
    $stdout.clear_screen
  end

  def pluralize(number)
    if number == 1
      format(TEXT['pluralize_single'], number: number)
    else
      format(TEXT['pluralize_plural'], number: number)
    end
  end

  def revert_terminal
    system('tput cnorm')
    $stdin.echo = true
    $stdout.clear_screen
  end

  def set_pos(x, y)
    print("\e[#{y};#{x}H")
  end
end

module Promptable
  private

  def prompt(prompt_text, options, error_text)
    puts prompt_text
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if options.include?(answer)
      puts error_text
    end
    answer[0]
  end

  def prompt_for_difficulty
    prompt(TEXT['prompt_difficulty_text'], TEXT['prompt_difficulty_options'],
           TEXT['prompt_difficulty_error'])
  end

  def prompt_for_marker
    prompt(TEXT['prompt_marker_text'], TEXT['prompt_marker_options'],
           TEXT['prompt_marker_error'])
  end

  def prompt_for_name
    puts TEXT['prompt_name_text']
    answer = nil
    loop do
      answer = gets.chomp.strip
      break unless answer.empty?
      puts TEXT['prompt_name_error']
    end
    answer
  end

  def prompt_for_play_again
    prompt(TEXT['prompt_play_again_text'], TEXT['prompt_play_again_options'],
           TEXT['prompt_play_again_error'])
  end

  def prompt_for_who_goes_first
    prompt(TEXT['prompt_who_goes_first_text'],
           TEXT['prompt_who_goes_first_options'],
           TEXT['prompt_who_goes_first_error'])
  end
end

class ConsoleWindowError < StandardError; end

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
  attr_reader :name
  attr_accessor :marker
end

class Human < Player
  attr_writer :name
end

class R2D2 < Player
  # rubocop:disable Lint/MissingSuper
  def initialize
    @name = TEXT['computer_r2d2']
  end
  # rubocop:enable Lint/MissingSuper

  def choose(board)
    board.empty_squares.sample
  end
end

class Sonny < Player
  # rubocop:disable Lint/MissingSuper
  def initialize
    @name = TEXT['computer_sonny']
  end
  # rubocop:enable Lint/MissingSuper

  def choose(board)
    immediate_win = board.open_square(board.computer_marker)
    immediate_threat = board.open_square(board.human_marker)
    if immediate_win                then immediate_win
    elsif immediate_threat          then immediate_threat
    elsif board.middle_square_open? then 5
    else
      board.empty_squares.sample
    end
  end
end

class Hal < Player
  # rubocop:disable Lint/MissingSuper
  def initialize
    @name = TEXT['computer_hal']
    @choice = nil
  end
  # rubocop:enable Lint/MissingSuper

  def choose(board)
    # Guard clause prevents long think-time on first move
    return [9, 5].sample if board.empty_squares.size == 9

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

class Cursor
  SQUARE_POSITIONS = {
    1 => [3, 4], 2 => [9, 4], 3 => [15, 4], 4 => [3, 8], 5 => [9, 8],
    6 => [15, 8], 7 => [3, 12], 8 => [9, 12], 9 => [15, 12]
  }

  attr_accessor :x, :y

  def initialize
    reset
  end

  def up
    @y -= 4 unless @y == 4
  end

  def down
    @y += 4 unless @y == 12
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

class TTTGame
  include Displayable
  include Promptable

  def initialize
    @cursor = Cursor.new
    @human = Human.new
    @board = Board.new
    @scores = {
      human: 0,
      computer: 0,
      tie: 0
    }
  end

  def play
    display_welcome
    user_dependent_setup
    main_game
    display_scores
    display_goodbye
  rescue ConsoleWindowError => e
    puts e.message
    puts TEXT['winsize_error_rescue']
  end

  private


  attr_reader :board, :quit, :human, :computer, :scores
  attr_accessor :cursor

  def computer_moves
    move = computer.choose(board)
    board[move] = board.computer_marker
    board.active_turn = :human
  end

  def game_over?
    board.full? || board.someone_won?
  end

  def human_moves
    move = read_raw_input
    @quit = true if move == :quit

    return unless board.empty_squares.include?(move)

    board[move] = board.human_marker
    reset_cursor
    board.active_turn = :computer
  end

  def play_again?
    draw_board(cursor: false)
    display_winner
    answer = prompt_for_play_again
    answer == TEXT['affirmative']
  end

  def play_game
    loop do
      display_board
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
    start_terminal_environment
    loop do
      play_game
      break if quit
      update_scores
      break unless play_again?
      reset
    end
  ensure
    revert_terminal
  end

  def move_cursor(char)
    case char.downcase
    when 'h' then cursor.left
    when 'j' then cursor.down
    when 'k' then cursor.up
    when 'l' then cursor.right
    end
  end

  def read_raw_input
    char = $stdin.getch

    return cursor.square if char == ' '
    return :quit if char == 'q'

    move_cursor(char)
    nil
  end

  def reset_cursor
    cursor.x, cursor.y = Cursor::SQUARE_POSITIONS[5]
  end

  def reset
    board.reset_squares
    if @first_player == :human
      @first_player = :computer
      board.active_turn = :computer
    else
      @first_player = :human
      board.active_turn = :human
    end
  end

  def set_difficulty_level
    difficulty = prompt_for_difficulty
    @computer = case difficulty
                when TEXT['difficulty_easy']   then R2D2.new
                when TEXT['difficulty_medium'] then Sonny.new
                when TEXT['difficulty_hard']   then Hal.new
                end
    display_opponent
  end

  def set_player_markers
    marker = prompt_for_marker
    if marker == 'x'
      board.human_marker = 'X'
      board.computer_marker = 'O'
    else
      board.human_marker = 'O'
      board.computer_marker = 'X'
    end
  end

  def set_human_name
    answer = prompt_for_name
    human.name = answer
  end

  def set_who_goes_first
    answer = prompt_for_who_goes_first
    @first_player = (answer == TEXT['human'] ? :human : :computer)
    board.active_turn = @first_player
  end

  def update_scores
    if board.human_won?
      scores[:human] += 1
    elsif board.computer_won?
      scores[:computer] += 1
    else
      scores[:tie] += 1
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
