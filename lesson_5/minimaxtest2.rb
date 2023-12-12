class Game
  EMPTY = ' '

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :computer_choice, :active
  attr_accessor :board

  def initialize(at = true)
    @human_player = "X"
    @computer_player = "O"
    @active = at
    @board = {}
    (1..9).each { |num| @board[num] = EMPTY }
  end
  
  def []=(key, marker)
    @board[key] = marker
  end

  def active_turn
    if @active
      @computer_player
    else
      @human_player
    end
  end

  def win?(marker)
    WINNING_LINES.each do |line|
      markers_in_line = @board.values_at(*line)
      return true if markers_in_line.all?(marker)
    end
    false
  end

  def over?
    win?(@computer_player) || win?(@human_player) || @board.values.none?(EMPTY)
  end

  def get_available_moves
    @board.select { |k, v| v == EMPTY }.keys
  end

  def get_new_state(move)
    new_state = Game.new(!active)
    new_state.board = board.dup
    new_state[move] = (active_turn)
    new_state
  end

  # minimax
  def score(game, depth)
    if game.win?(@computer_player)
      10 - depth
    elsif game.win?(@human_player)
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
  
    p moves
    p scores

    if game.active_turn == @computer_player
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
  1 => ' ',
  2 => 'X',
  3 => ' ',
  4 => ' ',
  5 => ' ',
  6 => 'X',
  7 => 'O',
  8 => 'O',
  9 => 'X'
}

game.minimax(game)
p game.computer_choice