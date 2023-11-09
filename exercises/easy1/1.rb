# Bammer Class

=begin

Notes:

so the initalize method needs to store the input message in an instance variable
the empty_line method needs to print '|' + (size of message + 2) spaces + '|'
the horizontal rule method needs to print '+' + (size of message + 2) spaces + '+'

This is already implemented in the to_s method, they choose to build as an array
and return as a string
the banner should be 'drawn' and returned by the to_s method
  -- could be returned as an array, or as text with \n chars to separate lines

Problem:
input: a string message
output: print to screen a banner containing that message

Complete the class so that the interface given by the examples
produces the expected output

rules:
  assume the input will always fit in the terminal window

Examples/test cases:

Algorithm:
suprocess initialize
Given a string, message
Set @message := message
Return

subprocess horizontal_rule -> return string
Return '+' + (@message size + 2) '-' chars + '+'

suprocess empty_line
Return '|' + (@message size + 2) spaces + '|'

=end

# class Banner
#   def initialize(message)
#     @message = message
#   end
# 
#   def to_s
#     [
#       horizontal_rule,
#       empty_line,
#       message_line,
#       empty_line,
#       horizontal_rule
#     ].join("\n")
#   end
# 
#   private
# 
#   def horizontal_rule
#     "+-#{'-' * @message.size}-+"
#   end
# 
#   def empty_line
#     "| #{' ' * @message.size} |"
#   end
# 
#   def message_line
#     "| #{@message} |"
#   end
# end
# 
# `banner = Banner.new('To boldly go where no one has gone before.')
# puts banner

# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

# banner = Banner.new('')
# puts banner

# +--+
# |  |
# |  |
# |  |
# +--+

# 20:14

=begin
Further exploration:
====================

you might have something like
Banner.intialize(message, user_width = nil) -> void
left_padding = user_width ? user_width / 2 : 0
right_padding = user_width ? user_width / 2 : 0

At the moment the banner size is determined dynamically by the size of the message
Since input is guarenteed to be less than the line of the terminal (though that's not the whole story,
  you have +4 in horizontal, and if the message size where not -4 less than terminal size, what then?)

at the moment, the horizontal size is message length + 4
assuming the text always fits on one line of a terminal INCLUDING banner outline and padding
  then vertical size is 5 rows

what happens if the user requests a banner size bigger than the terminal?
- could simply abide by their request and produce mangled output
- could refuse - raise some sort of range-based exception
- could quietly limit the size to a maximum terminal line length

what happens if the size is not enought to draw a banner at all?
minimum column size would be "| #{one char} |" = 5
if the user_width is less than the width of the message
- need to split message into characters in such a way as to handle spaces between words
- would you add hypens to the end of a word broken at the end of a line?

So the simplest functionality would be to leave it to the user to pick sane sizes
You could than add validating and error logic later
No hypens for split words
a minimum width of "| a |" = 5 should probably be enforced because unless you want to dispence with padding
alternative with no padding would be "|a|" = 3
attempt to word wrap though
-- what if the maximum word is greater in size than the total_width?
---- then you would have to split words, possibly more than once
--

At the moment, the magic number for variadic line length is @message.size
At the moment, the array in to_s that builds the string return has one line for the message
If you need multiple lines for the message, that will have to be flattened into the existing array
in place of a single element

I think the approach would be
In the #to_s method
  rename #message_line to #message_lines
  insert #flatten before #join

in the #message_line method
  rename method to #message_lines
  we now want to return an array where the message is broken into formatted (with box-side and padding)
  lines in an array of lines
    scan with regex

so the standard behaviour if no width arg is given to constructor

=end

# values acceptable to for the `width` parameter of the constructor are
# 5 <= `width` <= 80
# if a `width` arg is not given, the size of the message determines field width
class Banner
  PADDING = 4
  TERMINAL_WIDTH = 80
  MINIMUM_WIDTH = PADDING + 1
  
  def initialize(message, width = nil)
    @message = message
    determine_width(width)
  end

  def to_s
    [
      horizontal_rule,
      empty_line,
      message_lines,
      empty_line,
      horizontal_rule
    ].flatten.join("\n")
  end

  private

  def determine_width(width)
    # you could have more complex logic to deal with bad input
    # you could set too-low width input to the minimum width (5)
    # and too-high width input could be set to maximum width (TERMINAL_WIDTH)
    @field_width  = if width && width > 1 + PADDING && width < TERMINAL_WIDTH
                      width - PADDING
                    elsif @message.size > TERMINAL_WIDTH - PADDING
                      TERMINAL_WIDTH - PADDING
                    else
                      @message.size
                    end
  end
  
  def horizontal_rule
    "+-#{'-' * @field_width}-+"
  end

  def empty_line
    "| #{' ' * @field_width} |"
  end

  def message_lines
    # get array of message lines
    # for each line transform to
    #  "| #{line} |"
    lines = @message.scan(/.{1,#{@field_width}}/)
    lines.map { |text| "| #{text.center(@field_width)} |"}
  end
end

banner = Banner.new('good morning', 70)
puts banner