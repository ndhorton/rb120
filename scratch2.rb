module Inflatable
  WHEELS = 4
end

class Car
  include Inflatable

  def inflate
    puts "You've inflated the tires on all #{WHEELS} wheels."
  end
end

c = Car.new
c.inflate