class BitString
  def initialize(v)
    @value = v
  end

  attr_accessor :value

  def +(other)
    BitString.new(value + other.value)
  end

  def to_s
    value
  end
end

str1 = BitString.new('01011010')
str2 = BitString.new('10111011')
str3 = str1 + str2
puts "str1: #{str1}"
puts "str2: #{str2}"
puts "new bitstring: #{str3}"
puts str3.class