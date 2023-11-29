# Top-level scope is only lexically searched *after* Ruby
# has searched the inheritance hierarchy

class Vehicle
  WHEELS = 4
end

WHEELS = 6

class Car < Vehicle
  def wheels
    WHEELS
  end
end

car = Car.new
puts car.wheels        # => 4

# But enclosing lexical contexts *other than top-level*
# are searched *before* the inheritance hierarchy

module Things
  class Vehicle
    WHEELS = 4
  end

  WHEELS = 6

  class Car < Vehicle
    def wheels
      WHEELS
    end
  end
end

car = Things::Car.new
puts car.wheels       # => 6
