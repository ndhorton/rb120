Classes and Objects

Instantiation

```ruby
class GoodDog
end

sparky = GoodDog.new
```

```ruby
class GoodDog
  def initialize
    puts "This object was initialized!"
  end
end

sparky = GoodDog.new        # => "This object was initialized!"
```

Attributes

```ruby
class Laptop
  def initialize(memory)
    @memory = memory
  end

  def memory
    @memory
  end

  def memory=(memory)
    @memory = memory
  end
end

laptop = Laptop.new('8GB')
laptop.memory # '8GB'
laptop.memory = '16GB'
laptop.memory # '16GB'
```

Simple class with setter and getter

```ruby
class Person
  attr_accessor :name

  def initialize(n)
    @name = n
  end
end
```



Class Variables and Class methods

```ruby
class Cat
  @@number_of_cats = 0

  def initialize
    @@number_of_cats += 1
  end

  def self.total
    puts @@number_of_cats
  end
end

kitty1 = Cat.new
kitty2 = Cat.new

Cat.total
```



Constants

```ruby
class Cat
  COLOR = 'orange'

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name} and I'm a #{COLOR} cat!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
```



Method access control

Private

```ruby
class Person
  attr_writer :secret

  def share_secret
    puts secret
  end

  private

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret
person1.secret # => private method `secret' called for #<Person:0x007fef1986ac08 @secret="Shh.. this is a secret!"> (NoMethodError)
```

Protected

```ruby
class Person
  attr_writer :secret

  def compare_secret(other)
    secret == other.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

person3 = Person.new
person3.secret = 'Shh.. this is a secret!'

puts person1.compare_secret(person2) # false
puts person1.compare_secret(person3) # true
```







Self

```ruby
class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def identify
    self
  end
end

kitty = Cat.new('Sophie')
p kitty.identify # '<Cat:0x... @name="Sophie">'
```

```ruby
class Selfish
  attr_accessor :value
  
  def self.identify_class # class method defintion
    self # references class
  end
  
  def identify_object
    self # references calling object
  end
  
  def set_value(value)
    self.value = value # setter method invocation
  end
end

puts Selfish.identify_class # Selfish

selfish = Selfish.new
selfish.set_value("I'm a Selfish object")
p selfish.identify_object # <Selfish:0x... @value="I'm a Selfish object"> 
```



Polymorphism

Polymorphism through class inheritance

```ruby
class Animal
  def move
  end
end

class Fish < Animal
  def move
    puts "swim"
  end
end

class Cat < Animal
  def move
    puts "walk"
  end
end

# Sponges and Corals don't have a separate move method - they don't move
class Sponge < Animal; end
class Coral < Animal; end

animals = [Fish.new, Cat.new, Sponge.new, Coral.new]
animals.each { |animal| animal.move }
```

```ruby
# mine
class Vehicle
  def start
    puts "Starting engine..."
  end
end

class Car < Vehicle; end

class Truck < Vehicle; end

class Speedboat < Vehicle
  def start
    puts "Starting outboard motor..."
  end
end

vehicles = [Car.new, Truck.new, Speedboat.new]
vehicles.each { |vehicle| vehicle.start }
```







Polymorphism through mixin modules

```ruby
module Coatable
  def coating
    "I'm covered in chocolate"
  end
end

class JaffaCake
  include Coatable         # mixing in Coatable module
end

class Raisin
  include Coatable         # mixing in Coatable module
end

snacks = [JaffaCake.new, Raisin.new]
snacks.each { |snack| puts snack.coating }
```

```ruby
# mine

module Climbable
  def climb
    puts "I'm climbing..."
  end
end

class Cat
  include Climbable
end

class Mountaineer
  include Climbable
end

climbers = [Cat.new, Mountaineer.new]
climbers.each { |climber| climber.climb }
```





Polymorphism through Duck Typing

```ruby
class Wedding
  attr_reader :guests, :flowers, :songs

  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_wedding(self)
    end
  end
end

class Chef
  def prepare_wedding(wedding)
    prepare_food(wedding.guests)
  end

  def prepare_food(guests)
    #implementation
  end
end

class Decorator
  def prepare_wedding(wedding)
    decorate_place(wedding.flowers)
  end

  def decorate_place(flowers)
    # implementation
  end
end

class Musician
  def prepare_wedding(wedding)
    prepare_performance(wedding.songs)
  end

  def prepare_performance(songs)
    #implementation
  end
end
```

```ruby
class Duck
  def fly
    flap_wings
  end
  
  def flap_wings
  end
end

class Airplane
  def fly
    start_engines
  end
  
  def start_engines
  end
end

flyers = [Duck.new, Airplane.new]

flyers.each { |flyer| flyer.fly }
```

