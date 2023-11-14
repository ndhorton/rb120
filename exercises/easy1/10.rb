# Refactoring Vehicles

=begin

P:
  Refactor the classes so that they all inherit from a common superclass
  and inherit behaviour as needed

Notes:

all kinds of Vehicle
Car and Motorcycle have constructors that require arguments for `@make` and `@model`
Truck has these, but in addition, needs an argument for `@payload`

Again, Car and Motorcycle require getter methods for `@make` and `@model`
while Truck needs an additional getter for `@payload`

Every class has a `#wheels` method that returns a constant. You could move the method
to the superclass and have it return a CONSTANT rather than an immediate value
The problem with this is that this requires a default number of wheels for
the superclass itself(????) I'm going to go with 4 as the average

The `#to_s` method is identical in every class so can be simply moved to superclass

=end

class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  def wheels
    4
  end
end

class Motorcycle < Vehicle
  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end



# Further explorations
# The problem, as outlined above, is that you need some
# kind of NUMBER_OF_WHEELS definition in the superclass if you
# want to instantiate objects of the superclass
# Some vehicles don't even have wheels (hovercraft, monorail train, boat, helicopter, etc)

# The advantage is that you eliminate magic numbers,
# but contextually, the meaning of those numbers is almost as obvious
# from the given method name (and one could simply make the method name more
# specific). So the only real advantage is slightly less repitious code (by eliminating two keywords)

class Vehicle
  NUMBER_OF_WHEELS = 4

  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def wheels
    NUMBER_OF_WHEELS
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  NUMBER_OF_WHEELS = 4
end

class Motorcycle < Vehicle
  NUMBER_OF_WHEELS = 2
end

class Truck < Vehicle
  NUMBER_OF_WHEELS = 6

  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end
end

vehicle = Vehicle.new('Ford', 'Mustang')
puts vehicle.wheels # Without the constant definition, this raises a `NameError`