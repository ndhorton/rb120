class Roster
  attr_accessor :players
end

class Player
  attr_accessor :name, :position

  def initialize(name, position)
    @name = name
    @position = position
  end
end

moore = Player.new("Maya Moore", "Forward")
taurasi = Player.new("Diana Taurasi", "Guard")
tourney_roster1 = Roster.new
tourney_roster1.players = [moore, taurasi]
