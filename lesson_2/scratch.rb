class Example
  attr_reader :something

  def initialize
    @something = []
  end

  def print_something
    if something.size == 1
      puts "something has just 1 item: #{something[0]}"
    elsif something.size == 2
      puts "something has 2 items: #{something[0]} #{something[1]}}"
    else
      puts "something has #{something.size} items: #{something.join(' ')}"
    end
  end
end

assignments: 0

branches: 14

Example#something - 7
.size
[0]
.size
[0]
[1]
.size
.join
==
==
puts
puts
puts

conditions: 2

something.size == 1
something.size == 2