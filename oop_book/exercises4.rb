class Vehicle
  @@number_of_vehicles = 0
  attr_reader :year, :model
  attr_accessor :color

  def self.number_of_vehicles
    @@number_of_vehicles
  end

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @speed = 0
    @@number_of_vehicles += 1
  end

  def accelerate(speed)
    self.speed += speed
  end

  def decelerate(speed)
    self.speed -= speed
  end

  def shut_down
    self.speed = 0
  end

  def spray_paint(color)
    self.color = color
    "Your new #{color} paintjob looks great!"
  end

  def gas_mileage(gallons, miles)
    "Your mileage is #{gallons.fdiv(miles).round(2)} gallons per mile."
  end

  def age
    "Your #{model} is #{years_old} years_old"
  end

  private

  def years_old
    Time.now.year - year
  end

  attr_accessor :speed
end

module Towable
  def tow(vehicle)
    "You hook up the #{vehicle.model} and can now tow it."
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
  @@number_of_cars = 0
 
  def self.number_of_cars
    @@number_of_cars
  end

  def initialize(year, model, color)
    super
    @@number_of_cars += 1
  end
end

class Truck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2
  @@number_of_trucks = 0

  def initialize(year, model, color)
    super
    @@number_of_trucks += 1
  end

  def self.number_of_trucks
    @@number_of_trucks
  end
end

class Student
  attr_reader :name

  def initialize(name, grade)
    self.name = name
    self.grade = grade
  end

  def better_grade_than?(other)
    self.grade > other.grade
  end

  protected

  attr_accessor :grade

  private

  attr_writer :name
end

# puts "Vehicles to start: #{Vehicle.number_of_vehicles}"

# my_car = MyCar.new(2014, 'Ford Fiesta', 'blue')
# my_truck = Truck.new(2015, 'Toyota Camarero', 'red')

# puts "Trucks: #{Truck.number_of_trucks}"
# puts "Cars: #{MyCar.number_of_cars}"

# puts my_truck.tow(my_car)

# puts "Vehicles at end: #{Vehicle.number_of_vehicles}"

# puts "Vehicle lookup path:"
# puts Vehicle.ancestors

# puts
# puts "MyCar lookup path:"
# puts MyCar.ancestors

# puts
# puts "Truck lookup path:"
# puts Truck.ancestors

# puts my_car.spray_paint('puce')
# puts my_car.gas_mileage(34, 29)

# puts my_car.age
# puts my_truck.age

bob = Student.new('Bob', 83)
joe = Student.new('Joe', 96)
puts "Well done, #{joe.name}" if joe.better_grade_than?(bob)

# 8) the problem is that you have attempted to call a private method from outside the class
# to fix it, you would simply move the `Person#hi` method outside of the group of private members
# above the call to `Module#private`