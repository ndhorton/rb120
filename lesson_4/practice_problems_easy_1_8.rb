class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# `self` here refers to the class, since it is used
# at the class level, and in this context is used
# to define a class method.