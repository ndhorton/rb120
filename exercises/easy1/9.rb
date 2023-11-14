# Complete the Program - Cats!

class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  def initialize(name, age, color)
    super(name, age)
    @color = color
  end

  def to_s
    "My cat #{@name} is #{@age} years old and has #{@color} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch

# We would be able to omit the `initialize` method from Cat because the entire
# functionality would be inherited from Pet

# This might be a bad idea if we didn't want to specify colors for other types of Pet
# It would probably be easier to deal with such types of Pet by omitting this detail from
# the Pet class than having to work around it by overriding the `initialize` method entirely.