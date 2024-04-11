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
```

What is output and why? What does this demonstrate about instance variables that differentiates them from local variables?

We define a `Person` class over lines 1-7. The call to `Module#attr_reader` on line 2 with the Symbol `:name` passed as argument generates a `name` getter method for a `@name` instance variable. We define a `set_name` instance method on lines 4-7. The only expression in the body of the definition sets the `@name` instance variable to the string `"Bob"`.

On line 9, after the class definition, we initialize a local variable `bob` to a new person object. On line 10, we call the `name` getter method on `bob` and pass the return value to `Kernel#p`. This will output `nil`.

Whereas attempting to reference an uninitialized local variable will cause a `NameError` to be raise, referencing an uninitialized instance variable, such as `@name`, will simply evaluate as `nil`. This is why the above code returns `nil`. There is no `initialize` method defined for the `Person` class that could set `@name`, nor have we called the `set_name` method. So when we call `name` on `bob`, the method returns `nil`, since `@name` has not yet been initialized.

6m14s



2.

What is output and why? What does this demonstrate about instance variables?

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
```

We define a `Swimmable` module over lines 1-5. This contains one instance method `enable_swimming`.

We define a `Dog` class over lines 7-13. The `Dog` class mixes in `Swimmable` via a call to `Module#include` on line 8. The instance method `Dog#swim` is defined on lines 10-12.

The `enable_swimming` method definition body sets the `@can_swim` instance variable to `true`.

The `Dog#swim` method contains only a string `"swimming"` whose evaluation is contingent on an `if` modifier condition. The condition is whether instance variable `@can_swim` returns a truthy value. Since this is the only line, `swim` returns the string if `@can_swim` evaluates as truthy, `nil` otherwise.

On line 15, we initialize local variable `teddy` to a new `Dog` object.

On line 16, we call `swim` on `teddy`. The return value passed to the `Kernel#p` method will be `nil`. This is because we have not called `enable_swimming` on `teddy` to set the `@can_swim` instance variable to `true`. This means that `@can_swim` is uninitialized, and an uninitialized instance variable evaluates as `nil`. Therefore `swim` also returns `nil`.

This behavior demonstrates two things about instance variables. First, whereas referencing an uninitialized local variable will raise a `NameError`, referencing an uninitialized instance variable simply evaluates to `nil`. Secondly, instance variables are not directly inherited from modules or superclasses. Only instance methods and constants are inherited from mixin modules that are `include`d into a class. Since we did not call `enable_swimming` on `teddy`, there is no `@can_swim` instance variable initialized in `teddy` and any reference to it will evaluate as `nil`. We would need to call the `enable_swimming` method on `teddy` to initialize `@can_swim`. Thus instance variables are not inherited.

10m17s



3.

What is output and why? What does this demonstrate about constant scope? What does `self` refer to in each of the 3 methods above? 

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
```

On lines 1-5 we define the `Describable` module, which defines one instance method `describe_shape`. The only line in the body of the definition, line 3, returns a string involving interpolation. The first interpolation, `self.class`, will evaluate to the class of the calling object. This will be a class that mixes in `Describable` and will be resolved each time the method is called. 

The second interpolation, an unqualified constant reference, is problematic. The lexical scope of the reference, which Ruby will first search for a definition of `SIDES` does not contain one. Ruby then moves on to search the class hierarchy of the lexically-enclosing structure, `Descriabable`. Since `Describable` is a module rather than a class, there is no class hierarchy to search, so Ruby moves on to search top-level and will find no definition there either. At this point, a `NameError` will be raised.

Next, we define the `Shape` class on lines 7-17. `Shape` mixes in `Describable` with a call to `Module#include` on line 8. `Shape` defines a class method `Shape::sides` on lines 10-12. This consists solely of a qualified constant reference to `self::SIDES`. `self` in the context of a class method refers to the class itself. This could mean `Shape` or any of its subclasses, depending which class the class method is called on. The `self` reference will be resolved dynamically when the method is called.

Next, we define the `Shape#sides` instance method on lines 14-16. The only line in the method is the constant reference `self.class::SIDES`. `self` in this context refers to the calling object, an instance of `Shape` or one of its subclasses. The reference is resolved dynamically when the method is called. We call the `Kernel#class` method on `self`, returning the class of the object, and use the `::` namespace resolution operator to reference the `SIDES` constant in that class (or its inheritance hierarchy). 

The `Quadrilateral` class is defined on lines 19-21 as a subclass of `Shape`. This subclass simply defines a constant `SIDES`, which it initializes to `4`.

The `Square` class is defined as a subclass of `Quadrilateral` on line 23.

On line 25, we call the class method `sides` on `Square`. `Square` inherits this class method from `Shape`. When called on `Square`, the `self` reference resolves to `Square` and so the full reference is to `Square::SIDES`. Ruby searches `Square` directly, because of the namespace qualification, and finds a defintion, so `4` is passed to `Kernel#p` and output to screen.

On line 26, we call the `sides` instance method on a newly instantiated `Square` instance. The instance method `sides` is inherited from `Shape`. The `self` reference resolves to the new `Square` instance, and so the call to `class` resolves to `Square`. So this constant reference resolves to `Square::SIDES` and again, `4` is passed to `p`.

On line 27, we call `describe_shape` on a newly created `Square` instance and a `NameError` is raised, because there is no `SIDES` constant defined in the lexical scope of the reference, or the inheritance hierarchy of the lexically-enclosing structure, the `Describable` module.

This demonstrates that constants have lexical scope. This means that Ruby first searches the lexically enclosing structure of the reference, then any lexically enclosing structures surrounding that structure, up to but not including top-level. Then Ruby searches the inheritance hierarchy of the lexically enclosing structure of the reference, then top-level.

21m25s

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

On lines 1-24, we define a collection class called `AnimalClass`. On lines 18-24, we define a class called `Animal`.

