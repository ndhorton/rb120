require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_accessor :computer_player, :active_turn, :choice

  def initialize(at = true)
    @squares = {}
    @computer_player = 'X'
    @active_turn = at
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

  def opposite_marker
    'O'
  end

  def score(game)
    if game.winning_marker == computer_player
      return 10
    elsif game.winning_marker == opposite_marker
      return -10
    else
      0
    end
  end

  def existing_state
    @squares.dup
  end

  def replace_state(game)
    @squares = game.existing_state.dup
  end

  def get_new_state(move, game)
    new_state = Board.new(!active_turn)
    new_state.replace_state(game)
    new_state[move] = (new_state.active_turn ? new_state.computer_player : new_state.opposite_marker)
    new_state
  end

  def minimax(game)
    return score(game) if game.someone_won?
    scores = []
    moves = []

    game.unmarked_keys.each do |move|
      possible_game = game.get_new_state(move, game)
 
      scores << minimax(possible_game)
      moves << move
    end

    if game.active_turn
      max_score_index = scores.each_with_index.max[1]
      @choice = moves[max_score_index]
      return scores[max_score_index]
    else
      min_score_index = scores.each_with_index.min[1]
      @choice = moves[min_score_index]
      return scores[min_score_index]
    end
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

game = Board.new
# game[1] = 'O'
# game[2] = ' '
# game[3] = 'X'

# game[4] = 'X'
# game[5] = ' '
# game[6] = ' '

# game[7] = 'X'
# game[8] = 'O'
# game[9] = 'O'

game[1] = 'O'
game[2] = 'O'
game[3] = ' '

game[4] = 'X'
game[5] = ' '
game[6] = ' '

game[7] = 'O'
game[8] = 'O'
game[9] = 'X'

game.minimax(game)
p game.choice