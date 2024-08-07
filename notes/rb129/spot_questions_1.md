1.

```ruby
class Person
  attr_reader :name
  
  def set_name
    @name = 'Bob'
  end
end

bob = Person.new
p bob.name


# What is output and why? What does this demonstrate about instance variables that differentiates them from local variables?
```

We define a `Person` class on lines 1-7. We generate a `Person#name` getter method with a call to `attr_reader` on line 2. We define a `Person#set_name` method on lines 4-6 that sets instance variable `@name` to `"Bob"`.

On line 9, we initialize local variable `bob` to a new `Person` object.

On line 10, we call `Person#name` setter method on `bob` and pass the return value to `Kernel#p` to be output. The output is `nil`.

The reason for this is that, since we have not called `set_name` on `bob`, we have not initialized the `@name` variable that the `name` method acts as a getter method for.

When we reference an uninitialized instance variable in Ruby, the reference evaluates to to `nil` (without the variable being initialized to `nil`). This is in contrast to references to uninitialized local variables, which will raise a `NameError` exception.

4m39s

2.

```ruby
module Swimmable
  def enable_swimming
    @can_swim = true
  end
end

class Dog
  include Swimmable

  def swim
    "swimming!" if @can_swim
  end
end

teddy = Dog.new
p teddy.swim   


# What is output and why? What does this demonstrate about instance variables?
```

On lines 1-5 we define a `Swimmable` module containing one instance method `enable_swimming`. The body of this method sets a `@can_swim` instance variable to `true`.

On lines 7-13, we define a `Dog` class that mixes in the `Swimmable` module. We define `Dog#swim` on lines 10-12. Within the body of the method, an `if` modifier uses the instance variable `@can_swim` as a conditional. If `@can_swim` references a truthy object, the method returns the String `"swimming!"`. Otherwise the method returns `nil`, since an `if` clause with no successful condition returns `nil`.

On line 15, we initialize local variable `teddy` to a new `Dog` object.

On line 16, we call the `swim` method on `teddy` and pass the return value to `Kernel#p` to be output. The output is `nil`.

This is because the `@can_swim` instance variable has not been initialized in `teddy`. The only method available to initialize it, `enable_swimming`, has not been called on `teddy`. Therefore the reference to `@can_swim` on line 11 in the `if` modifier is a reference to an uninitialized instance variable, and such a reference always returns `nil`. `nil` is the only other object in Ruby other than `false` that is considered falsey, so `swim` returns `nil`.

This demonstrates that an instance variable is only initialized in an object once a method that initializes it has actually been called on the object. This code also demonstrates that uninitialized instance variables evaluate to `nil`.

8m02s

3.

```ruby
module Describable
  def describe_shape
    "I am a #{self.class} and have #{SIDES} sides."
  end
end

class Shape
  include Describable

  def self.sides
    self::SIDES
  end
  
  def sides
    self.class::SIDES
  end
end

class Quadrilateral < Shape
  SIDES = 4
end

class Square < Quadrilateral; end

p Square.sides 
p Square.new.sides 
p Square.new.describe_shape 


# What is output and why? What does this demonstrate about constant scope? What does `self` refer to in each of the 3 methods above? 
```

On line 25, we call a `sides` method directly on the `Square` class (defined on line 23), so this is a class method call. `Square` inherits the class method `Shape::sides` defined on linnes 10-12. The method definition body returns the result of the expression `self::SIDES`. The `self` keyword within a class method references the class on which the method is called, in this case the `Square` class. The namespace operator `::` is used to reference the `SIDES` constant in the `Square` class. Since there is no such constant defined there, Ruby searches the inheritance chain of `Square` and finds a definition of `SIDES` in `Quadrilateral` (lines 19-21), the immediate superclass of `Square`. The return value of this call to `Square::sides` is therefore `4`, and this is passed to `Kernel#p` to be output.

On line 26, we instantiate a new `Square` object, call the instance method `sides` on it, and pass the return value to `p` to be output. `Square` inherits instance method `Shape#sides` (lines 14-16), which returns the result of the expression `self.class::SIDES`. Here, keyword `self` references the calling instance, since we are within an instance method. Calling `class` on the calling object returns `Square` and the namespace operator is used as before to reference `Square::SIDES`, with the same constant resolution as before: `4`.

On line 27, the instance method `describe_shape` is called on a new `Square` instance. This call raises a `NameError`. This instance method is inherited from the `Describable` module (lines 1-5) which has been mixed into the `Shape` class. The reason that we raise an exception is that `describe_shape` returns a string involving interpolation of the unqualified constant reference `SIDES` (line 3). When a constant is referenced without qualification, Ruby searches lexically of the reference, in the lexically-enclosing structures in the source code that surround the reference in the source code, up to but not including top-level. Ruby does not find a `SIDES` definition in the lexical search. Ruby then searches the inheritance hierarchy of the lexically enclosing structure, the `Describable` module. However, `Describable` is not a class and does not include any other modules. Ruby searches top-level but finds no constant `SIDES` defined there either. At this point the `NameError` is raised.

This demonstrates the difference in lookup between an unqualified constant reference and a namespace-qualified constant reference. For an unqualified reference, Ruby first searches lexically of the reference, then the inheritance hierarchy of the lexically-enclosing structure immediately surrounding the reference, then top-level. In the case of a namespace-qualified constant reference, Ruby searches the named module or class (without a lexical search of enclosing structures), then the inheritance hierarchy of the named module or class.

14m15s

4.

```ruby
class AnimalClass
  attr_accessor :name, :animals
  
  def initialize(name)
    @name = name
    @animals = []
  end
  
  def <<(animal)
    animals << animal
  end
  
  def +(other_class)
    animals + other_class.animals
  end
end

class Animal
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

mammals = AnimalClass.new('Mammals')
mammals << Animal.new('Human')
mammals << Animal.new('Dog')
mammals << Animal.new('Cat')

birds = AnimalClass.new('Birds')
birds << Animal.new('Eagle')
birds << Animal.new('Blue Jay')
birds << Animal.new('Penguin')

some_animal_classes = mammals + birds

p some_animal_classes 


# What is output? Is this what we would expect when using `AnimalClass#+`? If not, how could we adjust the implementation of `AnimalClass#+` to be more in line with what we'd expect the method to return?
```

We define an `AnimalClass` class on lines 1-16. On lines 18-24, we define an `Animal` class. The role of the `AnimalClass` is as a collection class for `Animal` objects. An `AnimalClass` object uses an Array to store `Animal` objects, tracked by the instance variable `@animals` initialized in the `AnimalClass#initialize` constructor on line 6. The `AnimalClass#<<` instance method defined on lines 9-11 takes an `animal` as argument and stores it in the `@animals` array.

On lines 26 - 29, we initialize local variable `mammals` to a new `AnimalClass` object and store various `Animal` objects in it using the `<<` method.

On lines 31, we do the same again with local variable `birds`.

On line 36, we initialize local variable `some_animal_classes` to the result of calling `AnimalClass#+` on `mammals` with `birds` passed as argument.

On line 38, we pass `some_animal_classes` to `Kernel#p` to be output. The output will be similar to `[#<Animal:0x00007fe716d29768 @name="Human">, #<Animal:0x00007fe716d29650 @name="Dog">, #<Animal:0x00007fe716d295d8 @name="Cat">, #<Animal:0x00007fe716d29498 @name="Eagle">, #<Animal:0x00007fe716d293d0 @name="Blue Jay">, #<Animal:0x00007fe716d29358 @name="Penguin">]`. (The object ids will vary).

This is unexpected behavior for a `+` method, since the class of the object returned by `AnimalClass#+` is not a new `AnimalClass` object, which is conventional for `+` methods, but rather an Array object.

The `+` method is conventionally defined to perform an operation analogous to either addition or concatenation, and conventionally returns a new object of the calling object's class. When defining custom fake operator methods it is vital to respect convention or our code will be more difficult rather than easier to read, and our classes will be harder to use.

We can rectify this by making changes to the `AnimalClass` constructor to permit instantiating a new object with an existing array of `Animal` objects, and then changing the `AnimalClass#+` method to return a new `AnimalClass` object:
```ruby
class AnimalClass
  attr_accessor :name, :animals
  
  def initialize(name, animals = [])
    @name = name
    @animals = animals
  end
  
  def <<(animal)
    animals << animal
  end
  
  def +(other_class)
    AnimalClass.new("temporary name", animals + other_class.animals)
  end
end

class Animal
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

mammals = AnimalClass.new('Mammals')
mammals << Animal.new('Human')
mammals << Animal.new('Dog')
mammals << Animal.new('Cat')

birds = AnimalClass.new('Birds')
birds << Animal.new('Eagle')
birds << Animal.new('Blue Jay')
birds << Animal.new('Penguin')

some_animal_classes = mammals + birds

p some_animal_classes 
```

10m11s



5.

```ruby
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def change_info(n, h, w)
    name = n
    height = h
    weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end
end


sparky = GoodDog.new('Spartacus', '12 inches', '10 lbs') 
sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info 
# => Spartacus weighs 10 lbs and is 12 inches tall.


# We expect the code above to output `”Spartacus weighs 45 lbs and is 24 inches tall.”` Why does our `change_info` method not work as expected?
```

The reason our `GoodDog#change_info` method does not work as expected has to do with the syntax for invoking setter methods within the class.

When an instance method is called within another instance method definition within the same class, we can invoke the instance method without an explicit caller or the dot operator. The implicit caller will be the calling object.

However, with setter methods whose names end in `=`, this does not work, since the syntax cannot be disambiguated from the initialization of a local variable. Therefore, within the `change_info` method on line 11, when we attempt to set the instance variable `@name` using the setter method `name=` generated by the call to `Module#attr_accessor` on line 2, we instead initialize a new local variable called `name`.

This is also true for local variables `height` and `weight` on lines 12-13.

Setter methods must always have an explicit caller in order to disambiguate the syntax. When we wish to call a setter method within the class on the calling object, we can use the keyword `self` to explicitly reference the calling object (e.g. `self.name = n`).

Therefore, to make the `change_info` method work as intended, we can change it as follows:

```ruby
 # rest of class omitted ...
  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end
# ...
```

6m26s

6.

```ruby
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
  
  def change_name
    name = name.upcase
  end
end

bob = Person.new('Bob')
p bob.name 
bob.change_name
p bob.name


# In the code above, we hope to output `'BOB'` on `line 16`. Instead, we raise an error. Why? How could we adjust this code to output `'BOB'`? 
```

The reason the above code raises a `NoMethodError` has to do with the way Ruby evaluates expressions involving the initialization of a new local variable, and the syntax for setter methods.

