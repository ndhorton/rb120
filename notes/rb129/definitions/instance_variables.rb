# The `initialize` constructor method will create a `@name` instance variable
# as soon as a new `Cat` object is created
class Cat
  def initialize(name)
    @name = name
  end
end

barnie = Cat.new('Barnie')

# However, without getter and/or setter methods we have no way to interact
# with the instance variable
# Because the scope of instance variables is at the object level,
# instance variables are available throughout an object's instance
# methods, regardless of which method initializes a given instance variable

class Cat
  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def name=(name)
    @name = name
  end
end

barnie = Cat.new('Barnie')
puts barnie.name # "Barnie"

# to demonstrate the individuality of instance variables for each object
whiskers = Cat.new('Whiskers')
# each instance has its own `@name` variable referencing a different string
puts barnie.inspect
puts whiskers.inspect

# referencing an instance variable that is not initialized will evalutate to
# `nil`
class Dog
  def name
    @name
  end
end

sparky = Dog.new
puts sparky.name.inspect

# how sub-classing affects instance variables: inherited methods can
# initialize instance variables in the sub-class
class Animal
  def initialize(name)
    @name = name
  end
end

class Mouse < Animal
  def speak
    puts "#{@name} squeaks!"
  end
end

fievel = Mouse.new('Fievel')
fievel.speak

# an instance method must initialize an instance variable before it will
# exist in an object. Inheriting an `initialize` method can obscure this
class Computer
  def make
    @make
  end

  def make=(make)
    @make = make
  end
end

class Laptop < Computer
end

lenovo = Laptop.new
puts lenovo.make.inspect # nil
lenovo.make = "Lenovo"
puts lenovo.make.inspect # "Lenovo"

# with modules, as with classes, it is instance methods rather than
# instance variables that are inherited
module Nameable
  def name
    @name
  end

  def name=(name)
    @name = name
  end
end

class Person
  include Nameable
end

joe = Person.new
puts joe.name.inspect
joe.name = "Joe"
puts joe.name.inspect

# instance variables

class HotelCustomer
  attr_reader :name, :room_number

  def initialize(name, room_number)
    @name = name
    @room_number = room_number
  end

  def change_room(new_room_number)
    @room_number = new_room_number
  end

  def display_details
    puts "#{@name} is staying in room #{@room_number}."
  end
end

customer = HotelCustomer.new("Fred Williams", 13)
customer.display_details
customer.change_room(15)
customer.display_details