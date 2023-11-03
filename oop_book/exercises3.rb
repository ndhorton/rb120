# 1) and 2)
# class MyCar
  # attr_accessor :year, :model, :color
# 
  # def initialize(year, model, color)
    # self.year = year
    # self.model = model
    # self.color = color
  # end
# 
  # def self.gas_mileage(miles, gallons)
    # "#{miles.fdiv(gallons)} miles per gallon of gas"
  # end
# 
  # def to_s
    # "This car is a #{year} #{color} #{model}"
  # end
# end
# 
# puts MyCar.gas_mileage(10, 4)
# car = MyCar.new(2012, 'Toyota Lemur', 'green')
# puts car

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"