`AnimalClass` objects use the array to which instance variable `@animals` is initialized in the constructor on line 6 in order to store `Animal` objects. The `AnimalClass#<<` method is defined on lines 9-11 to add an `animal` to the `@animals` array.

On lines 26-29, we create an `AnimalClass` whose `name` attribute is `"Mammals"` and initialize local variable `mammals` to this new `AnimalClass` object. We then add three new `Animal` objects to this collection.

On lines 31-34, we repeat this process for another `AnimalClass` object which is assigned to local variable `birds`.

On line 36, we then call `AnimalClass#+` on `mammals` with `birds` and use the return value to initialize local variable `some_animal_classes`. We might expect the return value of `AnimalClass#+` to be a new `AnimalClass` object whose `@animals` array contains the combined elements of the `mammals` `@animals` array with the `birds` `@animals` array. Instead, when we pass `some_animal_classes` to `Kernel#p` on line 36, we realize that the `Animal#+` method has returned a new Array object, containing the concatenation of the two `AnimalClass` objects' `@animals` arrays.

Since the `+` method, when defined for collection classes, normally returns a new object of the class rather than, as here, an implementation detail of the class, this is not expected or predictable behavior. The `AnimalClass#+` method does not follow the conventions of core and standard library classes.

The `AnimalClass#+` method is defined on lines 13-16, has one parameter `other_class`, which we expect to take another `AnimalClass` object, and contains only the expression `animals + other_class.animals`. The `animals` getter method is generated with a call to `Module#attr_accessor` on line 2, and returns the reference of `@animals`. This means that we are calling `Array#+` on the calling object's `@animals` array, and passing the argument object's `@animals` array as argument. The return value of this is a new Array containing the concatenation of the two arrays. This is the only expression and so the new Array forms the return value of `AnimalClass#+`.

To remedy this, we need a way of instantiating a new `AnimalClass` object with an existing array to be used to initialize the new `@animals` array. We then simply instantiate a new `AnimalClass` object to form the return value of `AnimalClass#+`, using the return value of `Array#+`. We use a default value for the `animals` parameter of the `AnimalClass#initialize` constructor to deal with ordinary cases, where `@animals` should be initialized to an empty array. Since `initialize` expects an argument for the `name` attribute, we will need to pass a temporary name.

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

Line 38 will now output an `inspect` string representation of a new `AnimalClass` object, and not an Array object.

21m22s



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

The reason the `GoodDog#change_info` method does not work as expected in the above code has to do with Ruby's syntax for calling getter methods.

Our `GoodDog` class is defined over lines 1-19. The call to `Method#attr_accessor` on line 2 generates getter and setter methods for the instance variables `@name`, `@height` and `@weight`. These include the setter methods `name=`, `height=` and `weight=`.

The `GoodDog#change_info` method, defined on lines 10-14, attempts to call these setter methods in order to set the instance variables `@name`, `@height`, and `@weight` to the objects passed as arguments to the method. This does not work, but rather creates three new local variables `name`, `height`, and `weight` that are destroyed when the `change_info` method returns.

To take a single example, line 11, the syntax `name = n` does not call the setter method `name=` implicitly on the calling object and pass `n` as argument; this is because it cannot be syntactically disambiguated from the initialization of a local variable `name` to `n`. This is not simply a matter of syntactic sugar. Even if we attempted to call the setter method with more conventional method-call syntax `name=(n)`, this still cannot be disambiguated from local variable initialization `name = (n)`.

To remedy this, we can explicitly call `name=` on the calling object by calling it on keyword `self`, which within an instance method references the calling object:

```ruby
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end
end


sparky = GoodDog.new('Spartacus', '12 inches', '10 lbs') 
sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info 
# => Spartacus weighs 45 lbs and is 24 inches tall.
```

After making that change to lines 11-13, our code outputs the expected value.

9m23s



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

The reason our above code raises a `NoMethodError` has to do with Ruby's syntax for calling setter methods and the way local variable initialization works.

We define a `Person` class over lines 1-11. The call to `Module#attr_accessor` on line 2 generates getter and setter methods for a `@name` instance variable. These include setter method `name=`. When a new `Person` object is created, the `Person#initialize` constructor initializes the `@name` instance variable to the argument passed through from `Person::new`.

The `Person#change_name` method is defined on lines 8-10. The intent is to call the `name=` method in order to set `@name` to reference the return value of calling `String#upcase` on the current value of `@name`. However, the syntax used `name = name.upcase` cannot be disambiguated from the initialization of a local variable, which is what Ruby does.

The reason this raises a `NoMethodError` is that Ruby creates the `name` local variable before it evaluates the right-hand of the initialization operator, at which point it has the value `nil`. Ruby then attempts to evaluate the right hand side of the `=` operator `name.upcase`, which now instead of calling the getter method `name` instead references the newly created local variable `name`, whose value is currently `nil`. Thus Ruby attempts to call an `upcase` method on `nil`, which does not implement one, and so a `NoMethodError` is raised.

In order to fix this, we simply need to call `name=` explicitly on the calling object, which is the reference of `self` within an instance method:

```ruby
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
  
  def change_name
    self.name = name.upcase
  end
end

bob = Person.new('Bob')
p bob.name 
bob.change_name
p bob.name
```

12m17s



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

We begin by defining the `Vehicle` class over lines 1-7. The body of the class definition begins by initializing class variable `@@wheels` to integer `4`. Next, we define a `Vehicle::wheels` class method on lines 4-6, which simply returns the reference of `@@wheels`.

On line 9, after the `Vehicle` class definition, we call class method `wheels` on `Vehicle` and pass the return value to `Kernel#p`, which outputs `4`.

Next, on lines 11-13, we define the `Motorcycle` class as a subclass of `Vehicle`. As a subclass of `Vehicle`, `Motorcycle` does not inherit the class variable `@@wheels` but actually shares it. This is to say, there is a single class variable `@@wheels` that is now shared between `Vehicle`, `Motorcycle` and any other subclasses of `Vehicle` we might create. So line 12 does not initialize or override a class variable, but rather reassigns the existing `@@wheels` variable to integer `2`.