Most instance methods can be invoked from within other instance methods of the class implicitly on the calling object simply by invoking the method without an explicit caller (and without the dot operator). Setter methods cannot be called like that because the syntax for attempting this cannot be disambiguated from the initialization of a new local variable.

So within the `Person#change_name` method, on line 9, the expression `name = name.upcase` initializes a new local variable rather than calling the setter method `Person#name=`.

This has the further consequence that Ruby attempts to call `upcase` on `nil`. The reason for this has to do with how Ruby evaluates assignment expressions. The `name =` part of this line tells Ruby that we are initializing a new local variable called `name`, which is temporarily assigned the value `nil`. Next Ruby looks at the expression on the right hand side, `name.upcase`. The identifier `name` already refers to the local variable we are initializing, shadowing the `Person#name` getter method, and so `name` evaluates to the temporary value `name` has been assigned, which is `nil`. Ruby then attempts to call the `upcase` method on the `nil` object, resulting in a `NoMethodError`.

We can fix this code simply by changing line 9 to `self.name = name.upcase`. We need to prefix the setter method call `name=` with `self` and the dot operator. `self` within an instance method references the calling object, and we can then call the setter method explicitly on the calling object, which is necessary to disambiguate the syntax from local variable initialization.

9m53s

7.

```ruby
class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

p Vehicle.wheels                             

class Motorcycle < Vehicle
  @@wheels = 2
end

p Motorcycle.wheels                           
p Vehicle.wheels                              

class Car < Vehicle; end

p Vehicle.wheels
p Motorcycle.wheels                           
p Car.wheels     


# What does the code above output, and why? What does this demonstrate about class variables, and why we should avoid using class variables when working with inheritance?
```

We define a `Vehicle` class on lines 1-7. On line 2, within the class but outside any method definition we initialize a `@@wheels` class variable to `4`. This line is executed as soon as the class is evaluated. We also define a `Vehicle::wheels` class method that returns the reference of `@@wheels`.

On line 9, we call `wheels` on `Vehicle` and output the return value with `Kernel#p`, which is `4`.

On lines 11-13 we define a `Motorcycle` class as a subclass of `Vehicle`. On line 12, we reassign class variable `@@wheels` to `2`. Class variables are not inherited. Rather, a class variable initialized in a class will be shared with all descendant classes, as well as with all instances of those classes. This greatly expanded scope is why Rubyists advise against using class variables with inheritance. It becomes difficult to reason about where in the codebase we are making changes to a class variable, in a similar way to global variables.

On line 15, we output the return value of calling `Vehicle::wheels` on `Motorcycle` with the `p` method, which outputs `2`. When we call `wheels` on `Vehicle` on the next line and pass the return value to `p`, this also outputs `2`, which is unlikely to be what we want.

On line 18, we define a `Car` class as another subclass of `Vehicle`.

On lines 20-22, we call `wheels` on `Vehicle`, `Motorcycle`, and `Car`, passing each return value to the `p` method to be output. All three calls return `2`, since the same class variable is shared between all three classes.

This code demonstrates the difficulty of reasoning about class variables when inheritance is involved, and why Rubyists advice against using class variables in classes with descendant subclasses.

7m57s

8.

```ruby
class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

bruno = GoodDog.new("brown")       
p bruno


# What is output and why? What does this demonstrate about `super`?
```

The output will be similar to `<GoodDog:0x... @name="brown", @color="brown">`. The reason that both instance variables are assigned the same string has to do with the `super` keyword.

On line 16, we initialize a new `GoodDog` object, passing the String `"brown"` through to the constructor.

We defined an `Animal` class on lines 1-7. The `initialize` constructor takes one parameter `name` and uses this to initialize the instance variable `@name`.

The `GoodDog` class is defined as a subclass of `Animal` on lines 9-14. The `GoodDog#initialize` constructor overrides the superclass constructor, and takes one parameter `color`. On line 11, within the method definition body, we use the `super` keyword to call the method of the same name next along in the method lookup path, in this case `Animal#initialize`. When we use `super` without trailing parentheses we pass all arguments to the subclass method through to the superclass method, in this case the String assigned to `color`. The `Animal#initialize` method initializes instance variable `@name` to `"brown"`, the argument passed to the `GoodDog` constructor on line 16. Then after `Animal#initialize` returns, `GoodDog#initialize` initializes instance variable `@color` to the argument, `"brown"`, referenced by parameter `color`.

6m30s

9.

```ruby
class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super
    @color = color
  end
end

bear = Bear.new("black")        


# What is output and why? What does this demonstrate about `super`? 
```

This code will raise an `ArgumentError`.

On line 13, we initialize a new `Bear` object, passing the string `"black"` as argument through to the constructor.

We defined an `Animal` class on lines 1-4. The `Animal#initialize` method has no parameters.

We defined the `Bear` class as a subclass of `Animal` on lines 6-11. The `Bear#initialize` constructor is defined with one parameter, `color`, which on this invocation is set to `"black"`.

Within the method definition body, on line 8, we use the `super` keyword to call the method of the same name that is next in the method lookup path, in this case the superclass method `Animal#initialize`. When we use `super` without trailing parentheses, we pass all arguments to the subclass method through to the superclass method. Since `Bear#initialize` takes one argument, and the superclass method takes none, this means we are passing an argument to a method that doesn't take any, and so an `ArgumentError` is raised.

We can fix this by changing line 8 so that `super` is called with empty parentheses, like so: `super()`. This calls the superclass method with no arguments passed through to it.

5m21

10.

```ruby
module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

module Danceable
  def dance
    "I'm dancing."
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

module GoodAnimals
  include Climbable

  class GoodDog < Animal
    include Swimmable
    include Danceable
  end
  
  class GoodCat < Animal; end
end

good_dog = GoodAnimals::GoodDog.new
p good_dog.walk


# What is the method lookup path used when invoking `#walk` on `good_dog`?
```

When we invoke `walk` on a `GoodAnimals::GoodDog` object, `good_dog`, on line 45, the method lookup path Ruby searches is as follows.

Ruby first searches the class of the calling object, `GoodAnimals::GoodDog`. Since no `walk` method is found here, Ruby next searches the modules mixed in to the class in the reverse order of the calls to `Module#include` that mixed them in. So first Ruby searches `Danceable`, and then `Swimmable`. Since no `walk` method has been found, Ruby next searches the superclass, `Animal`.

Ruby finds no `walk` method in `Animal`, and so searches the included module, `Walkable`. Ruby finds a `walk` method defined here, and so calls the method on our `good_dog` object.

If Ruby had not found a method here, it would have gone on to search `Object`, `Kernel`, and `BasicObject` before raising a `NoMethodError`.

The full method lookup path could be found by calling the method `ancestors` on the `GoodAnimals::GoodDog` class. This would return the array `[GoodAnimals::GoodDog, Danceable, Swimmable, Animal, Walkable, Object, Kernel, BasicObject]`

5m59s



11.

```ruby
class Animal
  def eat
    puts "I eat."
  end
end

class Fish < Animal
  def eat
    puts "I eat plankton."
  end
end

class Dog < Animal
  def eat
     puts "I eat kibble."
  end
end

def feed_animal(animal)
  animal.eat
end

array_of_animals = [Animal.new, Fish.new, Dog.new]
array_of_animals.each do |animal|
  feed_animal(animal)
end


# What is output and why? How does this code demonstrate polymorphism? 
```

This code will output:

```ruby
I eat.
I eat plankton.
I eat kibble.
```

This code demonstrates polymorphism both in structure and in action.

Polymorphic structure is here applied through class inheritance.

We define an `Animal` class on lines 1-5. We define an `Animal#eat` instance method on lines 2-4, which passes the string `"I eat"` to the `Kernel#puts` method to be output to screen.

We define the `Fish` class (lines 7-11) and the `Dog` class (lines 13-17) as subclasses of `Animal`. This means that both subclasses inherit an `eat` method. Both subclasses choose to override `eat` with their own implementations, both of which agree with the superclass method in number of required parameters. This means that all three classes have a common interface, the `eat` method, that will permit objects of these classes to be used polymorphically. `Fish#eat` passes the string `"I eat plankton."` to `puts`, and `Dog#eat` passes the string `"I eat kibble."` to `puts`. Objects of all three classes can respond to a common interface in different ways.

We can see polymorphism in action below these class definitions.

We construct an `array_of_animals` on line 23, containing an `Animal` object, a `Fish` object, and a `Dog` object.

On lines 24-26, we call `each` on `array_of_animals` with a block. Each of the objects in the array is passed in turn to be assigned to block parameter `animal`. Within the block, we pass the object currently referenced by `animal` to the `feed_animal` method.

The `feed_animal` method is defined on lines 19-21 with one parameter `animal`. Within the body, on line 20, we call `eat` on `animal`. Neither the `each` block nor the `feed_animal` method care about the class or type of the objects they are passed. They simply care that the object implements a compatible `eat` method. Since we have structured our classes so that the types of object we pass to `feed_animals` share the common interface of an `eat` method, we can see polymorphism in action in the output to the screen. All three classes of object respond to the common interface in their own way. This combination of structuring our types to expose a common interface (in this example, through class inheritance), and writing our methods and blocks to take advantage of it, is how we implement polymorphism in Ruby.

10m58s

12.

```ruby
class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

class Pet
  def jump
    puts "I'm jumping!"
  end
end

class Cat < Pet; end

class Bulldog < Pet; end

bob = Person.new("Robert")

kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud                     

bob.pets.jump 


# We raise an error in the code above. Why? What do `kitty` and `bud` represent in relation to our `Person` object?  
```

We raise an error in the above code because we have attempted to call a `jump` method on an Array object, which does not have access to such a method.

We define a `Person` class on lines 1-8. The `Person#initialize` constructor initializes a `@pets` instance variable that uses an Array to track `Pet` objects. We generate getter and setter methods for `@pets` with a call to `Module#attr_accessor` on line 2.

We define the `Pet` class on lines 10-14. We define a `Pet#jump` instance method.

On line 16-18, we define a `Cat` class and a `Bulldog` class as subclasses of `Pet`.

On line 20, we initialize local variable `bob` to a new `Person` object. On line 22, we initialize local variable `kitty` to a new `Cat` object. On line 23, we initialize local variable `bud` to a `Bulldog` object.

On lines 25-26, we use the getter method `Person#pets` to return the `@pets` array of `bob`, and chain `Array#<<` to append `kitty` and `bud` to the array.

On line 28, we again call the `pets` method on `bob` and attempt to chain a call to `jump`, which raises a `NoMethodError` exception.

`kitty` and `bud` represent collaborator objects of `bob`. Any object that becomes part of another object's state is called a collaborator object. We call such objects collaborators because they assist the containing object in the fulfillment of its responsibilities. In the design phase, it is vitally important to consider which classes collaborate with which other classes, since collaborations represent the network of connections between actors in our programs.

