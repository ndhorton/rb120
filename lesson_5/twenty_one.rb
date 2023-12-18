module Displayable
  def display_goodbye
  end

  def display_welcome
  end
end

module Pageable
  def page(text)
  end
end

module Promptable
  def player_stays?
  end

  def play_again?
  end

  def prompt_for_name
  end

  def show_rules?
  end
end

class Participant
  attr_accessor :name

  def busted?
  end
end

class Card
end

class Deck
end

# Orchestration engine
class TwentyOne
  include Displayable
  include Pageable
  include Promptable

  attr_reader :deck, :player, :dealer

  def initalize
    @deck = Deck.new
    @player = Player.new(deck)
    @dealer = Player.new(deck)
  end

  def play
    display_welcome
    set_player_name
    rules_check
    game_loop
    display_goodbye
  end

  private

  def game_loop
    loop do
      initial_deal
      player_turn
      dealer_turn unless player.busted?
      declare_winner
      break unless play_again?
    end
  end

  def player_turn
    loop do
      display_hands
      break if player.busted? || player.stay?
      player.hit
    end
  end

  def rules_check
    page(TEXT['rules']) if show_rules?
  end

  def set_player_name
    name = prompt_for_name
    player.name = name
  end
end