This is why the call to `Motorcycle.wheels` on line 15 returns `2` and also why the call to `Vehicle.wheels` on line 16 now returns `2`.

We create a new `Car` class that inherits from `Vehicle` on line 18. When we call `Car.wheels` on line 22, this also returns `2`. The invocation of `wheels` on the other two classes on 20-21 still return `2`.

The total output would be:

```
4
2
2
2
2
2
```

This demonstrates that if a class initializes a class variable, that class variable will be shared by all subclasses of that class. Further, it will be shared by any subclasses of those subclasses, and so on. Therefore, the scope of a class variable is the class and all of its descendants (and all objects of all those classes).

This greatly expanded scope becomes difficult to reason about, since the variable can be reassigned from so many different places in the code base. This is why many Rubyists advise against using class variables for any class that has subclasses. Many Rubyists advise against using class variables at all.

In this case, it might be better to use a constant rather than a class variable.

```ruby
class Vehicle
  WHEELS = 4

  def self.wheels
    self::WHEELS
  end
end

p Vehicle.wheels                             

class Motorcycle < Vehicle
  WHEELS = 2
end

p Motorcycle.wheels                           
p Vehicle.wheels                              

class Car < Vehicle; end

p Vehicle.wheels
p Motorcycle.wheels                           
p Car.wheels     
```

13m12s

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

The above code outputs the `Object#inspect` string representation of a `GoodDog` object, whose instance variables `@name` and `@color` are both set to the string `"brown"`. The reason for this has to do with the use of keyword `super` in the `GoodDog#initialize` method.

We first define an `Animal` class over lines 1-7. The call to `Module#attr_accessor` on line 2 generates setter and getter methods for a `@name` instance variable. `Animal#initialize` is defined on lines 4-6 to initialize `@name` to the argument passed through from the `Animal::new` method, referenced by the `name` parameter.

We next define the `GoodDog` class as a subclass of `Animal`. `GoodDog#initialize` is defined on lines 10-13, with one parameter `color`. Line 11 calls the superclass `initialize` method using the keyword `super`. Since `super` has no parentheses, all arguments are passed through to the superclass constructor method, which in this case is the `color` variable. The `Animal#initialize` method is called and initializes its parameter `name` to `color`. It then initializes the `@name` instance variable in our `GoodDog` object to `name`, the same object referenced as `color` in the `GoodDog#initialize` method. Back in the `GoodDog#initialize` method, on line 13, we initialize instance variable `@color` to the object referenced by `color` as well.

This is why both instance variables can be seen to have the same value when we pass our `GoodDog` object `bruno` to `Kernel#p` on line 17.

In order to fix this, we need to add a `name` parameter to `GoodDog#initialize` on line 10, and add a String argument giving the dog's name when we instantiate our `GoodDog` object. Then we need to pass only the `name` parameter through to the superclass method by placing it in parentheses in our `super` call.

```ruby
class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(name, color)
    super(name)
    @color = color
  end
end

bruno = GoodDog.new("Bruno", "brown")       
p bruno
```

11m40s

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

This code will raise an `ArgumentError`. The reason has to do with the `super` keyword.

We define an `Animal` class on lines 1-4. We define the `Animal#initialize` constructor method with no parameters and no expressions in the body.

Next, we define a `Bear` class that subclasses `Animal`. The `Bear#initialize` method takes one parameter `color`. Within the body of the method definition, the first expression is `super`. When the `super` keyword is used with no parentheses, all arguments passed to the current method will be passed through to the superclass method of the same name. Since `Bear#initialize` has one parameter and `Animal#initialize` has none, this will raise an `ArgumentError`, since it means calling the superclass method with the wrong number of arguments.

When used without parentheses, `super` passes all arguments through to the superclass method of the same name. When used with empty parentheses, no arguments are passed. We can also pass specific arguments within the parentheses.

In order to remedy this broken method, we can simply place empty parentheses after the `super` keyword, like so:

```ruby
class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super()
    @color = color
  end
end

bear = Bear.new("black")        
```

6m39s

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
```

What is the method lookup path used when invoking `#walk` on `good_dog`?

On line 44, we instantiate a new `GoodAnimals::GoodDog` object, to which we initialize local variable `good_dog`. On the next line, we call `walk` on `good_dog`.

The method lookup path for a method called `walk` begins with the class of `good_dog`, `GoodAnimals::GoodDog`. This class, defined on lines 36-39, does not define a `walk` method, but does mix in two modules. These will be searched in the reverse order of the calls to `Module#include` that mix them in: `Danceable`, followed by `Swimmable`. Neither of these modules define a `walk` method, so Ruby moves on to the superclass, `Animal`. The `Animal` class, defined on lines 25-31, does not define a `walk` method, but mixes in the module `Walkable`. `Walkable` is defined on lines 1-5, and does define a `walk` method on lines 2-4. Since Ruby has found a definition for `walk`, it stops here, and this is the method that is called, returning the string `"I'm walking."`. This string is returned to be passed as argument to the invocation of `Kernel#puts` back on line 45, which outputs `"I'm walking."`.

The full method lookup path for `GoodAnimals::GoodDog`, if Ruby followed it to the end without finding a definition, would be `GoodAnimals::GoodDog, Danceable, Swimmable, Animal, Walkable, Object, Kernel, BasicObject`.

8m44s



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

On line 23, local variable `array_of_animals` is initialized to an array containing one newly-instantiated object each of classes `Animal`, `Fish`, and `Dog`.

On line 24, we call `Array#each` on `array_of_animals` with a block with the parameter `animal`. On line 25, we call the method `feed_animal` with `animal` passed as argument.

