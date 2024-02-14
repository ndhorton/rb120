# demonstrate how class variables can store information about the class
# as a whole
class Robot
  @@total_count = 0 # initialzing class variable outside of method definitions

  def initialize
    @@total_count +=  1 # accessible in an instance method (at object level)
  end

  def self.total_count # accessible in a class method (at class level)
    @@total_count
  end
end

puts Robot.total_count # 0

r2d2 = Robot.new
cp30 = Robot.new

puts Robot.total_count # 2

# class variables are shared with descendant classes
class Replicant < Robot; end

roy = Replicant.new # inherited constructor increments shared class variable
puts Robot.total_count # 3

# The fact that there is only one copy of a class variable shared between
# a class and its descendants can cause problems though
class Guitar
  @@strings = 6

  def self.strings
    @@strings
  end
end

class BassGuitar < Guitar
  @@strings = 4
end

puts BassGuitar.strings # 4
puts Guitar.strings # also now 4, the evaluation of the BassGuitar sub-class
                    # definition reassigned the variable for both classes
