require 'ruby_figlet'
using RubyFiglet

fonts = RubyFiglet::Figlet.available.split("\n").reject(&:empty?)

fonts.each do |font|
  text = 'Twenty-One'
  text.art! font
  puts text
end
