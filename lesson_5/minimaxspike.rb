# None of this actually works, there is however Ruby/pseudocode outline
# at wwww.neverstopbuilding.com/blog/minimax
class Board
  # ... other methods etc omitted ...
  MARKERS = {
    first: ['X', 'O'],
    second: ['O', 'X']
  }

  def minimax(state, player, max = true)
    if state.winner?
      case state.score(player, max)
    end

    player_marker, opponent_marker = MARKERS[player]

    possible_moves = state.empty_squares
    possible_moves.each do |square|
      next_state = state.deep_copy
      next_state[square] = (max ? player_marker : opponent_marker)
      score += minimax(next_state, player, !max)
    end
          # you want to map the first level possible_moves to the values of their
          # end state in order to choose the one with the max value
          
  end
end

board.minimax(board, :first) # ?