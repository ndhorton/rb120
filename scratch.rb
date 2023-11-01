class Point
  attr_reader :x
  attr_reader :y
  attr_reader :z
  
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end
end

point = Point.new(0, 0, 0)

puts point.x
puts point.y
puts point.z