Although the `@pets` instance variable tracks an Array object, which in turn tracks the `kitty` and `bud` objects, the most significant collaborations in the class design phase are between our custom classes themselves since these are the classes whose design we have control over. In this sense the Array class, though technically a collaborator of `Person` is more of an implementation detail for the more significant `Pet` collaborators.

However, we have clearly attempted to call the `Pet#jump` method on the Array object, since the Array is what is actually returned by the `pets` getter method.

In order to rectify this we can iterate over the array to call `jump` individually on `kitty` and `bud`:

```ruby
class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

class Pet
  def jump
    puts "I'm jumping!"
  end
end

class Cat < Pet; end

class Bulldog < Pet; end

bob = Person.new("Robert")

kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud                     

bob.pets.each { |pet| pet.jump } 
```

10m43s

13.

```ruby
class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def initialize(name); end

  def dog_name
    "bark! bark! #{@name} bark! bark!"
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name   


# What is output and why?
```

The `Animal` class is defined on lines 1-5. We define an `Animal#initialize` constructor with one parameter, `name`, which is used to initialize instance variable `@name`.

We define the `Dog` class on lines 7-13 as a subclass of `Animal`. We override the `initialize` method inherited from `Animal` with a method that still takes one parameter, `name`, but does nothing with it. This means that `Dog` objects will not initialize a `@name` instance variable when they are instantiated.

We define a `Dog#dog_name` method on lines 10-12. The body contains a string, `"bark! bark! #{@name} bark! bark!"`, into which we interpolate a reference to `@name`. Since there is no way to initialize the `@name` variable in our `Dog` class, this will be a reference to an uninitialized instance variable, which always evaluates to `nil`. When the string interpolation implicitly calls `to_s` on `nil`, the return value will be the empty string. This is why, when we call `dog_name` on a `Dog` object on line 16, and pass the return value to `Kernel#puts` to be output to screen, the output will be: `"bark! bark!  bark! bark!"`.

6m24s

14.

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

al = Person.new('Alexander')
alex = Person.new('Alexander')
p al == alex # => true


# In the code above, we want to compare whether the two objects have the same name. `Line 11` currently returns `false`. How could we return `true` on `line 11`? 

# Further, since `al.name == alex.name` returns `true`, does this mean the `String` objects referenced by `al` and `alex`'s `@name` instance variables are the same object? How could we prove our case?
```





The `==` method appears as an operator because of the syntactic sugar surrounding its invocation, but it is a method, a 'fake' operator. The `==` method is conventionally defined to compare the principal object value of the caller with the principal object value of the argument, usually an object of the same class as the caller, though not always. If the values are considered equivalent, `==` returns `true`, `false` otherwise.

In the code above, we define a `Person` class on lines 1-7. The `Person#initialize` constructor is defined with one parameter `name`, which it uses to initialize instance variable `@name` in the calling object. We generate a getter method `Person#name` for `@name` with a call to `Module#attr_reader` on line 2.

On line 9, we initialize local variable `al` to a new `Person` object, passing a String object in literal notation `"Alexander"` through to the constructor.

On line 10, we initialize local variable `alex` to a new `Person` object, passing another String object in literal notation with the same object value `"Alexander"`. Since this is again a string literal, this instantiates a new String object with the same value as the String object passed to the constructor of `al`, but they are not the identical String object. This could be demonstrated by comparing the object id of the `name` attribute of `alex` with the `name` attribute of `al` using the `Integer#==` method:

```ruby
al.name == alex.name # false
```

On line 11, we call `==` on `al` with `alex` passed as argument, passing  the return value to `Kernel#p` to be output to screen. This outputs `false`. The reason is that, since we have not overridden the inherited default `BasicObject#==` method, that will be the `==` method called.

The `BasicObject#==` method compares as the principal object value of caller and argument the object id of the two objects. Since an object id is unique to an object, if two objects have the same object id then they are the same object. This is of limited use, since the `equal?` method is conventionally used for this purpose. This is why most classes that are to be used in equivalency comparisons override this method.

If we wish to compare the `name` attributes of two `Person` objects for equivalency, we can simply define a `Person#==` method that returns `true` if the caller and argument have the same String value for their `name`.

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
  
  def ==(other_person)
    name == other_person.name
  end
end

al = Person.new('Alexander')
alex = Person.new('Alexander')
p al == alex # => true
```

Here, the work of the `==` method is pushed to the `String#==` method, since the `name` attribute tracks a String object. The `String#==` method compares two String objects' string values, returning `true` if both objects' string values have identical characters, `false` otherwise.

13m47s

14.

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

al = Person.new('Alexander')
alex = Person.new('Alexander')
p al == alex # => true


# In the code above, we want to compare whether the two objects have the same name. `Line 11` currently returns `false`. How could we return `true` on `line 11`? 

# Further, since `al.name == alex.name` returns `true`, does this mean the `String` objects referenced by `al` and `alex`'s `@name` instance variables are the same object? How could we prove our case?
```

The reason that line 11 outputs `false` is that we have not defined a `==` method in our `Person` class.

The `==` method is conventionally defined to compare the principal object value of the caller to that of the argument (usually an object of the same class), returning `true` if the object values are considered equivalent, `false` otherwise.

Since we have not overridden it with our own definition, the `==` method inherited by our `Person` class is the `BasicObject#==` method. `BasicObject#==` uses as the principal object value for comparison the object id of the caller and the argument, returning `true` if they have the same object id. Since an object's object id is unique, this means that `BasicObject#==` returns `true` only if caller and argument are the same object. This is why classes that are to be used with `==` override the method to provide a more meaningful value for equivalency comparison.

To make line 11 return `true`, we can implement a `==` method in our `Person` class that compares the `name` attribute of the caller with that of the argument:

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
  
  def ==(other)
    name == other.name
  end
end

al = Person.new('Alexander')
alex = Person.new('Alexander')
p al == alex # => true
```

Our `Person#==` method uses `String#==` to make the comparison between the `name` of the caller and argument. This does not mean that `al.name == alex.name` returning `true` means that the two String objects are identical. Rather, it means that two different objects instantiated by each use of literal notation (lines 9 and 11) have the same principal object value, the string values have the same characters.

We can demonstrate that they are not the same object using the `equal?` method, which returns `true` only if the caller and argument are the same object with the same object id:

```ruby
al.name.equal?(alex.name) # false
```

This will return `false` as they are not the same object.

10m57s



15.

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "My name is #{name.upcase!}."
  end
end

bob = Person.new('Bob')
puts bob.name
puts bob
puts bob.name


# What is output on `lines 14, 15, and 16` and why?
```

We define a `Person` class on lines 1-11. The `initialize` constructor is defined with one parameter, `name`, which it uses to initialize instance variable `@name`. We generate a getter method, `name`, with a call to `Module#attr_reader` on line 2.

On lines 8-10, we define a `Person#to_s` method. This method will be implicitly called if we pass a `Person` object to `Kernel#puts`. The body of the definition returns a string involving interpolation `"My name is #{name.upcase!}."`. This calls the destructive `String#upcase!` method on the string referenced by the `@name` instance variable, meaning the String object will be mutated if this method is called.

On line 13, we instantiate a new `Person` object, `bob`, passing the string `"Bob"` through to the constructor.

On line 14, we pass the return value of calling the getter `name` on `bob` to `puts`, outputting `"Bob"`.

On line 15, we pass `bob` to `puts` as an argument, implicitly calling the `Person#to_s` method. The output will be `"My name is BOB."`. Since the destructive `upcase!` method has been called on the String referenced by `bob.name`, that String object has now been mutated to `"BOB"`.

This mutation is demonstrated when the return value of calling `bob.name` is passed to `puts` on line 16, which outputs `"BOB"`.

6m44s

16.

```ruby
# Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example.
```

It is generally considered safer to use a setter method than setting an instance variable directly, within a class, since this isolates the logic for dealing with the variable in one place.

If we have several methods in a class that set an instance variable directly, then if we later wish to add a check on values before they are reassigned to the variable, we will need to make changes to all of these methods. This is both laborious and prone to error. If we have used a setter method, however, we only need to make changes to the setter method itself. Thus, the use of a setter method follows the DRY principle and makes code easier to maintain.

Similarly, the use of a method to set a variable means that the rest of our methods can be agnostic about the representation of the object, essentially reducing code dependencies within our class. We are free to split the data previously stored in a single instance variable so that it is tracked by two instance variables and this will not break existing code.

For instance, if we begin with a `Person` class that tracks a `name`:

```ruby
class Person
  def initialize(name)
    @name = name
  end
  
  def name
    @name
  end
  
  def name=(new_name)
    @name = new_name
  end
end

mike = Person.new("Michael Smith")
puts mike.name # "Michael Smith"
```

We can then decide to split the string tracked by `@name` into a `@first_name` and `@last_name` while keeping the interface the same:

```ruby
class Person
  def initialize(name)
    @first_name, @last_name = name.split
  end
  
  def name
    @first_name + ' ' + @last_name
  end
  
  def name=(new_name)
    @first_name, @last_name = new_name.split
  end
end

mike = Person.new("Michael Smith")
puts mike.name # "Michael Smith"
```

9m17s



17.

```ruby
# Give an example of when it would make sense to manually write a custom getter method vs. using `attr_reader`.
```

When we generate a getter method using `Module#attr_reader`, the method will be a simple getter that returns the reference of an instance variable (named as a Symbol argument passed to `attr_reader`).

Since we may wish our getter method to perform additional work rather than simply returning the reference of an instance variable, it is often necessary to write a custom getter method.

The work performed by a custom getter method will often involve manipulating the data tracked by the instance variable before returning it.

For instance, we might wish to store a name in a format that is suitable for database queries, but have our getter method return the name in a human-readable format:

```ruby
class Person
  def initialize(name)
    @name = name.upcase
  end
  
  def name
    @name.split.map(&:capitalize).join(' ')
  end
  
  # rest of class omitted ...
end

tom = Person.new("Thomas Jones")
puts tom.inspect # <Person:0x... @name="THOMAS JONES">
puts tom.name # "Thomas Jones"
```

6m53s

18.

```ruby
class Shape
  @@sides = nil

  def self.sides
    @@sides
  end

  def sides
    @@sides
  end
end

class Triangle < Shape
  def initialize
    @@sides = 3
  end
end

class Quadrilateral < Shape
  def initialize
    @@sides = 4
  end
end


# What can executing `Triangle.sides` return? What can executing `Triangle.new.sides` return? What does this demonstrate about class variables?
```

On lines 1-11 we define a `Shape` class. On line 2, within the class but outside any method definitions, we initialize class variable `@@sides` to `nil`. This will happen as soon as Ruby encounters the class definition. We define a class method `Shape::sides` on lines 4-6 that returns the current reference of `@@sides`. We define an instance method `Shape#sides` that returns the current reference of `@@sides`.

