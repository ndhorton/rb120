# class Pizza will create objects with a single instance variable
# `@name`. This is because the Pizza class's `#initialize` method
# contains an initialization of the instance variable `@name`.

# The Fruit class contains the redundant reassingment of the
# parameter local variable `name` in its `#initialize` method.

# The `#initialize` method is called when an object is instantiated
# by calling `new` on the class. Therefore, instance variables
# initialized in the `#initialize` method exist as soon as
# an object is instantiated.

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

pizza = Pizza.new('Four Cheeses')

# This, I assume, is the 'asking the object' way of finding out.
p pizza.instance_variables