The `feed_animal` method is defined on lines 19-21 with one parameter `animal`. The method calls the `eat` method on `animal`. This method is polymorphic to the extent that we do not care what class or type of object `animal` references, so long as it responds to the `eat` method.

The classes of the objects in `array_of_animals` have been designed in such a way that the `feed_animal` method can use them polymorphically. These classes implement this polymorphism through inheritance.

The `Animal` class, defined on lines 1-5, defines an `eat` instance method. This method uses a call to `Kernel#puts` to output the string `"I eat."`.

The `Fish` class is defined on lines 7-11 as a subclass of `Animal`. `Fish` overrides the `eat` method it inherits, with an implementation that outputs `"I eat plankton."`. 

The `Dog` class (lines 13-17) is also a subclass of `Animal` and also overrides the `eat` method with its own implementation that outputs `"I eat kibble."`

Therefore, given the order of objects in the `array_of_animals`, this code will output:

```
I eat.
I eat plankton.
I eat kibble.
```

The polymorphism in this code is partly achieved through class design, with the inheritance hierarchy sharing the `eat` method interface from `Animal` to its subclasses, even if the subclasses override it with their own specialized implementations. But the runtime polymorphism actually occurs when the objects are passed to the `feed_animals` method and the method calls the `eat` method on the object, without concern for the type or class of object so long as it provides the common interface of an `eat` method. In this sense, the `feed_animal` method is a polymorphic method that only depends on its arguments responding to a common interface.

16m58s

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

We define a `Person` class on lines 1-8. The `Person#initialize` constructor takes a single argument `name` that it uses to initialize the instance variable `@name`. The method then initializes the `@pets` instance variable to an empty array. Thanks to the call to `Module#attr_accessor` on line 2, there is a `pets` getter method that will return the array referenced by `@pets`.

We define a `Pet` class on lines 10-14. This class defines a `jump` instance method, which uses `Kernel#puts` to output the string `"I'm jumping!"`

We then define `Cat` and `Bulldog` subclasses of `Pet` on lines 16 and 18 respectively.

On line 20, we initialize local variable `bob` to a newly instantiated `Person` object.1

On lines 22, we initialize local variable `kitty` to a new `Cat` object. On the next line, we initialize variable `bud` to a `Bulldog` object.

On lines 25-26, we call the `Person#pets` getter method, which returns an array. We then chain the `Array#<<` method in order to push the `kitty` and then the `bud` objects to the `bob` object's `pets` array.

On line 28, however, we call `pets` on `bob` again, and then attempt to call `jump` on the array that is returned. This will raise a `NoMethodError` since the Array class does not define a `jump` method.

This is clearly an attempt to implement polymorphism that has gone awry. We could iterate over each object in the `bob.pets` array and call `jump` on these objects. This polymorphic behavior is possible through inheritance: both `Cat` and `Bulldog` inherit a `jump` method from their superclass `Pet` and would thus respond to this common interface. In order to implement this, we could change the above code to:

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

bob.pets.each { |jumper| jumper.jump }
```

The call to `Array#each` and the polymorphic behavior of the block, which calls `jump` on an object of any type or class, so long as it implements a `jump` method, leads to the following output:

```
I'm jumping!
I'm jumping!
```

11m49s



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

We define class `Animal` on lines 1-5. The constructor `Animal#initialize` is defined with one parameter `name`. The body of the method simply initializes instance variable `@name` to `name`.

Next, we define the `Dog` class as a subclass of `Animal` (lines 7-13). `Dog` overrides the `initialize` method inherited from `Animal`. The method still takes a `name` parameter but does nothing with it, as the definition body is empty.

The `Dog#dog_name` instance method is defined on lines 10-12 with no parameters. The method body returns a string involving the interpolation of a `@name` instance variable.

On line 15, we initialize local variable `teddy` to a new `Dog` object, with the string `"Teddy"` passed as argument to the `Dog::new` class method. `new` passes the argument through to `Dog#initialize`, but the constructor does nothing with it. No `@name` variable is initialized.

So when we call `dog_name` on `teddy` on line 16 and pass the return value as argument to the `Kernel#puts` method, the output will be `"bark! bark!  bark! bark"`.

This is because an uninitialized instance variable returns `nil`, and `@name` is uninitialized in the `teddy` object. String interpolation implicitly calls `to_s` on an object in order to insert it into the string, and `NilClass#to_s` returns an empty string.

To fix this code, we could simply remove the `Dog#initialize` method so that `Dog` inherits the working implementation:

```ruby
class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def dog_name
    "bark! bark! #{@name} bark! bark!"
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name   
```

This will now output `"bark! bar! Teddy bark! bark!"`

9m18s



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

The `Person` class is defined on lines 1-7. The only instance methods defined in the class are a constructor `Person#initiailze` and the `name` getter method generated by the call to `Module#attr_reader` on line 2. The `initialize` method takes a single argument `name` and uses this to initialize the `@name` instance variable.

On lines 9-10, we instantiate two new `Person` objects and use them to initialize the local variables `al` and `alex`. The `Person` objects have strings with the same value `'Alexander'` passed through to their constructors. However, when we compare the two objects using the `==` method, on line 11, the return value that is then passed to `Kernel#p` to be output is `false`.

The reason for this is that `Person` does not override the default `==` method inherited from `BasicObject`. `BasicObject#==` compares objects based on their unique object id, which is only useful in telling us whether two variables reference the same object. Since `al` and `alex` reference two different `Person` objects, this method returns `false`.

The `BasicObject#==` method is overridden by classes that wish to implement comparison for value equivalence between objects. The `String#==` method, for instance, will return `true` if all the characters in one `String` object's value are the same as the characters in another `String` object's value, `false` otherwise.

We can implement a `Person#==` method that performs value comparison for equivalence on `Person` objects. Since the only state a `Person` object has is the `name` attribute, it seems reasonable to base our comparison on this value. This new method will use `String#==` to test the equivalence of the strings referenced by the two objects' `@name` variables.

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