On lines 13-17, we define a `Triangle` class as a subclass of `Shape`. The `Triangle#initialize` constructor sets `@@sides` to `3`. Since this is an instance method, this will be executed only when a new `Triangle` is instantiated.

On lines 19-23, we define a `Quadrilateral` class as a subclass of `Shape`. The `Quadrilateral#initialize` constructor sets `@@sides` to `4`. Again, this will only happen if a `Quadrilateral` is instantiated.

Executing `Triangle.sides` can therefore return `nil`, `3`, or `4`, depending on context. `Triangle.new.sides` will always return `3`, since the `new` class method calls `Triangle#initialize` that sets the class variable `@@sides` to `3`, and then we call the instance method `sides` inherited from `Shape` on the newly created `Triangle` instance.

This demonstrates that class variables are scoped at the level of the class, all of its subclasses, and all the instances of all those classes. A class variable initialized in a class will be accessible to all of its subclasses and their instances. This greatly expanded scope is why many Rubyists advise against using class variables with inheritance.

8m06s

19.

```ruby
# What is the `attr_accessor` method, and why wouldn’t we want to just add `attr_accessor` methods for every instance variable in our class? Give an example.
```

The `Module#attr_accessor` takes one or more symbols as argumnets. For each symbol, simple getter and setter methods are generated for an instance variable of the name given as the symbol value.

For instance,

```ruby
class Person
  attr_acccessor :name
end
```

generates a `name` getter method and a `name=` setter method for the instance variable `@name`.

We do not generally want to use `attr_accessor` for every instance variable of a class for at least two reasons.

Firstly, since `attr_accessor` generates both getter and setter at the same level of method access control, it cannot be used if we wish to have, for instance, a `public` getter and a `private` setter.

Secondly, the methods generated by `attr_accessor` are simple getters and setters. So the example given above is equivalent to:

```ruby
class Person
  def name=(n)
    @name = n
  end
  
  def name
    @name
  end
end
```

If we need to add more logic to a setter, such as a check on the object passed as argument before it is permitted to be assigned to the variable, then we cannot use `attr_accessor`. Similarly, if we wish to manipulate or obscure data that is tracked by an instance variable before our getter returns it, then we cannot use `attr_accessor`.

For instance,

```ruby
class Person
  def initialize(name)
    @name = name
  end
  
  def name=(n)
    @name = n.capitalize
  end
  
  def name
    @name
  end
end

mike = Person.new("michael")
puts mike.name # "Michael"
```

Here, we want to make sure that the string passed to `name=` is capitalized before `@name` is set to it. This requires writing our own `name=` method rather than relying on `attr_accessor`

10m40s

20.

```ruby
# What is the difference between states and behaviors?
```

An object's state represents the data associated to that particular object via its instance variables, which are distinct to that object. An object's state is thus particular to an object and separate from the state of any other object.

The behaviors available to an object are predetermined by the class of the object and these behaviors are shared by all other objects of the class.

To demonstrate:
```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "meow!"
  end
end

fluffy = Cat.new("Fluffy")
tom = Cat.new("Tom")

fluffy.speak # "meow!"
tom.speak    # "meow!"

puts fluffy.inspect # <Cat:0x... @name="Fluffy">
puts tom.inspect    # <Cat:0x... @name="Tom">
```

Both `fluffy` and `tom` have access to the `Cat#speak` method as objects of class `Cat`. When we examine their `inspect` strings, we can see that their `@name` variables are separate since they track different String objects. Thus they share behavior but have different states.

5m55s



21.

```ruby
# What is the difference between instance methods and class methods?
```

Instance methods are defined in a class and are available to call on all instances of that class. To define an instance method within a class definition we use the `def` keyword followed by the name of the method, with the `end` keyword terminating the definition.

Class methods are defined on the class itself, and can only be called on the class itself. Class methods are defined similarly to instance methods but the keyword `self` is prepended to the name of the method with the dot operator. `self` here references the name of the class.

As an example,

```ruby
class Cat
  @@total_cats = 0
  
  def initialize
    @@total_cats += 1
  end
  
  def self.total_cats # class method
    @@total_cats
  end
  
  def speak # instance method
    puts "meow!"
  end
end

fluffy = Cat.new
fluffy.speak # meow!

puts Cat.total_cats # 1
```

4m19s



22.

```ruby
# What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.
```

Any object that becomes part of another object's state is a collaborator object. We call these collaborators because they can assist the containing object in carrying out its responsibilities. The relationship between an object and its collaborator objects is an associative relationship, a 'has-a' relationship.

An object becomes a collaborator of another object once it becomes part of that object's state, whether directly by being assigned to an instance variable, or indirectly through an intermediate object such as an Array.

It is important to think in terms of collaborations from the class design phase onwards, since collaborations represent the lines of communication of actors in our programs. If an object is part of another object's state, the containing object can easily invoke methods on its collaborators as part of its own instance methods.

Collaborator objects permit us to modularize the problem domain into separate but connected pieces, allowing us to break down the overall problem into smaller problems. Thinking in terms of collaborations between objects is thus a vital part of thinking in terms of objects; it is a vital part of object-oriented design and helps us model complicated problem domains.

Any class of object can be a collaborator object, including objects of custom classes.

For instance,

```ruby
class Car
  def initialize
    @engine = Engine.new
  end
  
  def start
    puts "Starting engine..."
    @engine.start
  end
end

class Engine
  def start
    puts "Engine started!"
  end
end

car = Car.new
car.start
# "Starting engine..."
# "Engine started!"
```

Here, we define a `Car` class (lines 1-10) and an `Engine` class (lines 12-16). When a `Car` object is instantiated, as on line 18, the `Car#initialize` constructor method (lines 2-4) initializes a new `Engine` object, which is used to initialize the `@engine` instance variable in the `Car` object. At this point, the `Engine` object has become a collaborator object of the `Car` object.

On line 19, the `Car#start` method (defined on lines 6-9) is called on the `Car` object. On line 8, we can see that the `Car` object makes use of the collaborator to fulfill the its responsibilities. Specifically, the `Car#start` method is able to call `Engine#start` on the `Engine` object because it is tracked by the `@engine` instance variable. The functionality of the collaborator object contributes toward the functionality of the containing object.



23.

```ruby
# How and why would we implement a fake operator in a custom class? Give an example.
```

Fake operators in Ruby are methods defined in classes like other methods that have syntactic sugar around their invocation to make them appear as operators. We can use fake operators to provide a familiar syntax for working with objects of a custom class. This can make our classes easier to use and our code easier to read.

It is important to respect the conventional meanings of operators when defining fake operator methods. For example, the `+` operator method is conventionally defined (in Ruby core classes and the standard library) to signify operations analogous to addition or concatenation. Defining the `+` method to do something else would be confusing for users of the class and make our code harder to read.

We define fake operator methods in much the same way as any other method. For example, we can define a `==` method to test for object value equivalence between objects of our custom class:

```ruby
class House
  attr_reader :address
  
  def initialize(address)
    @address = address
  end
  
  def ==(other)
    address == other.address
  end
end

house1 = House.new("23 Elm Drive")
house2 = House.new("23 Elm Drive")
house3 = House.new("17 Sycamore Lane")

puts house1 == house2 # true
puts house1 == house3 # false
```

We often push the work of our fake operator custom methods back onto the fake operator method defined by a core class, here the `String#==` method does the work in our `House#==` method.

7m55s

24.

```ruby
# What are the use cases for `self` in Ruby, and how does `self` change based on the scope it is used in? Provide examples.
```

The reference of keyword `self` depends on the scope in which it appears. In general, `self` within a class definition or class method definition references the class itself, while `self` used within an instance method definition references the calling object.

Within a class outside an instance method definition, `self` is most commonly used to define class methods.

Within instance method definitions, among other uses, `self` is commonly used as the explicit caller for setter methods in order to disambiguate the method call from the initialization of a new local variable.

For example,

```ruby
class Selfish
  attr_accessor :value
  
  def self.identify_class # class method defintion
    self
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

6m06s

25.

```ruby
class Person
  def initialize(n)
    @name = n
  end
  
  def get_name
    @name
  end
end

bob = Person.new('bob')
joe = Person.new('joe')

puts bob.inspect # => #<Person:0x000055e79be5dea8 @name="bob">
puts joe.inspect # => #<Person:0x000055e79be5de58 @name="joe">

p bob.get_name # => "bob"


 # What does the above code demonstrate about how instance variables are scoped?
```

The above code demonstrates that instance variables are scoped at the object level.

We define a `Person` class on lines 1-9. The `Person#initialize` constructor is defined with one parameter `n` which it uses to initialize the `@name` instance variable in the calling object at the moment it is instantiated. The `Person#get_name` method acts as a getter method for the `@name` instance variable.

On lines 11-12, we initialize two new `Person` objects `bob` and `joe`, passing a different string to each object's constructor.

On lines 14-15, the `inspect` strings demonstrate that each `Person` object has its own distinct `@name` instance variable, and each object's `@name` variable tracks a different string.

This is further confirmed when we pass the return value of calling `get_name` on `bob` on line 17. Also, although the `initialize` method initialized the `@name` instance variable in `bob`, the variable is accessible to all other instance methods that can be called on `bob`, such as `get_name`.

This demonstrates that instance variables are particular to the object in which they are initialized and once initialized are accessible to all the instance methods available to be called on that object. This is what we mean when we say that instance variables are scoped at the object level.

5m30s

26.

```ruby
# How do class inheritance and mixing in modules affect instance variable scope? Give an example.
```

Instance variables are scoped at the object level. Once initialized, an instance variable is available throughout the instance methods available to an object, regardless of whether those methods are defined in the class of the object, or in a class or module in the inheritance chain of that class.

In Ruby, an instance variable is only initialized in an object once an instance method that initializes it is actually called on an object.

So although instance methods are inherited, instance variables themselves are not inherited. The instance methods available to an object via the method lookup path of its class define the set of potential instance variables that can be initialized in that object, but no instance variable comes into existence in the object until the method that initializes it is called on the object. The only instance variables that are initialized as soon as the object is instantiated are those initialized by the `initialize` constructor, whether the constructor is inherited or defined in the object's class.

For instance,

```ruby
module Nameable
  def name=(n)
    @name = n
  end
end

class Person
  include Nameable
end

tom = Person.new
puts tom.inspect # <Person:0x...>
tom.name = "Tom"
puts tom.inspect # <Person:0x... @name="Tom">
```

