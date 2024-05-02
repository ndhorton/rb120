=begin

Design a Sports Team (Author Unknown...thank you!)

- Include 4 players (attacker, midfielder, defender, goalkeeper)

- All the players’ jersey is blue, except the goalkeeper, his jersey is white with blue stripes

- All players can run and shoot the ball.

- Attacker should be able to lob the ball

- Midfielder should be able to pass the ball

- Defender should be able to block the ball

- The referee has a whistle. He wears black and is able to run and whistle.

SportsTeam

player
> has a
  jersey blue
-run
-shoot_ball
<is a 
  goalkeeper
  >has a 
    jersey white with blue stripes
  attacker
  -lob_ball
  midfielder
  -pass_ball
  defender
  -block_ball

referee
>has a
  whistle
  jersey black
-run
-whistle

jersey
  blue
  white with blue stripes


ball




=end

module Runnable
  def run
  end
end

class Player
  include Runnable

  def initialize
    @jersey = "blue"
    @ball = nil
  end

  def shoot
  end
end

class Goalkeeper < Player
  def initialize
    @jersey = "white with blue stripes"
    @ball = nil
  end
end

class Attacker < Player
  def lob
  end
end

class Midfielder < Player
  def pass(other_player)
  end
end

class Defender < Player
  def block
  end
end

class Ball
end

class Whistle
end

class Referee
  include Runnable

  def initialize
    @jersey = "black"
    @whistle = Whistle.new
    @ball = Ball.new
  end

  def whistle
  end
end

class SportsTeam
  attr_reader :goalkeeper, :attacker, :midfielder, :defender

  def initialize
    @goalkeeper = Goalkeeper.new,
    @attacker = Attacker.new,
    @midfielder = Midfielder.new
    @defender = Defender.new
  end
end

team1 = SportsTeam.new
team2 = SportsTeam.new
referee = Referee.new

# 18m43