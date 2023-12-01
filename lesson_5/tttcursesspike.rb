=begin

player moves a bg_color marker around the board squares
to choose a square to mark.

=end

# BOARD_SKELETON = <<-_EOF_
#      |     |
#      |     |
#      |     |
# -----+-----+------
#      |     |
#      |     |
#      |     |
# -----+-----+------
#      |     |
#      |     |
#      |     |
# _EOF_

require 'curses'
include Curses

VERT_LINE = "|     |"
CROSS_LINE = "-----+-----+------"
BOARD_LENGTH = 11
BOARD_WIDTH = 17
X_MARGIN = 5
Y_MARGIN = 2
ROW_TO_Y = {
  0 => 1,
  1 => 5,
  2 => 9
}
COL_TO_X = {
  0 => 2,
  1 => 8,
  2 => 14
}

def board_fits_screen?
  max_y, max_x = lines, cols
  max_y >= BOARD_WIDTH && max_x >= BOARD_LENGTH
end

def set_x_origin
  max_y, max_x = lines, cols
  max_x >= BOARD_WIDTH + X_MARGIN ? X_MARGIN : 0
end

def set_y_origin
  max_y, max_x = lines, cols
  max_y >= BOARD_LENGTH + Y_MARGIN ? Y_MARGIN : 0
end

def two_line_section(y, x)
  3.times do |i|
    setpos(i + y, x + 5)
    addstr VERT_LINE
  end
end

def draw_board(y, x)
  raise StandardError.new("Terminal too small") unless board_fits_screen?
  # attrset(BLUE)
  attrset(color_pair(3) | Curses::A_NORMAL)
  two_line_section(y, x)
  setpos(y+3, x)
  addstr CROSS_LINE
  two_line_section(y+4, x)
  setpos(y+7, x)
  addstr CROSS_LINE
  two_line_section(y+8, x)
end

def position(row, column)
  setpos(set_y_origin + ROW_TO_Y[row],
         set_x_origin + COL_TO_X[column])
end

def draw_marker(marker_row, marker_col, color, marks)
  position(marker_row, marker_col)
  attrset(color_pair(color) | Curses::A_NORMAL)
  addstr(marks[marker_row][marker_col])
end

def draw_marks(marks)
  (0..2).each do |row|
    (0..2).each do |column|
      position(row, column)
      attrset(color_pair(3) | Curses::A_NORMAL)
      addstr(marks[row][column])
    end
  end
end

def winner?(marks)
  player_winner?('X', marks) || player_winner?('O', marks)
end

def player_winner?(marker, marks)
  (marks.any? do |row|
      row.all? { |square| square == marker }
    end) || 
    (marks.transpose.any? do |row|
      row.all? { |square| square == marker}
    end) ||
    (
      marks[0][0] == marker &&
      marks[1][1] == marker &&
      marks[2][2] == marker
    ) ||
    (
      marks[0][2] == marker &&
      marks[1][1] == marker &&
      marks[2][0] == marker
    )
end

init_screen
start_color if has_colors?
begin
  noecho        # don't echo keypresses; opp echo
  cbreak        # don't wait for <enter>; opp nocbreak
  raw           # opp noraw
  nonl          # no newline for <enter>; opp nl
  stdscr.keypad(true)
  curs_set(0);  # invisible cursor; 1 normal, 2 bright

  init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
  init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_BLACK)
  init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_BLACK)

  marks = [
    [' ', ' ', ' '],
    [' ', ' ', ' '],
    [' ', ' ', ' ']
  ]
  max_y, max_x = lines, cols
  y = set_y_origin
  x = set_x_origin
  marker_row = 1
  marker_col = 1

  loop do
    draw_board(y, x)
    draw_marks(marks)
    draw_marker(marker_row, marker_col, 1, marks)
    input = getch

    case input
    when Curses::Key::LEFT
      draw_marker(marker_row, marker_col, 3, marks)
      marker_col -= 1 unless marker_col == 0
    when Curses::Key::RIGHT
      draw_marker(marker_row, marker_col, 3, marks)
      marker_col += 1 unless marker_col == 2
    when Curses::Key::UP
      draw_marker(marker_row, marker_col, 3, marks)
      marker_row -= 1 unless marker_row == 0
    when Curses::Key::DOWN
      draw_marker(marker_row, marker_col, 3, marks)
      marker_row += 1 unless marker_row == 2
    when ' '
      marks[marker_row][marker_col] = 'X'
    end
    # clear
    refresh
    break if input == 'q' || winner?(marks)
  end
ensure
  close_screen
end