Here, the instance variable `@name` is absent from the `inspect` string of a newly-instantiated `Person` object, as line 12 demonstrates. It is only once the setter method inherited from the `Nameable` module `name=` is actually called on our `Person` object on line 13 that `@name` is initialized in it. We can see from the output of line 14 that our `Person` object now has a `@name` instance variable.



27.

```ruby
# How does encapsulation relate to the public interface of a class?
```

In Ruby, encapsulation lets us hide functionality and protect data behind a public interface, selectively exposing those behaviors and attributes that users of the class actually need. The public interface of a class determines how users of the class can interact with its objects. The simpler the public interface the better, since this makes our classes easier to use and allows us to protect data from accidental or invalidating modification.

The public interface of a class consists of its public methods. In Ruby, encapsulation means that instance variables are only accessible from outside the object, if at all, via deliberately exposed public methods such as getter and setter methods. This helps protect data from accidental modification. We can choose which methods remain hidden as part of the implementation and which methods are exposed as part of the public interface using method access control.

Method access control is implemented using the access control modifier methods `Module#public`, `Module#private` and `Module#protected`. Methods are `public` by default. `public` methods form the interface to the class. `private` methods can only be called from within the class on the calling object. `protected` methods can only be called within the class, but can be called on another object of the class, not only on the calling object. `private` and `protected` methods do not form part of the public interface.

By separating the implementation of the class from the public interface through which client code interacts with its objects, we reduce code dependencies; client code can only become dependent on the consistent interface and not on implementation details, which we are free to change. This makes code more maintainable. And by restricting the number of methods available to be called publicly, we have more leeway to make changes to the implementation.

In addition, having a simple and consistent interface to our classes encourages us to think and solve problems at a higher level of abstraction, the level of the problem domain, rather than needing to be concerned with the implementation details.



In Ruby, encapsulation lets us hide functionality and protect data behind a public interface

The public interface determines how users of the class can interact with its objects

The simpler the public interface the better, since this simplifies use of the class and protects data from accidental modification

The public interface of a class consists of its public methods

We can use method access control to determine which methods are `public`  and form the interface. `private` and `protected` methods are part of the implementation and do not form part of the interface.

In Ruby, instance variables are not part of the public interface, and can only be accessed from outside the object, if at all, via the public methods

Separating the implementation of the class from its consistent public interface reduces code dependencies. Client code can only become dependent on the fixed public interface and not on the implementation of the class, which we are therefore free to change. This makes our code more maintainable.

Having our classes present a simple and consistent public interface is part of how encapsulation encourages us to think at a higher level  of abstraction: the level of the problem domain. It allows us to solve more complex problems by freeing us from constant consideration of lower level concerns such as whether our objects might take on invalid values.



28.

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky


# What is output and why? How could we output a message of our choice instead?

# How is the output above different than the output of the code below, and why?

class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    @name = n
    @age  = a * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
p sparky
```

The first piece of code will output a string similar to `<GoodDog:0x...>`, where `0x...` is an encoding of the object id. The reason for this is that we have not overridden the default implementation of the `to_s` method, which is implicitly called when we pass an object to `Kernel#puts`. This default implementation is `Object#to_s`, which returns a string of the form `<ClassName:0x...>`, where `ClassName` is the name of the class and `0x...` is an encoding of the object's unique object id.

We could output a message of our choice simply by overriding the `to_s` method by defining a `GoodDog#to_s` method in our `GoodDog` class. For instance:

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
  
  def to_s
    "I'm a #{self.class} called #{name}"
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky # "I'm a GoodDog called Sparky"
```



The second piece of code will output a string similar to `<GoodDog:0x... @name="Sparky", @age=4>`. This is because the default `inspect` method is called when an object is passed as argument to the `Kernel#p` method instead of `to_s`. The string format returned by the default `Object#inspect` method is the same as that returned by `to_s` except that `inspect` includes the instance variables initialized in the object and a string representation of their current values. Ruby obtains these current values by implicitly calling `inspect` on the objects referenced by the instance variables.

7m20s

29.

```ruby
# When does accidental method overriding occur, and why? Give an example.
```

Accidental method overriding can occur whenever we override a method inherited from a superclass without intending to. However, since all custom classes inherit from `Object` by default, this is most likely to occur when we name a method in a custom class using the same name as a method inherited from the `Object` class.

As an example, if we had a `Message` class it might be logical to name a method that sends our `Message` over the network `Message#send`. However, this would accidentally override the `send` method inherited from `Object`, which like most of the methods inherited from `Object` implements core Ruby functionality that almost all objects should have access to. The `send` method allows us to call a method on an object by passing the name of the method as a Symbol argument to `send`, along with any arguments to the method we wish `send` to call.

```ruby
class Message
  attr_reader :text
  
  def initialize(t)
    @text = t
  end
  
  def send
    # code to send message over network
  end
end

my_message = Message.new("Hello world")

# We attempt to output text of message to screen
puts my_message.send(:text) # raises ArgumentError
```

Here, we attempt to call the `Message#text` getter method to output the text of the message using `Object#send`, but since we have overridden that method when we defined `Message#send`, we get an `ArgumentError`, since unlike `Object#send` our `Message#send` expects no arguments.

11m19s



30.

```ruby
# How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers.
```

Many OOP languages include access control features to limit the accessibility of instance variables and functionality. Since Ruby instance variables can only be accessed from outside an object, if at all, through instance methods, access control in Ruby is often called method access control.

Method access control is implemented in Ruby through methods defined in the `Module` class, `public`, `private` and `protected`. These methods are called 'access modifiers'.

The `public` methods of a class comprise the public interface of a class. Methods are public by default, so `Module#public` is less commonly used than the other access control modifiers. Public methods should be limited to only those methods necessary for the class to be useful to users of the class. The smaller the public interface, the simpler the class is to use. A limited public interface also limits code dependencies, making the class easier to maintain.

`private` methods can only be called from within the class on the calling object. `private` methods can be considered implementation details of a class and code outside the class cannot form dependencies on them. We make methods `private` when they do work within the class but do not need to be exposed to users of the class.

For instance,

```ruby
class Customer
  def initialize(name, card_number)
    @name = name
    @card_number = card_number
  end
 
  def payment_method
    "xxxx-xxxx-xxxx-#{last_four_digits}"
  end
  
  private
  
  def last_four_digits
    @card_number[-4..-1]
  end
end

mike = Customer.new("Michael Smith", "2345-5321-8372-8281")
puts mike.payment_method # "xxxx-xxxx-xxxx-8281"
puts mike.last_four_digits # raises NoMethodError
```

Here, we define a `Customer` class, with a `public` (by default) `Customer#payment_method` that can be called from outside the class to return limited information about a `Customer`'s payment details. This `public` method makes use of a `private` `Customer#last_four_digits` method in order to perform part of its work. This method is `private` because we do not need to expose it separately as part of the class's public interface.

`protected` methods are similar to `private` methods but can be called within the class on an object of the class that is not the calling object, usually one passed in as an argument to a `public` method. For instance,

```ruby
class Person
  def initialize(name, height_in_cm)
    @name = name
    @height = height_in_cm
  end
  
  def taller?(other_person)
    height > other_person.height
  end
  
  protected
  
  attr_reader :height
end

mike = Person.new("Mike", 175)
joe = Person.new("Joe", 180)

puts mike.taller?(joe) # true
```

Here, we do not need to expose the `Person#height` method as part of the public interface. However, we cannot make it `private` because our `Person#taller?` method needs to be able to call it on another `Person` object passed as argument. Here, `protected` provides the right level of access control for our `height` method.



31.

```ruby
# Describe the distinction between modules and classes.
```

Classes and modules can both group instance methods, and both can be used to share methods between multiple classes. However, the mechanisms by which this happens are different.

Classes can subclass from another class, inheriting the superclass's methods. Class inheritance represents an 'is-a' relationship. The subclass is a specialized type with respect to the more general type of the superclass. Class inheritance is therefore used to model entities in the problem domain that have naturally hierarchical relationships.

Mixin modules can be mixed in to a class using the `Module#include` method to provide instance methods defined in the module to the class. This is sometimes called 'interface inheritance'. The relationship between a class and a mixin module represents a 'has a' relationship. The class is not a specialized type with respect to the module. Rather, it 'has a' functionality or ability granted by the module.

A class can only subclass from a single immediate superclass, meaning Ruby is a single inheritance language. However, a class can mix in as many modules as desired, which compensates for Ruby's lack of multiple inheritance.

However, the most important distinction between modules and classes is that we can only instantiate objects from classes, not from modules.

This distinction means that classes are used as blueprints for objects of a certain type, predetermining their attributes and behaviors, while mixin modules can only provide behaviors to classes.

Modules have other uses that distinguish them from classes. Modules are used for namespacing, grouping related classes under the name of the module. Namespacing facilitates code reuse in a greater variety of contexts, helps avoid name collisions, and acts as a sort of documentation, since the name of the namespace module can contextualize the names of the contained classes. Modules are also used as containers for logically-related standalone methods that do not properly belong to any particular class.



Classes and modules can both group behaviors/instance methods.

Classes and modules can both be used to distribute methods to multiple classes.

Class inheritance, subclass and superclass relationship. 'is a'. Specialized type of more general type. Modeling hierarchies.

Mixin module interface inheritance provides abilities to classes. 'has a' ability or group of behaviors, interface inheritance. Class that mixes in a modules is not a specialized type with respect to the module.

Class inheritance is single inheritance. Mixin modules can compensate for lack of multiple inheritance.

Most important distinction: classes can instantiate objects, modules can't

Therefore classes are blueprints for objects, determining their behaviors and attributes, whereas mixin modules can only provide behaviors to classes.

Modules have other uses that distinguish them from classes. Modules can be used as namespaces: modular code reuse (like libraries), avoid name collisions, contextualize names of contained classes. Modules can be used as containers for 'module methods', methods that do not properly belong to any specific class, such as Ruby's `Math` module.

32.

```ruby
# What is polymorphism and how can we implement polymorphism in Ruby? Provide examples.
```

Polymorphism is the ability of different types of data to respond to a common interface, often but not always in different ways. This is to say, polymorphism is the ability of objects of different classes to respond to a common method invocation. 'Poly' means 'many' and 'morph' means forms.

Polymorphism means that we can pass objects of different types to a method as arguments, and the method can call methods on its arguments regardless of type so long as the objects respond to the method call. The client code does not need to check the type of object that it is being passed as argument so long as it exposes the right interface.

Polymorphism is made possible by designing our data types (classes) so that multiple types of object can be treated the same way. In Ruby we can implement polymorphic structure in our classes in three main ways: through class inheritance, through mixin modules (or 'interface inheritance') or through duck typing.

Implementing polymorphism through class inheritance is common to many OOP languages. We can define methods in a superclass and those methods will be available to call on objects of subclasses, even if the subclasses might override some superclass methods with more specialized implementations of their own. Since all the classes in the hierarchy share the common interface defined by the superclass, client code can successfully call those methods on objects of any of these classes.

