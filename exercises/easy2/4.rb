# Reverse Engineering

=begin

an initalize method that stores argument as, say, `@string`
an uppercase instance method that returns uppercase version of `@string`
a lowercase class method that returns lowercase version of argument passed to class method
class is called Transform

=end

class Transform
  def self.lowercase(string)
    string.downcase
  end

  def initialize(string)
    @string = string
  end

  def uppercase
    @string.upcase
  end
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')