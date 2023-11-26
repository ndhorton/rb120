require 'psych'

TEXTDATA = Psych.load_file("#{__dir__}/yamltest.yml")

text = TEXTDATA['english']

# input = nil
# puts text['move_prompt']
# loop do
#   valid_input = false
#   input = gets.chomp.strip
#   break if text['moves'].include?(input)
#   puts text['invalid_move']
# end

# input = nil
# puts "enter (y)es or (n)o"
# loop do
#   input = gets.chomp.strip
#   break if text['yesno'].include?(input)
#   puts "Invalid. Y or n"
# end

puts text['rules']