For example, 

```ruby
class Vehicle
  def start
    puts "Starting engine..."
  end
end

class Car < Vehicle; end

class Truck < Vehicle; end

class Boat
  def start
    puts "Starting outboard motor..."
  end
end

vehicles = [Car.new, Truck.new, Boat.new]
vehicles.each do |vehicle|
  vehicle.start
end
# Starting engine...
# Starting engine...
# Starting outboard motor...
```

Polymorphism makes programs more flexible and less fragile by loosening the coupling between client code and the details of the types of object it works with. Client code does not need to know the type or class of the objects it is passed, or the representation of those objects, so long as the objects respond to an interface (the method calls the client code makes the objects it is passed). This reduces code dependencies and improves maintainability.

10m37s

Polymorphism is the ability of different types of data to respond to a common interface, often, but not always, in different ways. 'Poly' means 'many' and 'morph' means 'forms'. Polymorphism means that objects of different classes can be passed to a piece of code (such as a method or block) and so long as the object responds to a particular interface (the methods calls made by the client code) we do not need to be concerned with the class or type of object.

We implement polymorphism by designing our classes so that objects of multiple different classes or types can be treated the same way. In Ruby, there are three ways to implement polymorphic structure in our classes: through class inheritance, through mixin modules, or through duck typing.

We can use mixin modules to ensure that multiple different classes expose a common interface provided by the module. This is sometimes called 'interface inheritance'. Mixin modules are often used to provide a particular ability to classes, allowing them to respond polymorphically to a common set of method invocations.

We define the methods whose interface we wish our classes to respond to in the mixin module, and mix it in to our classes using the `Module#include` method. Once we have mixed our module in to our classes, objects of these different classes will be able to respond to a common interface.

Polymorphism through mixin modules can make up for Ruby's lack of multiple inheritance. It also allows us to conveniently distribute a common interface to classes that do not necessarily fit into the hierarchical relationships implied by class inheritance.

For example,

```ruby
module Climbable
  def climb
    puts "I'm climbing"
  end
end

class Mountaineer
  include Climbable
end

class Cat
  include Climbable
end

class Raccoon
  include Climbable
end

climbers = [Mountaineer.new, Cat.new, Raccoon.new]

climbers.each do |climber|
  climber.climb
end
# I'm climbing
# I'm climbing
# I'm climbing
```



Polymorphism makes our code more flexible and less fragile by loosening the coupling between client code and the details of the data types it works with. We don't need to know the exact type of the objects our code is being passed, or the details of their representation, only that they respond to a particular interface. Polymorphism reduces code dependencies and makes our code more maintainable

14m33s



Polymorphism is the ability of different types of data to respond to a common interface, often though not always in different ways. Polymorphism means that a piece of client code (such as a method or block) can be passed objects of different classes and, so long as those objects expose the methods the code calls on its arguments, we do not need to be concerned with the type of the objects.

Implementing polymorphism means structuring our data types or classes so that they expose a common interface and thus objects of these different classes can be treated the same. The most common way to do this is through class inheritance. Ruby also adds support for polymorphism through mixin modules. But in Ruby, we can also implement polymorphism through duck typing.

Duck typing is the ability for unrelated types to respond to a common interface. So long as an object exposes compatible methods with the right names and number of arguments for a piece of client code, it can be treated as belonging to the right category of object. If an object quacks like a duck it can be treated as a duck.

Duck typing is particularly flexible, since it means we can add new classes to be used by an existing piece of client code without having to worry about fitting the class into an existing class hierarchy, or about whether an existing mixin module will be suitable for our new class. We can simply expose the interface required by an existing piece of code and our new class of objects can be used polymorphically. This makes our programs more maintainable.

As an example of polymorphism through duck typing,

```ruby
class Duck
  def fly
    puts "The duck takes off..."
  end
end

class Pigeon
  def fly
    puts "The pigeon takes off..."
  end
end

class Airplane
  def fly
    puts "The airplane takes off..."
  end
end

flyers = [Duck.new, Pigeon.new, Airplane.new]

flyers.each do |flyer|
  flyer.fly
end
# The duck takes off...
# The pigeon takes off...
# The airplane takes off...
```

Polymorphism makes our programs more flexible and less fragile by loosening the coupling between client code and the details of the data types that it works with. Our code does not need to know about the implementation of our classes or the specific classes of object it is working with, we only need to care that they expose a given interface. Polymorphism reduces code dependencies and makes our code more maintainable.

13m32s



33.

```ruby
# What is encapsulation, and why is it important in Ruby? Give an example.
```

Encapsulation means to enclose as though in a capsule. Encapsulation is bundling data with the operations that work on that data. This helps ensure that we only perform valid operations on the data. In Ruby, encapsulation means defining classes and instantiating objects. An object encapsulates data (state) with the operations that are valid on that data (methods).

Encapsulation also means hiding pieces of functionality from the rest of the code base and protecting data behind a public interface. In Ruby, the instance variables that track an object's state are only accessible from outside the object, if at all, through the deliberately exposed interface. The public interface consists of public methods.

We can control which methods are part of the public interface using method access control. This is done using the method access modifier methods `Module#public`, `Module#private` and `Module#protected`. `public` methods form the public interface to our class and can be called on an object from anywhere in the program. `private` methods can only be called within the class on the calling object. `protected` methods can only be called from inside the class, but can be called on another object of the class in addition to the calling object.

Encapsulation helps protect data from accidental or invalid modification. We can be sure that the methods defined by a class are valid on the types of data represented by objects of the class. By exposing a simplified public interface, we loosen coupling between our client code and the code in our classes. Our client code can only become dependent on the interface of objects, not on their representation or implementation details. As long as the public interface to a class remains constant, we are free to change the implementation details of our classes without breaking existing code. This reduces code dependencies and makes our code easier to maintain.

Encapsulation also frees us from worrying about implementation details and lets us think at a higher level of abstraction: the level of the problem domain. This permits us to solve more complex problems without being distracted by lower-level concerns.

As an example,

```ruby
class Cat
  def initialize(name)
    self.name = name
  end
  
  def change_name(new_name)
    self.name = name
  end
  
  def say_name
    puts name
  end
  
  private
  
  attr_accessor :name
end

fluffy = Cat.new('fluffy')
fluffy.say_name # "fluffy"
fluffy.change_name("Fluffy")
fluffy.say_name # "Fluffy"

fluffy.name # NoMethodError: private method called from outside the class
```

15m53s

34.

```ruby
module Walkable
  def walk
    "#{name} #{gait} forward"
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

mike = Person.new("Mike")
p mike.walk

kitty = Cat.new("Kitty")
p kitty.walk


# What is returned/output in the code? Why did it make more sense to use a module as a mixin vs. defining a parent class and using class inheritance?
```

This code will output:

```
Mike strolls
Kitty saunters
```

It makes sense to use a module to model an ability or group of behaviors that we wish multiple classes to *have*. Class inheritance might make sense if `Person` and `Cat` were logically specialized types of a common superclass. However, since there is no such logical general superclass that `Person` and `Cat` are specialized types of, it makes more sense to use a module.

Modules represent a 'has a' relationship where the classes that mix in a module 'have an' ability granted by the module, while class inheritance models an 'is a' relationship between subclasses and superclass.

5m10s



35.

```ruby
# What is Object Oriented Programming, and why was it created? What are the benefits of OOP, and examples of problems it solves?
```

OOP is a programming paradigm created to deal with the problems of large, complex software projects. OOP aims to reduce code dependencies, improve the maintainability and reusability of code, and allow the programmer to think at a higher level of abstraction.

As pre-OOP programs grew in scale and complexity, they tended to become a mass of dependencies, with every part of the program depending on every other part. Code could not be changed or new features added without a ripple of adverse effects throughout the code base.

OOP aims to modularize programs, providing containers for data that can be changed without affecting the rest of the code base, a way to section off functionality and data behind publicly exposed interfaces, so that a program becomes the interaction of many small parts rather than a mass of dependency.

By abstracting away implementation details behind interfaces, OOP also aims to allow us to think in terms of the problem domain. OOP objects can represent real world objects, or entities from the problem domain. This provides a high-level way to break down and analyze complex problems, and a way to solve them one piece at a time.

By allowing us to modularize programs in this fashion, OOP also permits us to reuse code in a greater variety of contexts. Features of OOP such as encapsulation, polymorphism, and inheritance, contribute in making the complexity of large software projects easier to manage.

4m43s

36.

```ruby
# What is the relationship between classes and objects in Ruby?
```

In Ruby, a class is a blueprint or template for objects. Classes define what an object can do (behaviors) and what it is made of (attributes).

The behaviors available to an object are the instance methods predetermined by its class. The attributes of an object are its set of potential instance variables. In Ruby, an instance variable is only initialized in an object when the instance method that initializes it is actually called on that object. But the set of potential instance variables that might be initialized in an object is predetermined by the instance methods available to that object, which are predetermined by the class.

Classes group behaviors and objects encapsulate state. All objects of a class have access to the same behaviors, instance methods. Each object has its own set of instance variables that track its distinct state. The state of an object is particular to that object, and the instance variables of one object are not shared with any other object, even objects of the same class.

The act of creating an object from a class is called 'instantiation', and objects are 'instances' of classes. Objects of custom classes are usually instantiated by calling the class method `new` on the class, which in turn calls the constructor, the private instance method `initialize`, on the new object, which initializes the state of the object.

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#{@name} says meow!"
  end
end

fluffy = Cat.new("Fluffy")
garfield = Cat.new("Garfield")

fluffy.speak # "Fluffy says meow!"
garfield.speak # "Garfield says meow!"
```

6m57s



37.

```ruby
# When should we use class inheritance vs. interface inheritance?
```

Class inheritance models an 'is a' relationship between superclass and subclass. The subclass is a specialized type with respect to the type of the superclass. Therefore, class inheritance is most useful in modeling entities in the problem domain whose relationships are naturally hierarchical.

```ruby
class Animal
end

class Mammal < Animal
end

class Fish < Animal
end

class Cat < Mammal
end

class Dog < Mammal
end
```

Mixin modules can also provide functionality to multiple classes. This is sometimes called 'interface inheritance', since we are providing a specific interface consisting of instance methods to classes that we need to share functionality. Modules are therefore useful in modeling a 'has a' relationship, where multiple entities in the problem domain 'have a' common ability despite not being related in the naturally hierarchical manner of a class hierarchy. A class that mixes in a module is not a specialized type with respect to the module.

From a more practical standpoint, classes can only subclass from one immediate superclass since Ruby is a single inheritance language. If we need the benefits of multiple inheritance, we need to use mixin modules. For instance, if we have an existing class hierarchy and we need to add an ability to certain subclasses of a superclass but not others, a mixin module allows us to share this new ability among specific subclasses.

```ruby
module Swimmable
end