Now the comparison `al == alex` returns `true`.

In order to check for whether two variables actually reference the same object, we can either compare the return values of calling `object_id` on the two variables, or use the `equal?` method, inherited from `Object`, whose purpose is to check for object identity between two references.

```ruby
p al.name.object_id == alex.name.object_id # false
p al.name.equal?(alex.name) # false
```

Here we can see that although the two String objects referenced by `al.name` and `alex.name` have the same value, they are two different String objects with different object ids.

14m14s



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

The `Person` class is defined on lines 1-11. The `Person#initialize` constructor has one parameter `name`, which it uses to initialize the `@name` instance variable. Line 2's call to `Module#attr_reader` generates a `name` getter method for the `@name` variable.

The `Person#to_s` instance method definition over lines 8-10 overrides the `to_s` method inherited from `Object`. This method, the default implementation of which returns a string containing the class name and an encoding of the object id, is commonly overridden to provide a more meaningful string representation of an object. The `to_s` method is called implicitly when an object is passed to `Kernel#puts` or interpolated into a string.

The `Person#to_s` method returns the result of interpolating the return value of calling `String#upcase!` on the instance's `name` attribute into a string: `"My name is #{name.upcase!}."`. The `String#upcase!` method is destructive. It has the side effect of modifying the string it is called on so that its characters are all in upper case. So once this method is called once, the string referenced by the `@name` instance variable will be mutated in this way. 

On line 13, we instantiate a new `Person` object whose `name` attribute will be `'Bob'`. This is the string passed through to the constructor and assigned to the `@name` instance variable. This `Person` object is used to initialize the local variable `bob`.

On line 14, we call `name` on `bob` and pass the return value to `puts`, which outputs `'Bob'`, the string assigned to the `@name` instance variable.

On line 15, we pass `bob` directly to `puts`. Since `puts` implicitly calls `to_s` on its arguments, the `Person#to_s` method is called on `bob` and `puts` outputs `"My name is BOB."`.

The call to `Person#to_s` will have the side-effect of mutating the state of the string referenced by the `@name` variable of `bob` from `"Bob"` to `"BOB"`.

Thus when on line 16 we call `name` on `bob` and pass the string return value to `puts` `"BOB"` is output, reflecting the mutation of the previous line.

```
Bob
My name is BOB.
BOB
```

12m01s



16.

**Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example.**



A setter method can perform additional work, rather than simply setting the instance variable to the argument. A setter method might format data immediately before making the data part of the object's state, or perform checks that determine if a value should become part of an object's state at all. These uses of setter methods within the class help provide a guarantee that the object is invariantly in a valid state.

It is generally safer to use a setter method even if we don't need to check or manipulate data before setting the instance variable; should requirements like these arise in the future, changes can be made in one place (the setter method) rather than everywhere in the code that needs to set the instance variable.

For instance, if we decide to split a string stored in one instance variable into two strings stored in two instance variables, this change has only to be made in one place. So if we started with this code:

```ruby
class Person
  def initialize(name)
    @name = name
  end
  
  def set_name(name)
    @name = name
  end
end

bob = Person.new("Robert Cratchit")
bob.set_name("Bob Cratchit")
puts bob.inspect # <Person:0x... @name="Bob Cratchit"
```

If we decided to split the string referenced by `@name` into two strings stored in `@first_name` and `@last_name`, we would have to change the code in both methods where the variable is set. However, if we start from this code:

```ruby
class Person
  def initialize(name)
    self.name = name
  end
  
  def set_name(name)
    self.name = name
  end
  
  def name=(name)
    @name = name
  end
end

bob = Person.new("Robert Cratchit")
bob.set_name("Bob Cratchit")
puts bob.inspect # <Person:0x... @name="Bob Cratchit"
```

We only need to change the method responsible for setting the variable:

```ruby
class Person
  def initialize(name)
    self.name = name
  end
  
  def set_name(name)
    self.name = name
  end
  
  def name=(name)
    @first_name, @last_name = name.split
  end
end

bob = Person.new("Robert Cratchit")
bob.set_name("Bob Cratchit")
puts bob.inspect # <Person:0x... @first_name="Bob", @last_name="Cratchit"
```



17.

** Give an example of when it would make sense to manually write a custom getter method vs. using `attr_reader`**

A getter method might need to format or otherwise manipulate the data tracked by the instance variable before returning the value. For instance, if an instance variable tracks a mutable collaborator object, we might wish for the getter to return a copy of the collaborator tracked by the variable so that any mutations to the return value do not affect the state of the object:

```ruby
class Person
  def initialize(name)
    @name = name
  end
  
  def name
    @name.dup
  end
end

bob = Person.new("Bob")
bob_name = bob.name
bob_name.upcase!
puts bob_name # "BOB"
puts bob.name # "Bob"
```

The getter method generated by `Module#attr_reader` can only return the reference of the variable, it will not perform any additional work that we want to do. Therefore, in situations like this we must write the method manually.



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

We define a `Shape` class on lines 1-11. When this class definition is evaluated, the expression `@@sides = nil`, on line 2, outside of any method definition, will be evaluated, and the class variable `@@sides` is initialized to `nil`. We define the instance method `Shape#sides` and the class method `Shape::sides`, both of which act as simple getter methods for class variable `@@sides`.

On lines 13-17, we define a `Triangle` class as a subclass of `Shape`. `Triangle` inherits the `Shape#sides` and `Shape::sides` methods. However, the `@@sides` class variable is not inherited from but actually shared with the `Shape` class.

Our `Triangle` class defines an `initialize` constructor method. The body of the definition sets class variable `@@sides` to `3`. This is reassignment of the class variable initialized within the `Shape` class definition on line 2. This method is called whenever a new `Triangle` object is instantiated but not before, so it is not until a `Triangle` object is created that this variable setting occurs.

