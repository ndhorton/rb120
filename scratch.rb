class MyCar
  attr_accessor :speed, :color
  attr_reader :year

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up(number)
    self.speed += number
    puts "You push the gas and accelerate #{number} mph."
  end
  
  def brake(number)
    self.speed -= number
    puts "You push the brake and decelerate #{number} mph."
  end

  def shut_off
    self.speed = 0
    puts "Let's park this bad boy!"
  end

  def current_speed
    puts "You are going #{speed} mph."
  end

  def spray_paint(color)
    self.color = color
    puts "Your car is now a striking shade of #{color}"
  end

  def to_s
    "My car is a #{@color} #{@year} #{@model}"
  end
end

chevy = MyCar.new('2013', 'red', 'Lumina')
puts chevy