class Animal
end

class Mammal < Animal
end

class Fish < Animal
  include Swimmable
end

class Cat < Mammal
end

class Dog < Mammal
  include Swimmable
end
```

9m21s

38.

```ruby
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new


# If we use `==` to compare the individual `Cat` objects in the code above, will the return value be `true`? Why or why not? What does this demonstrate about classes and objects in Ruby, as well as the `==` method?
```

`==` appears as an operator because of the syntactic sugar around its invocation, but it is a method. The default `==` method that is inherited from `BasicObject` is overridden by core and standard library classes whose objects are intended to be compared using the `==` method, such as `Integer` and `String`.

The conventional meaning for the `==` method in Ruby is to compare the principal object value of the caller with that of the argument, usually an object of the same class. However, `BasicObject#==`, which our `Cat` class inherits, compares as principal object value the object id of caller and argument. Since an object's object id is unique, this effectively tests whether caller and argument are the same object.

Since the three `Cat` objects instantiated on lines 4-6 are different objects, comparing them with `==` will return `false`. This is because we have not overridden the `BasicObject#==` method with a more meaningful `Cat#==` method.

5m05s

39.

```ruby
class Thing
end

class AnotherThing < Thing
end

class SomethingElse < AnotherThing
end


# Describe the inheritance structure in the code above, and identify all the superclasses.
```

On lines 1-2, we define the `Thing` class. Any custom class without an explicit superclass will subclass from `Object` by default. `Object`, in turn, subclasses `BasicObject`. Thus `Object` and `BasicObject` could be said to be superclasses of `Thing`, `Object` being the immediate superclass.

On lines 4-5, we define the `AnotherThing` class as a subclass of `Thing`. This means `Thing` is a superclass.

On lines 7-8, we define `SomethingElse` as a subclass of `AnotherThing.` This means `AnotherThing` is also a superclass.

2m27s

40.

```ruby
module Flight
  def fly; end
end

module Aquatic
  def swim; end
end

module Migratory
  def migrate; end
end

class Animal
end

class Bird < Animal
end

class Penguin < Bird
  include Aquatic
  include Migratory
end

pingu = Penguin.new
pingu.fly


# What is the method lookup path that Ruby will use as a result of the call to the `fly` method? Explain how we can verify this.
```

If we call `flight` on our `pingu` object, as on line 25, Ruby will follow the method lookup path for objects of this object's class, `Penguin`, until it finds a method called `flight`, or until it raises a `NoMethodError` if no such method is found.

The method lookup for the invocation of `flight` on line 25 begins with the object's class, `Penguin`. Since there is no `flight` method here, Ruby next searches mixed in modules in the reverse order of the calls to `Module#include` that mixed them in: `Migratory`, followed by `Aquatic`. Since a `flight` method is not found in them, Ruby moves to the superclass `Bird`.

Ruby does not find a `flight` method in `Bird`, so it moves to the implicit superclass `Object`. Ruby then searches the included module `Kernel` before moving to the superclass `BasicObject`. Since no `flight` method has been found and we have reached the ultimate superclass of all classes in Ruby, a `NoMethodError` is raised.

We can verify this by calling the `Module#ancestors` method on the class of our `pingu` object, like so:

```ruby
pingu.class.ancestors
```

5m14s

41.

```ruby
class Animal
  def initialize(name)
    @name = name
  end

  def speak
    puts sound
  end

  def sound
    "#{@name} says "
  end
end

class Cow < Animal
  def sound
    super + "moooooooooooo!"
  end
end

daisy = Cow.new("Daisy")
daisy.speak


# What does this code output and why?
```

We define an `Animal` class on lines 1-13. The `initialize` constructor is defined with one parameter `name` which the method body uses to initialize instance variable `@name`. The `Animal#speak` method is defined on lines 6-8. The body calls a `sound` method on the calling object and passes the return value to `Kernel#puts` to be output to screen. The `Animal#sound` method returns a string with interpolation of the `@name` variable: `"#{@name} says "`.

We define the `Cow` class on lines 15-19 as a subclass of `Animal`. We override the `sound` method on lines 16-18. `Cow#sound` calls the superclass method `Animal#sound` using the `super` keyword. `super` calls the method of the same name further up the method lookup path, which here is `Animal#sound`. The superclass method returns a string with our `Cow` object's `@name` variable interpolated in it. `Cow#sound` then calls `String#+` on the return value with `"moooooooooooo!"` passed as argument. The concatenated return value is then returned from `Cow#sound`.

We instantiate a `Cow` object on line 21, `daisy`, passing the string `"Daisy"` through to the constructor to be used to initialize the `@name` variable in `daisy`. Thus when we call `Animal#speak` on `daisy` on line 22, `Animal#speak` calls `Cow#sound` which calls `Animal#sound` before returning the string `"Daisy says moooooooooooo!"` to `Animal#speak` to be output by `puts`.

7m27s

42.

```ruby
class Cat
  def initialize(name, coloring)
    @name = name
    @coloring = coloring
  end

  def purr; end

  def jump; end

  def sleep; end

  def eat; end
end

max = Cat.new("Max", "tabby")
molly = Cat.new("Molly", "gray")


# Do `molly` and `max` have the same states and behaviors in the code above? Explain why or why not, and what this demonstrates about objects in Ruby.
```

`max` and `molly` are two separate `Cat` objects. Since they are both `Cat` objects they share the behaviors predetermined by the `Cat` class. However, since they are two distinct objects, they have distinct states.

An object's state, its instance variables and the objects they track, is unique to that object, and is not shared with any other object, even objects of the same class.

We can confirm this by calling `Object#inspect` on one object and passing the return value to `Kernel#puts`. We then repeat this for the other object.

The output will be something like:

```ruby
<Cat:0x... @name="Max", @coloring="tabby">
<Cat:0x... @name="Molly", @coloring="gray">
```

Here we can see that each `Cat` has its own `@name` and `@coloring` instance variables, which reference different String objects.

We can confirm that they share methods by calling any of the public instance methods defined in the `Cat` class on both objects.

This code demonstrates that instance methods are available to all instances of a class, whereas an object's state is unique and distinct to that object.

5m41s

43.

```ruby
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end
  
  def change_grade(new_grade)
    grade = new_grade
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade 


# In the above code snippet, we want to return `”A”`. What is actually returned and why? How could we adjust the code to produce the desired result?
```

On line 14, we instantiate a new `Student` object, `priya`, passing the string `"Priya"` through to the constructor.

The `Student` class is defined on lines 1-12. The `initialize` constructor is defined with one parameter `name` which it uses to initialize instance variable `@name`. The method also initializes `@grade` to `nil`.

On line 15, we call the `Student#change_grade` method on `priya` with the string `'A'` passed as argument.

`Student#change_grade` is defined on lines 9-11 with one parameter `new_grade`. The method seems intended to set the `@grade` instance variable using the `Student#grade=` setter method. However, that is not what happens.

On line 10, we intend to call `grade=` but instead initialize a new local variable called `grade` to the reference of `new_grade`. This is because the syntax for calling a setter method whose name ends in `=` implicitly on the calling object cannot be disambiguated from the initialization of a new local variable. We have to explicitly call the setter on the calling object by using the keyword `self`, which references the calling object within an instance method definition.

Since we do not change the reference of our `@grade` instance variable, when we call getter method `Student#grade` on `priya` on line 16, the return value will be `nil`.

We can rectify this by changing line 10 to `self.grade = new_grade`.

6m41s

44.

```ruby
class MeMyselfAndI
  self

  def self.me
    self
  end

  def myself
    self
  end
end

i = MeMyselfAndI.new


# What does each `self` refer to in the above code snippet?
```

The keyword `self` on line 2 references the class `MeMyselfAndI`. This is because line 2 is within the class definition but outside of any instance method definition.

On line 4, the keyword `self` references the class again. This is because line 2 is outside any instance method definition. `self` here is being used to define a class method. It is preferred to use `self` when defining a class method rather than naming the class literally.

Within the class method `MeMyselfAndI::me`, on line 5, `self` still references the class. Since class methods can be inherited, this will either be `MeMyselfAndI` or one of its subclasses (if any) depending on the class the method is called on.

Within the definition of instance method `myself`, on line 9, `self` references the calling object, whichever instance of the class the method is called on.

This code demonstrates how the reference of keyword `self` changes depending on context, and also the major uses of `self`: to define class methods, and to explicitly reference the calling object within an instance method.

5m47s

45.

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
  end 
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">


# Running the following code will not produce the output shown on the last line. Why not? What would we need to change, and what does this demonstrate about instance variables?
```

Running the code will produce output similar to the following (with a unique object id):

```ruby
<Student:0x... @name="Adewale">
```

The reason that the `@grade` instance variable is missing is that no such instance variable has been initialized.

We define a `Student` class on lines 1-7. Our `initialize` constructor is defined with two parameters `name` and `grade`. The body of the method uses `name` to initialize instance variable `@name`, but no such initialization takes place for `grade`.

We generate simple getter and setter methods for `@grade` on line 2 with a call to `Module#attr_accessor`, but since the setter method is never used, this doesn't initialize `@grade` either.

This code demonstrates that, in Ruby, although a class predetermines a set of potential instance variables for objects of the class, an instance variable must actually be initialized at runtime by the invocation of a method on the object in order for that instance variable to actually come into existence in the object.

5m11s

46.

```ruby
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

sir_gallant = Knight.new("Gallant")
p sir_gallant.name 
p sir_gallant.speak 


# What is output and returned, and why? What would we need to change so that the last line outputs `”Sir Gallant is speaking.”`? 
```

On line 19, we initialize local variable `sir_gallant` to a new `Knight` object, passing the string `"Gallant"` through to the constructor.

The `Knight` class is defined on lines 13-17 as a subclass of `Character` (lines 1-11). The `initialize` constructor for the `Knight` class is inherited from `Character`. `Character#initialize` is defined with one parameter `name` which it uses to initialize the instance variable `@name`.

The `Character` class also defines the `speak` instance method and simple setters and getters for the `@name` instance variable.

On line 20, the `name` getter method is called on `sir_gallant` and the return value passed to `Kernel#p` to be output. Since `Knight` overrides `Character#name`,  it is `Knight#name` that is called.

`Knight#name` is defined on lines 14-16. The method return value prepends the string `"Sir "` to the return value of calling the superclass `Character#name` method using the `super` keyword. `super` calls the method of the same name that is next in the method lookup path, in this case the `name` method in the immediate superclass.

Thus line 20 outputs `"Sir Gallant"`.

