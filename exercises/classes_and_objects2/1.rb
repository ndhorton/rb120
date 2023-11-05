class Cat
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
end

Cat.generic_greeting
kitty = Cat.new
kitty.class.generic_greeting
# Line 9 works because calling `#class` on `kitty` returns the `Class` object `Cat`
# and then we simply call the class method `::generic_greeting` on `Cat`