On lines 19-23, we define a `Quadrilateral` class as a subclass of `Shape`. Again, we define an `initialize` constructor method. This method sets the `@@sides` class variable, shared with `Shape` and `Triangle`, to `4`. Again, this method will not return and the variable will not be set until a `Quadrilatral` object is instantiated.

So if we evaluate `Triangle.sides` after the above code has executed, the return value will be `nil`. This is because neither `Triangle#initialize` nor `Quadrilateral#initialize` has yet been called, so `@@sides` still has the value it was initialized to on line 2. If we then evaluate `Triangle.new.sides`, then the `Triangle::new` class method calls the `Triangle#initialize` method, which sets the `@@sides` variable to `3`. `Shape#sides` gets called on the newly instantiated `Triangle` object and the return value will be `3`, because the constructor has just set it.

This is because a class variable initialized in a class will be shared by any descendant classes, as well as instances of all those classes. This greatly expanded scope is potentially dangerous, since the class variable can potentially be changed from so many points in our code that it can become difficult to reason about. It is for this reason that many Rubyists discourage use of class variables.

15m20s



19.

**What is the `attr_accessor` method, and why wouldn't we want to just add `attr_accessor` methods for every instance variable in our class?**

`Module#attr_accessor` takes symbols as arguments and generates simple getter and setter methods for an instance variable of the name represented by the symbol. This is a usefully concise notation but has certain drawbacks. 

Sometimes we need the getter or setter method for a given instance variable to do additional work rather than simply returning the reference of or reassigning the variable. In this case, we have no choice but to define the method manually. `attr_accessor` is not appropriate in this situation because the methods it generates will not contain the additional functionality. So if we needed a simple getter but a more complicated setter, we might use `attr_reader` for the getter and define the setter manually.

Sometimes, for purposes of strong encapsulation, we need to define a getter method but no setter method (or less commonly vice versa) for an instance variable. This helps simplify the interface of our class and protect the state of its objects from accidental modification by client code. In this situation, `attr_accessor` would not be appropriate, since it automatically generates both setter and getter.

For instance, if had a `Person` class that tracked a `@name` and a `@date_of_birth`, we might not want the `@date_of_birth` to be changed after the `Person` object is instantiated. In this situation `attr_accessor` is not appropriate, since it would create a setter method and expose a variable that should not be liable to change after instantiation. Instead, we should use `attr_reader` for this attribute:

```ruby
class Person
  attr_accessor :name
  attr_reader :date_of_birth
  
  def initialize(name, date_of_birth)
    @name = name
    @date_of_birth = date_of_birth
  end
end

bob = Person.new("Robert", "1992-4-1")
bob.name = "Bob"
p bob # <Person:0x... @name="Bob", @date_of_birth="1992-4-1">
bob.date_of_birth = "1999-1-12" # raises NoMethodError
```



20.

**What is the difference between states and behaviors?**

State refers to the values associated to some object which are tracked by instance variables. State can change over time as the instance variables of the object are reassigned. Since an object's instance variables are individual to the object, each object has its own individual state. Which is to say, objects encapsulate state.

The behavior of an object consists in the methods available to that object, which is predetermined by the class of the object. The class can define methods itself and inherit them, whether through traditional class inheritance or mixin modules.

Classes define behaviors and objects encapsulate state. The state of an object is tracked by its instance variables. The behavior of an object is predetermined by its class and consists of the methods available to objects of that class. All objects of a class have their own, individual state, but all share the behaviors predetermined by the class.



21.

**What is the difference between instance methods and class methods?**

Instance methods are methods defined within a class definition (or within a module that has been mixed in to class). They are available to objects of the class. To call a (`public`) instance method, we need to call it on an instance of the class using the dot operator.

For example,

```ruby
class Cat
  def speak # instance method definition
    puts "meow!"
  end
end

kitty = Cat.new
# instance method invocation
kitty.speak # meow!
```

Class methods are methods that are defined on the class itself. Since objects encapsulate state, class methods are often methods that do not involve state but that are in some way related to the class. However, some class methods may involve class variables, which track information about the class as a whole.

To define a class method, we define a method within the class whose name is prepended by either the name of the class, or the keyword `self` (which references the class outside of any instance method definition) and the dot operator. To invoke a class method, we call it on the class itself using the dot operator.

For instance,

```ruby
class Temperature
  def self.celsius_to_fahrenheit(celsius) # class method defintion
    celsius * 9 / 5.0 + 32
  end
end

# class method invocation
puts Temperature.celsius_to_fahrenheit(0) # 32.0
puts Temperature.celsius_to_fahrenheit(100) # 212.0
```

Instance methods can only be called on instances of the class, while class methods can only be called on the class.



22.

**What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.**

Any object that becomes part of another object's state by being assigned to one of that object's instance variables is a collaborator object.

Any class of object can be a collaborator object, from core built-in classes that contain fundamental values, such as Integers or Strings, to custom classes that we have designed ourselves. Collaborator objects are tracked by an object's instance variables and represent the state of the object.

We call such objects collaborators because they work in collaboration with the object to fulfill its responsibilities. An object may depend on calling methods on its collaborator objects as part of its own behavior. When designing a class, it is important to think about what its significant collaborator classes are, since these collaborations define the network of communication between objects in our program and thus determine which classes of object can readily invoke methods on which other classes of object. In the design phase, the most significant collaborator classes are the ones we design ourselves, since these are the ones we have complete control over, whereas core built-in classes could be seen as more of an implementation detail, even if objects of core classes are still technically collaborator objects.

For instance,

```ruby
class Car
  def initialize
    @engine = Engine.new
  end
  
  def start
    puts @engine.start
  end
end

class Engine
  def initialize
    @started = false
  end
  
  def start
    @started = true
    "Starting engine..."
  end
end

car = Car.new
car.start # "Starting engine..."
```

