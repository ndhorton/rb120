module FourWheeler
  WHEELS = 5
end

class Vehicle
  def maintenance
    "Changing #{WHEELS} tires"
  end
end

class Car < Vehicle
  include FourWheeler

  def wheels
    WHEELS
  end
end

car = Car.new
puts car.wheels      # => 4
puts car.maintenance # => NameError: uninitialized constant Vehicle::WHEELS

