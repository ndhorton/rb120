# Number Guesser Part 1

=begin

P:

Write an OOP number guessing game

rules:
  7 guesses
  the number is a random number in 1..100
  it should say if your number is outside the range/invalid input
  it should tell you if your guess is too low or too high

Etc:

DS:

class GuessingGame
- #initialize should pick the number
- #play

A:

=end

# class GuessingGame
#   attr_reader :secret_number

#   def initialize
#     @secret_number = rand(1..100)
#     @guesses = 7
#     @current_guess = nil
#   end

#   def play
#     until @guesses.zero? || guessed_correctly?
#       display_guesses_remaining
#       prompt_for_guess
#       evaluate_guess
#       decrement_guesses
#     end
#     display_player_lost unless guessed_correctly?
#   end

#   private

#   def decrement_guesses
#     @guesses -= 1
#   end

#   def guessed_correctly?
#     @current_guess == @secret_number
#   end

#   def display_guesses_remaining
#     if @guesses == 1
#       puts "You have 1 guess remaining."
#     else
#       puts "You have #{@guesses} guesses remaining."
#     end
#   end

#   def prompt_for_guess
#     print "Enter a number between 1 and 100: "
#     loop do
#       @current_guess = gets.chomp.to_i
#       break if (1..100).cover?(@current_guess)
#       print "Invalid guess. Enter a number between 1 and 100: "
#     end
#   end

#   def evaluate_guess
#     if guessed_correctly?                 then display_player_won
#     elsif @current_guess < @secret_number then display_too_low
#     elsif @current_guess > @secret_number then display_too_high
#     end
#   end

#   def display_player_lost
#     puts "You have no more guesses. You lost!"
#   end

#   def display_player_won
#     puts "That's the number!"
#     puts
#     puts "You won!"
#   end

#   def display_too_high
#     puts "Your guess is too high."
#     puts
#   end

#   def display_too_low
#     puts "Your guess is too low."
#     puts
#   end
# end

# GuessingGame.new.play

# LS solution

class Player
  def initialize(range)
    @range = range
  end

  def guess
    loop do
      print "Enter a number between #{@range.first} and #{@range.last}: "
      guess = gets.chomp.to_i
      return guess if @range.cover?(guess)
      print "Invalid guess. "
    end
  end
end

class GuessingGame
  MAX_GUESSES = 7
  RANGE = 1..100

  RESULT_OF_GUESS_MESSAGE = {
    high:  "Your number is too high.",
    low:   "Your number is too low.",
    match: "That's the number!"
  }.freeze

  WIN_OR_LOSE = {
    high:  :lose,
    low:   :lose,
    match: :win
  }.freeze

  RESULT_OF_GAME_MESSAGE = {
    win:  "You won!",
    lose: "You have no more guesses. You lost!"
  }.freeze

  def initialize
    @player = nil
    @secret_number = nil
  end

  def play
    reset
    game_result = play_game
    display_game_end_message(game_result)
  end

  private

  def reset
    @player = Player.new(RANGE)
    @secret_number = rand(RANGE)
  end

  def play_game
    result = nil
    MAX_GUESSES.downto(1) do |remaining_guesses|
      display_guesses_remaining(remaining_guesses)
      result = check_guess(@player.guess)
      puts RESULT_OF_GUESS_MESSAGE[result]
      break if result == :match
    end
    WIN_OR_LOSE[result]
  end

  def display_guesses_remaining(remaining)
    puts
    if remaining == 1
      puts 'You have 1 guess remaining.'
    else
      puts "You have #{remaining} guesses remaining."
    end
  end

  def check_guess(guess_value)
    return :match if guess_value == @secret_number
    return :low if guess_value < @secret_number
    :high
  end

  def display_game_end_message(result)
    puts "", RESULT_OF_GAME_MESSAGE[result]
  end
end

GuessingGame.new.play


# Further exploration
=begin

Player (collaborator to GuessingGame)
-guess

=end