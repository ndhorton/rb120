# Lesson 5, 5: Lecture: Discussion on OO TTT Code, part 7

class Player
  # ... rest of class omitted for brevity

  def initialize(marker, player_type = :human)
    @marker = marker
    @player_type = player_type
  end

  private

  def human?
    @player_type == :human
  end
end

class TTTGame
  # rest of code ...
  def initialize
    # rest of code ...
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER, :computer)
  end
  # rest of code ...
end
