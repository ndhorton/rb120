# Nobility

# 1) Have Noble inherit from Person. Changes to every class and the Walkable module
# module Walkable
#   def walk
#     puts "#{moniker} #{gait} forward"
#   end
# end

# class Person
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def moniker
#     name
#   end

#   private

#   def gait
#     "strolls"
#   end
# end

# class Noble < Person
#   attr_accessor :name, :title

#   def initialize(name, title)
#     super(name)
#     @title = title
#   end

#   def moniker
#     "#{title} #{name}"
#   end
#
#   private

#   def gait
#     "struts"
#   end
# end

# class Cat
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def moniker
#     name
#   end

#   private

#   def gait
#     "saunters"
#   end
# end

# class Cheetah
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def moniker
#     name
#   end

#   private

#   def gait
#     "runs"
#   end
# end

# 2)
# module Walkable
#   def walk
#     puts "#{name} #{gait} forward"
#   end
# end

# module NobleWalkable
#   def walk
#     puts "#{title} #{name} #{gait} forward"
#   end
# end

# class Person
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   private

#   def gait
#     "strolls"
#   end
# end

# class Noble
#   include NobleWalkable

#   attr_accessor :name, :title

#   def initialize(name, title)
#     @name = name
#     @title = title
#   end

#   private

#   def gait
#     "struts"
#   end
# end

# class Cat
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   private

#   def gait
#     "saunters"
#   end
# end

# class Cheetah
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   private

#   def gait
#     "runs"
#   end
# end

# LS solution
# module Walkable
#   def walk
#     puts "#{self} #{gait} forward"
#   end
# end

# class Person
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def to_s
#     name
#   end

#   private

#   def gait
#     "strolls"
#   end
# end

# class Noble
#   include Walkable

#   attr_accessor :name, :title

#   def initialize(name, title)
#     @name = name
#     @title = title
#   end

#   def to_s
#     "#{title} #{name}"
#   end

#   private

#   def gait
#     "struts"
#   end
# end

# class Cat
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def to_s
#     name
#   end

#   private

#   def gait
#     "saunters"
#   end
# end

# class Cheetah
#   include Walkable

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def to_s
#     name
#   end

#   private

#   def gait
#     "runs"
#   end
# end

# Further exploration
module Walkable
  def walk
    puts "#{name} #{gait} forward"
  end
end

class Person
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def walk
    "#{title} #{name} #{gait} forward"
  end

  private
  
  def gait
    "struts"
  end
end

class Cat
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
mike.walk

kitty = Cat.new("Kitty")
kitty.walk

flash = Cheetah.new("Flash")
flash.walk

# byron = Noble.new("Byron", "Lord")
# byron.walk
# p byron.name
# p byron.title
