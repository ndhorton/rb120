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

class TTTGame
  def initialize
  end

  def play
  end

  private
end

class Game
  EMPTY = ' '

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :computer_choice, :active
  attr_accessor :board, :human_marker, :computer_marker

  def initialize(at = true)
    # @human_marker = "X"
    # @computer_marker = "O"
    @active = at
    @board = {}
    (1..9).each { |num| @board[num] = Square.new }
  end
  
  def []=(key, marker)
    @board[key].marker = marker
  end

  def active_turn
    if @active
      @computer_marker
    else
      @human_marker
    end
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @board.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def win?(marker)
    WINNING_LINES.each do |line|
      markers_in_line = @board.values_at(*line)
      return true if markers_in_line.all?(marker)
    end
    false
  end

  def over?
    human_won? || computer_won? || full?
  end

  def human_won?
    winning_marker == human_marker
  end

  def computer_won?
    winning_marker == computer_marker
  end

  def full?
    get_available_moves.empty?
  end

  # def over?
  #   win?(@computer_marker) || win?(@human_marker) || @board.values.none?(EMPTY)
  # end

  def get_available_moves
    @board.select { |k, v| v.unmarked? }.keys
  end

  def get_new_state(move)
    new_state = Game.new(!active)
    new_state.board = board.map { |k, v| [k, v.dup] }.to_h
    new_state[move] = (active_turn)
    new_state.human_marker = human_marker
    new_state.computer_marker = computer_marker
    new_state
  end

  # minimax
  def score(game, depth)
    if game.computer_won?
      10 - depth
    elsif game.human_won?
      depth - 10
    else
      0
    end
  end

  def minimax(game, depth = 1)
    return score(game, depth) if game.over?
    scores = []
    moves = []

    game.get_available_moves.each do |move|
      possible_game = game.get_new_state(move)
      scores.push minimax(possible_game, depth + 1)
      moves.push move
    end
  

    if game.active_turn == @computer_marker
      max_score_index = scores.each_with_index.to_a.max[1]
      @computer_choice = moves[max_score_index]
      return scores[max_score_index]
    else
      min_score_index = scores.each_with_index.min[1]
      @computer_choice = moves[min_score_index]
      return scores[min_score_index]
    end
  end
end

game = Game.new
game.board = {
  1 => Square.new('X'),
  2 => Square.new('O'),
  3 => Square.new('O'),
  4 => Square.new('O'),
  5 => Square.new('X'),
  6 => Square.new('X'),
  7 => Square.new('X'),
  8 => Square.new('O'),
  9 => Square.new('O')
}
game.human_marker = 'X'
game.computer_marker = 'O'

game.minimax(game)
p game.computer_choice