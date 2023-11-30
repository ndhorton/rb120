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

VERT_LINE = "|     |"
CROSS_LINE = "-----+-----+------"

require 'curses'
include Curses

def draw_board
  max_y = lines
  max_x = cols

end

init_screen
begin
  loop do  
    noecho # don't echo keypresses; opp echo
    cbreak # don't wait for <enter>; opp nocbreak
    input = getch
    break if input == 'q'
    draw_board
  end
ensure
  close_screen
end
