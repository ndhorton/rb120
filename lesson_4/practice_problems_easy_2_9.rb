class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    # rules of play
  end
end

# adding a `#play` method to the Bingo class would override
# the `#game` method in the superclass
