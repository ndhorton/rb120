# Complete the Program - Houses

=begin

P:
  Add to the code to produce the requested output

rules:
  You can only define one new method in `House`

So you could add `#<` and `#>` methods but that's two methods

=end

# one idea would be to include this module as a mixin to House
# module Sellable
#   def >(other)
#     self.price > other.price
#   end

#   def <(other)
#     self.price < other.price
#   end
# end

# # So the hint suggests a monkey-patching solution
# module Comparable
#   def >(other)
#     self.price > other.price
#   end

#   def <(other)
#     self.price < other.price
#   end
# end

# class House
#   include Comparable

#   attr_reader :price

#   def initialize(price)
#     @price = price
#   end
# end

# home1 = House.new(100_000)
# home2 = House.new(150_000)
# puts "Home 1 is cheaper" if home1 < home2
# puts "Home 2 is more expensive" if home2 > home1

# puts 'b' > 'a' # This is a terrible solution however because now existing core classes break
# puts 'a' < 'b'

# LS solution
# OVERRIDE the `Comparable#<=>` method only, and do so within the House class after the module is included
class House
  include Comparable

  attr_reader :price

  def initialize(price)
    @price = price
  end

  def <=>(other)
    self.price <=> other.price
  end
end

# This also suggests that Comparable defines all comparisons in relation to the `Comparable#<=>` method

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1
1
# The downsides of this approach:
#   price is not the only measure of a house, you might measure space (area) for instance
#   You might more naturally compare `home1.price` to `home2.price` specifically
#     (in which case Numeric comparison is already provided by the language)
#   Our method makes price the default comparison for the object itself instead of one aspect of the object

# User-defined algebraic/mathematical objects might find it useful to include Comparable and override the `<=>` method
# Or any object where there is a single, natural point of comparison