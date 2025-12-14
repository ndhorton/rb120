# Think minimax implementation from other file might break with an arbitrarily
# large board since it's recursive

class Board
  # OPPOSITE_MARKER = {
  #   'X' => 'O',
  #   'O' => 'X'
  # }

  # attr_reader :winning_lines

  def initialize(length)
    @squares = {}
    @length = length
    set_winning_lines
    reset
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # Ok to disable these cops since this is a simple display method -- reducing
  # the number of method calls will only make the code less legible
  def draw
    i = 0
    (@length - 1).times do
      puts "     |" * (@length - 1)
      (@length - 1).times { print "  #{@squares[i += 1]}  |" }
      print "  #{@squares[i += 1]}\n"
      puts "     |" * (@length - 1)
      puts "-----+" * (@length - 1) + ("-----")
    end
    puts "     |" * (@length - 1)
    (@length - 1).times { print "  #{@squares[i += 1]}  |" }
    print "  #{@squares[i += 1]}\n"
    puts "     |" * (@length - 1)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def full?
    unmarked_keys.empty?
  end

  def middle_square
    (@length ** 2) / 2 + 1
  end

  def middle_square_open?
    @squares[(@length ** 2) / 2 + 1].unmarked?
  end

  def open_square(marker)
    @winning_lines.each do |line|
      markers = @squares.values_at(*line).map(&:marker)
      if markers.count(marker) == (@length - 1) &&
         markers.count(' ') == 1
        empty_index = markers.index { |sq| sq == ' ' }
        return line[empty_index]
      end
    end
    nil
  end

  def reset
    (1..(@length ** 2)).each { |key| @squares[key] = Square.new }
  end

  def set_winning_lines
    winning_lines = ([*(1..(@length ** 2))]).slice_when { |a, b| a % @length == 0}.to_a
    winning_lines += winning_lines.transpose
    
    first_diagonal = [1]
    i = 1
    (@length - 1).times { first_diagonal << (i = i + @length + 1) }
    winning_lines << first_diagonal

    second_diagonal = [@length]
    i = @length
    (@length - 1).times { second_diagonal << (i = i + @length - 1) }
    winning_lines << second_diagonal
  
    @winning_lines = winning_lines
    winning_lines
  end

  def someone_won?
    !!winning_marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def winning_marker
    @winning_lines.each do |line|
      squares = @squares.values_at(*line)
      if length_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  private

  def length_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != @length
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
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

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER1 = "X"
  HUMAN_MARKER2 = "Y"
  COMPUTER_MARKER = "O"
  BOARD_SIZE = 4 # can be resized arbitrarily

  def initialize
    @board = Board.new(BOARD_SIZE)
    @human1 = Player.new(HUMAN_MARKER1)
    @human2 = Player.new(HUMAN_MARKER2)
    @computer = Player.new(COMPUTER_MARKER)
    @scores = {
      human1: 0,
      human2: 0,
      computer: 0
    }
  end

  def play
    clear
    display_welcome_message
    set_who_goes_first
    main_game
    display_goodbye_message
  end

  private

  attr_reader :board, :human1, :human2, :computer

  def clear
    system('clear')
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def computer_moves
    choices = [human1, human2]
    player_a = choices.shuffle.pop
    player_b = choices.shuffle.pop
    if immediate_win?
      board[board.open_square(computer.marker)] = computer.marker
    elsif immediate_threat?
      if board.open_square(player_a.marker)
        board[board.open_square(player_a.marker)] = computer.marker
      else
        board[board.open_square(player_b.marker)] = computer.marker
      end
    elsif board.middle_square_open?
      board[board.middle_square] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves(human1)
      @current_marker = HUMAN_MARKER2
      clear_screen_and_display_board
      human_moves(human2)
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER1
    end
  end

  def display_board
    puts "Player 1 is #{HUMAN_MARKER1}. Player 2 is #{HUMAN_MARKER2}" \
         " Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_play_again_message
    clear
    puts "Let's play again!"
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when HUMAN_MARKER1
      puts "Player 1 won!"
    when HUMAN_MARKER2
      puts "Player 2 won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def human_moves(player)
    return if board.full?
    player_number = (player.marker == HUMAN_MARKER1 ? '1' : '2')

    puts "Choose a square, Player #{player_number}, " \
         "(#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = player.marker
  end

  def human_turn?
    @current_marker == HUMAN_MARKER1 || @current_marker == HUMAN_MARKER2
  end

  def immediate_win?
    !!(board.open_square(computer.marker))
  end

  def immediate_threat?
    choices = [human1, human2]
    player_a = choices.shuffle.pop
    player_b = choices.shuffle.pop
    !!(board.open_square(player_a.marker) ||
       board.open_square(player_b.marker))
  end

  def joinor(array, delimiter = ', ', conjunction = 'or')
    case array.size
    when 0 then ""
    when 1 then array.first.to_s
    when 2 then "#{array.first} #{conjunction} #{array.last}"
    else
      main_list = array[0..-2].join(delimiter)
      "#{main_list}#{delimiter}#{conjunction} #{array.last}"
    end
  end

  def main_game
    clear
    loop do
      display_board
      player_move
      display_result
      update_scores
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    set_who_goes_first
  end

  def prompt_for_computer_chooses
    puts "Would you like the computer to choose who goes first (y or n)?"
    answer = ''
    loop do
      answer = gets.chomp.strip.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n"
    end
    answer
  end

  def prompt_for_who_goes_first
    puts "Should the humans go first (y or n)?"
    answer = ''
    loop do
      answer = gets.chomp.strip.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n"
    end
    answer
  end

  def set_who_goes_first
    if prompt_for_computer_chooses == 'y'
      @current_marker = ['O', 'X', 'O'].sample
      return
    end
    if prompt_for_who_goes_first == 'y'
      @current_marker = 'X'
    else
      @current_marker = 'O'
    end
  end

  def update_scores
    case board.winning_marker
    when HUMAN_MARKER1    then @scores[:human1] += 1
    when HUMAN_MARKER2    then @scores[:human2] += 1
    when COMPUTER_MARKER then @scores[:computer] += 1
    end
  end
end

game = TTTGame.new
game.play