Here, we define a `Car` class on lines 1-9, whose `initialize` constructor method sets an `@engine` instance variable to a newly-instantiated `Engine` object. The `Engine` class is thus a collaborator of the `Car` class. The `Car#start` instance method defined on lines 6-8, calls `start` on the `Engine` object tracked by `@engine`.

The `Engine` class is defined on lines 11-20. The `initialize` constructor sets instance variable `@started` to `false`. The `Engine#start` method sets `@started` to `true` and returns the string `"Starting engine..."`.

On line 22, we instantiate a new `Car` object to which we assign local variable `car`. Next, we call `Car#start` on `car`. The `Car#start` method calls `Engine#start` on its `@engine` instance variable, which returns the string `"Starting engine..."`, which back in the `Car#start` method is passed to the `Kernel#puts` method to be output to screen. In this way, the collaborator `Engine` object tracked by the state of the `Car` object performs part of the work of the `Car#start` method. Keeping track of whether the `Car` engine is started or not is also delegated to the `Engine` object, whose `@started` instance variable tracks a boolean object (which itself could be seen as a collaborator of the `Engine` object.)

The purpose of using collaborator objects is that they help break down the problem domain into manageable, modular pieces that can be assembled to work in conjunction with each other. Collaborator objects can further encapsulate part of an object's state, and allow the object to delegate part of the work performed by its behaviors. Thinking in terms of a class's collaborators in the design phase allows us to analyze, break down and solve complicated domain problems. 



23.

**How and why would we implement a fake operator in a custom class? Give an example.**

In Ruby, many of what appear to be operators are in fact methods defined for particular classes. Many of Ruby's built-in classes define 'fake operator' methods for objects of the class.

We define an operator method in much the same way as any other method. When defining an operator method in a custom class, it is important to respect the conventional meaning of these operators. For instance, a `+` method should perform an action strongly analogous to addition or concatenation (like `Integer#+` or `String#+`) and should return a new object of the class. If we do not respect the conventional meaning of these operators, we will make our class much harder to use.

We define our own operator methods in custom classes in order to make code more readable and expressive, providing a clean interface for the custom class that follows recognizable patterns and conventions from Ruby's core library, programming languages generally, mathematical notation and so on.

As an example, we might wish to define an `==` operator for a custom class. Following the conventional meaning of `==` in Ruby's core classes, the `==` method should check whether the principal value of an object of the class is equivalent to that of another object of the class. `==` should return `true` if the two values are equivalent, `false` otherwise.

```ruby
class House
  attr_reader :address

  def initialize(address)
    @address = address
  end
  
  def ==(other_house)
    address == other_house.address
  end
end

house1 = House.new("23 Elm Drive")
house2 = House.new("23 Elm Drive")
house3 = House.new("32 Sycamore Lane")

puts house1 == house2 # true
puts house1 == house3 # false
```

Here, we define a `House` class (on lines 1-11) with an `address` attribute. The value tracked by the `@address` instance variable seems to be a good basis for object value equivalence. Therefore, we define the `House#==` method to compare the return value of calling getter method `House#address` on the calling object and comparing it to the return value of calling `address` on the `House` object passed as argument. Since the `@address` variable tracks a String object, it is `String#==` that is called to compare these string values, returning `true` if all characters in both strings are the same, `false` otherwise.

On lines 17-18, we can see that comparing two `House` objects with the same string value for their `address` with the `House#==` method returns `true`; if the `address` is different, the `House#==` method returns `false`. The syntactic sugar for calling our custom operator method remains operator-like, just as with the `==` method for core classes (though we could call `house1.==(house2)` if we wanted).



24.

**What are the use cases for `self` in Ruby and how does `self` change based on the scope it is used in. Provide examples.

The reference of the keyword `self` in Ruby changes according to scope. Within a class definition outside of instance method definitions, `self` references the class itself. Within instance method definitions, `self` references the calling object.

For instance,

```ruby
class SelfReporter
  puts self # SelfReporter
  
  def self.who_is_self # class method
    puts self # SelfReporter
  end
  
  def who_is_self # instance method
    puts self # <SelfReporter:0x...>
  end
end

puts SelfReporter.who_is_self # SelfReporter
puts SelfReporter.new.who_is_self # <SelfReporter:0x...>
```

There are two very common use cases for `self`. The first is when defining class methods, such as the definition for`SelfReporter::who_is_self` above on line 4. Here, `self` references the class, so it returns the name of the class on which we are defining the class method. Using `self` instead of the literal name of the class means that if the name of the class changes we do not need to change the name for all class methods.

The other very common use case for `self` is when calling setter methods within instance methods within the class. Here, `self` references the calling object. When a method is called in an instance variable with no explicit receiver, the method is implicitly called on the calling object. However, for setter methods, Ruby cannot disambiguate that syntax from local variable initialization (because of the syntactic sugar that coats setter methods). In order to disambiguate the setter method call, we must call the setter method explicitly on the calling object, using `self` to reference it:

```ruby
class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end
  
  def change_name(new_name)
    self.name = new_name
  end
end

kitty = Cat.new("Felix")
puts kitty.name # Felix
kitty.change_name("Fluffy")
puts kitty.name # Fluffy
```

Here, on line 9, it is necessary to use `self` to call the `name=` setter method. If we had written `name = new_name` this would initialize a `name` local variable to the reference of `new_name`.



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

On lines 1-9, we define a `Person` class. The `initialize` constructor method is defined on lines 2-4 with one parameter `n` which it uses to initialize instance variable `@name`. The `Person#get_name` instance method is defined on lines 6-9. The method returns the reference of instance variable `@name`.

On lines 11-12, we instantiate two `Person` objects by calling the class method `new` on `Person`. We assign these two objects to local variables `bob` and `joe`. The string passed in to the constructor for `bob` is `"Bob"` and the string passed to the `joe` object's constructor is `"Joe"`.