On line 21, we call `speak` on `sir_gallant` and output the return value. The `Character#speak` method (lines 8-10) interpolates the `@name` instance variable directly into a string and returns the new string: `"#{@name} is speaking."`. Therefore, this method returns `"Gallant is speaking".`.

If we wish line 21 to output `"Sir Gallant is speaking."` we can simply change line 9 to call the `name` method instead of referencing the instance variable directly. This will result in `Knight#name` being called.

```ruby
"#{name} is speaking."
```

9m35s



This code will output

```
Sir Gallant
Gallant is speaking
```

On line 19, we instantiate a new `Knight` object, `sir_gallant`, passing the string `"Gallant"` through to the constructor. Our `Knight` class is defined on lines 13-17 as a subclass of `Character` defined on lines 1-11. The `initialize` method for a `Knight` is inherited from `Character`. This method (lines 4-6) is defined with one parameter `name`, which it uses to initialize the instance variable `@name`.

On line 20, we call the `Knight#name` method on `sir_gallant` and pass the return value, the string `"Sir Gallant"` to the `Kernel#p` method to be output.

We expect the next line, line 21, to output `"Sir Gallant is speaking"`. However, instead the return value from calling `speak` on `sir_gallant` is simply `"Gallant is speaking"`.

The reason for this lies in the `Character#speak` method, defined on lines 8-10. Since the body of the method interpolates the `@name` instance variable directly into the string the method returns, rather than calling the `name` getter method, this bypasses the logic in `Knight#name`.  `Knight#name` (lines 14-16) prepends the string `"Sir "` to the return value of calling the simple getter method `Character#name` from the superclass using the `super` keyword.

In order to rectify this, we can simply change line 9 to

```ruby
"#{name} is speaking"
```

9m22s



47.

```ruby
class FarmAnimal
  def speak
    "#{self} says "
  end
end

class Sheep < FarmAnimal
  def speak
    super + "baa!"
  end
end

class Lamb < Sheep
  def speak
    super + "baaaaaaa!"
  end
end

class Cow < FarmAnimal
  def speak
    super + "mooooooo!"
  end
end

p Sheep.new.speak
p Lamb.new.speak
p Cow.new.speak 


# What is output and why? 
```

We define a `FarmAnimal` class on lines 1-5. `FarmAnimal` contains one instance method definition `FarmAnimal#speak`. The method definition body returns a string with the calling object referenced by `self` interpolated into it: `"#{self} says "`. Since there is no custom `to_s` method defined in the class, the return value (with a unique object id) will be something like `"<FarmAnimal:0x...> says ".

On lines 7-11, we define a `Sheep` class as a subclass of `FarmAnimal`. We override the `speak` method. The `Sheep#speak` method returns the new string returned by concatenating the return value of the superclass method called using the keyword `super` to the string `"baa!"`. `super` calls the method of the same name next in the method lookup path. In this case that is `FarmAnimal#speak`.

We define a `Lamb` class on lines 13-17 as a subclass of `Sheep`. We override the `speak` method. The `Lamb#speak` method uses the `super` keyword to call `Sheep#speak` and then concatenates the return value to the string `"baaaaaaa!"`, and returns the result.

On line 19, we define `Cow` as a subclass of `FarmAnimal`. We override `speak` with `Cow#speak`. The method body calls the superclass method `FarmAnimal#speak` and concatenates the return value to the string `"mooooooo!"`, returning the result.

On lines 25-27, we instantiate `Sheep`, `Lamb` and `Cow` objects, and on each in turn call `speak` and pass the return values to `Kernel#p`. The output will therefore be (something like):

```
<FarmAnimal:0x...> says baa!
<FarmAnimal:0x...> says baa!baaaaaaa!
<FarmAnimal:0x...> says mooooooo!
```

9m04s

48.

```ruby
class Person
  def initialize(name)
    @name = name
  end
end

class Cat
  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

sara = Person.new("Sara")
fluffy = Cat.new("Fluffy", sara)


# What are the collaborator objects in the above code snippet, and what makes them collaborator objects?
```

A collaborator object is any object that becomes part of another object's state. We call these collaborators because they can assist the containing object in carrying out its responsibilities

In the above example, on line 14 the String object `"Sara"` is passed through to the constructor of the `Person` object `sara`, where it is assigned to the instance variable `@name`. At this point the String `"Sara"` becomes a collaborator object to the `Person` object `sara`, since an instance variable of `sara` now tracks the String object; the String is part of `sara`'s state.

On line 15, we pass the String `"Fluffy"` and the `Person` `sara` through to the constructor of the `Cat` object `fluffy`. The String and the `Person` are assigned to the instance variables `@name` and `@owner` respectively. At this point, they become collaborator objects of `fluffy`.

It is important to consider collaborations between objects of classes at the class design stage onward, since collaborations between classes represent the network of communication between the actors in our program, objects. If an object is part of a containing object's state, then the containing object can easily call methods on the collaborator.

Thus we could say that the `Person` class has String as a collaborator, and `Cat` has String and `Person` as collaborators.

6m08s



```ruby
number = 42

case number
when 1          then 'first'
when 10, 20, 30 then 'second'
when 40..49     then 'third'
end


# What methods does this `case` statement use to determine which `when` clause is executed?
```

On line 1, we initialize local variable `number` to `42`.

On lines 3-7, we have a `case` statement with `number` as the argument to `case`. `case` statements make use of the `===` method to make comparisons. `===` appears as an operator, but is a method like any other with operator syntactic sugar. It is rarely used explicitly but is used implicitly by `case` statements. The `===` checks for equivalence by considering whether the argument object can be considered a member of the group represented by the calling object.

Which `===` method will be called by each `when` clause depends on the class of the object used for comparison, which becomes the caller of `===`.

The `when` clause on line 4 will call `Integer#===`, since `1` is an integer. `number` is passed as argument to `===`. This will return `false`, since `42` is not `1`.

Line 5 will call `Integer#===` with each of `10`, `20`, and `30`, with `number` passed as argument. This will return `false` each time.

Line 6 will call `Range#===` with `42` passed as argument. This will return `true` since `42` is a member of the Range `40..49`. This `then` branch is followed and the `case` statement returns `"third"`.

6m46s

50.

```ruby
class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  @@total_people = 0

  def initialize(name)
    @name = name
  end

  def age
    @age
  end
end

# What are the scopes of each of the different variables in the above code?
```

On line 2, we initialize a constant `TITLES`. Constants have lexical scope. This means that when an unqualified constant reference is made, Ruby first performs a lexical search of the structure in the source code where the reference occurs. Here, that would be the `Person` class. If the constant cannot be resolved, Ruby widens this lexical search to include any structures the structure of the reference is nested within, up to but not including toplevel. Ruby then searches the inheritance chain of the lexical structure surrounding the reference.

On line 4, we initialize a class variable `@@total_people`. Class variables are scoped at the level of the class where it is initialized, all descendant classes, and all the instances of all those classes. This greatly expanded scope is why many Rubyists suggest not using class variables with inheritance. Many Rubyists advise against using them altogether.

On line 7, we initialize instance variable `@name`, and on line 11 we initialize another instance variable `@age`. Instance variables are scoped at the object level. This means that an object's instance variables are unique and distinct to that object and not shared with any other object, even objects of the same class. An instance variable only comes into being in an object when an instance method initializes it. Once initialized, an instance variable is accessible in all instance methods available on an object, regardless of which method initialized it.

7m11s

52.

```ruby
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end


# In the `make_one_year_older` method we have used `self`. What is another way we could write this method so we don't have to use the `self` prefix? Which use case would be preferred according to best practices in Ruby, and why?
```

On line 10, in our `Cat#make_one_year_older` method, we use `self` to explicitly reference the calling object in order to disambiguate the call to a setter method whose name ends in `=` from the initialization of a new local variable `age`. Ordinarily, within the class within instance method definitions, we can call other instance methods of the class implicitly on the calling object, without needing the dot operator or an explicit caller. Since the syntax for setter method calls would be ambiguous in this format, we must explicitly call the setter method on `self`, which within instance methods references the calling object.

If we wish to avoid using `self`, we must set the instance variable directly, so the method definition becomes:

```ruby
  def make_one_year_older
    @age += 1
  end
```

However, whenever a setter method is available, use of the setter even within the class is preferred to setting the variable directly. This is because using the setter means that we avoid coupling every method that sets the variable to the representation of the object itself. If we wished to change the logic around setting the variable in order to add checks or manipulations on the value, or if we wished to change the representation (e.g. by splitting the data and tracking it with two instance variables), when we have used the setter we only have to change the logic in the setter method and not in every method that currently sets the variable. This reduces dependencies and makes our code more maintainable.

7m

53.

```ruby
module Drivable
  def self.drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive


# What is output and why? What does this demonstrate about how methods need to be defined in modules, and why?
```

The code as it stands will raise a `NoMethodError` exception on line 11. This is because we have attempted to call the `Driveable` module method `drive` on an instance of the `Car` class.

`Car` (6-8) mixes in the module `Driveable` (defined on lines 1-4). However, the `drive` method is defined as a module method on `Driveable` module itself. This means it can only be called on the module, like so: `Driveable.drive`. Mixing in a module to a class only grants the instance methods defined in the module to the class, not module methods that were defined on the module itself.

If we wished this code to run without exceptions, we could remove the `self.` prefix on line 2 of the `drive` definition to make this method an instance method instead.

```ruby
module Drivable
  def drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive

```

This code now runs without a `NoMethodError` being raised.

4m51s



54.

```ruby
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive


# What module/method could we add to the above code snippet to output the desired output on the last 2 lines, and why?
```

On lines 11 and 12 we attempt to call the `<` and `>` methods on a `House` object. Both of these lines will cause a `NoMethodError` to be raised.

`<` and `>` appear as operators because of the syntactic sugar around their invocation, but they are methods like any other. Both `<` and `>` make comparisons based on the value of the calling object and that of the argument. `<` returns `true` if the value of the caller is less than the value of the argument, `false` otherwise. `>` returns `true` if the value of the caller is greater than the value of the argument, `false` otherwise.

We could define these methods in `House` individually using the `Integer#>` and `Integer#<` methods to perform the comparison between the `price` attribute of the calling object and that of the object passed as argument, like so:

```ruby
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
  
  def <(other)
    price < other.price
  end
  
  def >(other)
    price > other.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```

Alternately, we could include the `Comparable` module and define a `House<=>` method. `Comparable` defines various comparison methods that use the `<=>` method of the class the module is mixed into to function, including `<` and `>`. So this would also work:

```ruby
class House
  include Comparable
  
  attr_reader :price

  def initialize(price)
    @price = price
  end
  
  def <=>(other)
    price <=> other.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```

6m27s
