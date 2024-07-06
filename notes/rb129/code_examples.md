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