On lines 14, we call the `inspect` method on `bob` and pass the return value to `Kernel#puts`. It is clear from the output that `@name` has been initialized to `"Bob"`, the string that we passed to `Person::new`. Likewise, when we call inspect on `joe` on the next line and pass the return value to `puts`, the output makes it clear that `joe` has its own separate `@name` variable that references the string `"Joe"`.

This demonstrates that instance variables are scoped at the object level. A class predetermines what instance methods are available to an object. Instance methods can initialize instance variables when they are called on an object. This includes the `initialize` constructor method called by class method `new` when an object is instantiated with all arguments passed through. Although instance methods are shared by all objects of a class, the instance variable initialized in an object when an instance method is called on that object will be individual to that object. Once initialized, an instance variable can continue to exist for the lifetime of the object.

9m54s



26.

How do class inheritance and mixing in modules affect instance variable scope? Give an example

Instance variables are scoped at the object level. Inheritance, whether class inheritance or inheritance via mixin modules, does not change this, and instance variables themselves are not directly inherited. However, instance variables can only be initialized by an instance method being called on an object, and instance methods are inherited.

If an instance method is inherited from a superclass or module, and that instance method is called on the object, then that method can initialize instance variables in the object. This can only happen once the instance method is called.

For example,

```ruby
module Nameable
  def name=(name)
    @name = name
  end
end

class Person
  def age=(age)
    @age = age
  end
end

class Student < Person
  include Nameable
end

brian = Student.new
p brian # <Student:0x...>
brian.name = "Brian"
brian.age = 25
p brian # <Student:0x... @name="Brian", @age=25>
```

Here, we define a `Student` class on lines 13-15 as a subclass of `Person`, defined on lines 7-11. `Student` also mixes in the `Nameable` module, defined on lines 1-5.

We instantiate a new `Student` object on line 17, to which we initialize local variable `brian`. On line 18, we pass `brian` to the `Kernel#p` method, and it is clear from the output that `brian` does not currently contain any instance variables.

On line 19, we call `name=` on `brian` with the string `"Brian"` passed as argument. Ruby searches the method lookup path for objects of class `Student` and finds a `name=` method defined in module `Nameable`. This method is defined (lines 2-4) with one parameter `name`, which it uses to initialize instance variable `@name` in the calling object. Thus line 19 will initialize a new instance variable in the `brian` object to the string `"Brian"` and this instance variable is individual to the `brian` object.

On line 20, we call `age=` on `brian` with the integer `25` passed as argument. Ruby searches the method lookup path for `Student` and finds an `age=` method defined in the superclass `Person` (lines 8-10). This method takes one parameter `age` and uses it to initialize instance variable `@age` in the calling object, in this case `brian`.

Thus when we again pass `brian` to the `p` method, on line 21, the output demonstrates that the methods inherited from a superclass and a mixin module have initialized instance variables in an object that has access to them through inheritance.

Regardless of where an instance method is defined in the inheritance hierarchy, the scope of the instance variables it initializes will be that of the calling object.



27.

How does encapsulation relate to the public interface of a class?

Encapsulation means hiding functionality from the rest of the code base behind a publicly exposed interface. Thus the notion of a public interface is integral to the concept of encapsulation.

Encapsulation in Ruby is achieved by defining classes and instantiating objects. The public interface to a class is comprised of its public methods, or specifically, the signatures of those methods: names, number of parameters, and expected return values. What public methods are available to a class defines how client code can interact with an object of the class.

The separation of interface from implementation through encapsulation reduces code dependencies by restricting the parts of a class that client code can interact with. Thus client code becomes dependent only on a carefully designed, simplified view of the object, rather than on its implementation or representation. This enhances the maintainability of code by letting us change implementation details of a class safe in the knowledge that as long as the interface remains consistent we will not break existing code that depends on the class.

Hiding the representation of an object behind its public interface also serves to protect data from undesirable modification by restricting access to an object's state to methods designed to work with the object's instance variables by the class author. This permits us, for instance, to perform checks on arguments to public setter methods before assigning the argument to the instance variable. Unlike some languages, Ruby does not permit direct public access to instance variables at all, meaning all public access to an object's instance variables must be mediated by deliberately defined public methods (getters and setters).



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

In the first example, the `GoodDog` class , defined on lines 1-10, is exactly the same as the definition in the second example (lines 20-29). In both examples, the `sparky` local variable is initialized to a new `GoodDog` object, whose constructor is passed the arguments `"Sparky"` and `4`.

The difference in output has to do with which method is passed the `sparky` object. In the first, it is the `Kernel#puts` method (line 13) and in the second, the `Kernel#p` method (line 32).

The `Kernel#puts` method implicitly calls the `to_s` method of any object passed to it as argument. Here, the `GoodDog` object, having no `to_s` method defined in its class, will have the `Object#to_s` method called on it. `Object#to_s` returns a string of the format `<ClassName:0x...>`, where `ClassName` is the name of the class and `0x...` represents an encoding of the object id (the specific value of which will only be decided at runtime for most objects).

The `Kernel#p` method implicitly calls `inspect` on objects that are passed to it as arguments. For the `GoodDog` object `sparky`, this will be the inherited `Object#inspect` method. `Object#inspect` returns a string similar in format to `Object#to_s` but with a list of the object's instance variables and their current values.

Therefore, the first example outputs a string containing only `GoodDog` and an encoding of the object id, whereas the second outputs a string that also includes the instance variables `@name` and `@age` and their values, respectively `"Sparky"` and `4`.

We could output a message of our choice in the first example by simply overriding the `to_s` method. All that is necessary is to define a `to_s` instance method in the `GoodDog` class that returns the string we wish. It is important to return a String object, as otherwise Ruby would call `Object#to_s` to obtain a String return value.

For example, we could do this:

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
  
  def to_s
    "#{@name} is #{@age} in dog years"
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky # "Sparky is 28 in dog years"
```

12m16s

