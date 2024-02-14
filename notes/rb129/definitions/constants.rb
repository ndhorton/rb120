# constants can be used to give names to fixed values used by a class
# constants are variables that you do not want to change
# class Circle
#   PI = 3.14159

#   def initialize(radius)
#     @radius = radius
#   end

#   def area
#     PI * @radius * @radius # Ruby searches the lexically-enclosing structure
#   end                      # to find a constant definition for `PI` -- the
#                            # structure is the `Circle` definition, lines 3-17
#   def perimeter
#     PI * 2 * @radius
#   end
# end

# circle = Circle.new(5)
# puts circle.area
# puts circle.perimeter

# # client code can access constants from outside a class using the namespace
# # resolution operator `::`
# puts Circle::PI # 3.14159

# the lexical search can broaden to any other lexically-enclosing structures
# around the reference, up to but not including top-level
module Geometry
  PI = 3.14159

  class Circle
    def initialize(radius)
      @radius = radius
    end

    def perimeter
      2 * PI * @radius # cannot find PI in Geometry::Circle, so Ruby searches Geometry
    end
  end
end

circle2 = Geometry::Circle.new(9)
puts circle2.perimeter

# if Ruby cannot find a constant during the lexical search, it begins
# searching the class hierarchy of the lexically-enclosing structure of the
# reference
# class Shape
#   PI = 3.14159
# end

# class Circle < Shape
#   def initialize(radius)
#     @radius = radius
#   end

#   def area
#     (@radius ** 2) * PI # cannot be found lexically so Ruby searches class hierarchy and finds `PI` in `Shape`
#   end
# end

# circle3 = Circle.new(5)
# puts circle3.area

# however, it is important to understand that Ruby begins the class hierarchy search
# from the lexically-enclosing class or module, not from the class of the object
# on which a method containing a constant reference is called
# class Vehicle
#   def number_of_wheels
#     WHEELS # the class hierarchy search starts from `Vehicle` not `Car`
#   end
# end

# class Car < Vehicle
#   WHEELS = 4 # so the inherited `number_of_wheels` method will not be able to reference this constant definition
# end

# car = Car.new
# puts car.number_of_wheels # NameError

# In order to address problems like the above, we can use a dynamic method of constant reference
class Vehicle
  def number_of_wheels
    self.class::WHEELS
  end
end

class Car < Vehicle
  WHEELS = 4
end

car = Car.new
puts car.number_of_wheels # 4