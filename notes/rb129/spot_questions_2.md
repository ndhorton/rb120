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

On line 9, we instantiate a new `Person` object `bob`. On line 10, we call `name` on `bob` and pass the return value to `Kernel#p` as argument. This will output `nil`.

The `Person` class is defined on lines 1-7. We generate a getter method for instance variable `@name` with a call to `Module#attr_reader`. We define the `set_name` method, which sets `@name` to `'Bob'`.

Since we never called `set_name` on `bob`, the instance variable `@name` was never initialized. So when we called `name` on `bob`, the getter method referenced an uninitialized instance variable. Whereas a reference to an uninitialized local variable raises a `NameError` exception, a reference to an uninitialized instance variable evaluates to `nil` (without initializing the variable).

4m17s

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

we define module `Swimmable` on lines 1-5. In the module, we define the instance method `enable_swimming`. The body of the method sets instance variable `@can_swim` to `true`.

On lines 7-13, we define the `Dog` class, which mixes in module `Swimmable`. We define the `Dog#swim` instance method which returns `"swimming"` if `@can_swim` references a truthy value. If `@can_swim` evaluates as false, the method will return `nil`, since there is no other expression to be evaluated.

On line 15, we instantiate a new `Dog` object `teddy`. On line 16, we call `swim` on `teddy` and pass the return value to `Kernel#p` to be output. The output will be `nil`.

This is because we never called `enable_swimming` on `teddy`. Thus the instance variable `@can_swim` was never initialized in `teddy`. When the `swim` method was called, the reference to `@can_swim` therefore evaluated as `nil`, since uninitialized instance variable references always evaluate as `nil`. `nil` evaluates as false in a boolean context, so the expression `"swimming"` was never evaluated. Since there is no other expression in the method, `swim` returned `nil`.

5m52s





3. [cannot be answered in reasonable timeframe, just too many things going on here]

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

This code will output

```
4
4
```

and then raise a `NameError`.

The first `4` is the return value of calling `Square.sides` on line 25. Class `Square` (defined on line 23) inherits the class method `Shape::sides` defined on lines 10-12. This method uses the namespace resolution operator to make a dynamic reference to a constant `SIDES`. The `self` before the `::` operator references the class (whichever class it is called on). So when called on `Square`, `self::SIDES` resolves to `Square::SIDES`. Since there is no `SIDES` constant in `Square`, Ruby searches the inheritance chain of `Square`, and finds `SIDES` defined in the immediate superclass `Quadrilateral` as `4` (line 20).

The second `4` that was output is from calling the instance method `Shape#sides` (defined on lines 14-17) on a new `Square` instance. This instance method works in much the same way as the class method of the same name. `self.class::SIDES` evaluates to `Square::SIDES`, and again Ruby searches the inheritance chain to find the `Quadrilateral::SIDES` definition.

The `NameError` arises when we call `describe_shape` on a `Square` instance on line 27. The string interpolation in the body of this method (line 3) makes an unqualified constant reference to `SIDES`. When Ruby encounters a constant reference without namespace qualification, it first searches lexically of the reference, searching the lexical structure surrounding the reference, and then any outer structures that structure is nested within up to but not including toplevel. Then Ruby searches the inheritance chain of the lexically enclosing structure, and finally toplevel. Since the `Describable` module where `describe_shape` is defined does not contain a definition for `SIDES`, modules do not inherit, and there is no `SIDES` constant defined at toplevel, Ruby raises a `NameError`.

This example demonstrates that constants in Ruby have lexical scope. An unqualified constant reference is resolved first through a lexical search, then an inheritance search starting from the class or module surrounding the reference, then a toplevel search. If it still cannot be resolved, Ruby raises a `NameError`.

A constant reference with a namespace qualification will search the named class or module, then the inheritance chain of that class or module, then toplevel.

12m08s

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

The `Animal` class is defined on lines 18-24. The `AnimalClass` class defined on lines 1-16 is defined as a container class for `Animal` objects. We can see from the `initialize` constructor that the `Animal` objects are stored in an array referenced by the instance variable `@animals`, which has getter and setter generated for it with a call to `Module#attr_accessor` on line 2.

We instantiate two `AnimalClass` objects (lines 26 and 31) and add `Animal` objects to their `animals` arrays using the `AnimalClass#<<` method.

Then on line 36, we call the `AnimalClass#+` method and store the return value in `some_animal_classes`. On line 38, we pass `some_animal_classes` to `Kernel#p` to be output. The output will be a representation of an Array object: `[#<Animal:0x00007f7a05c29760 @name="Human">, #<Animal:0x00007f7a05c29620 @name="Dog">, #<Animal:0x00007f7a05c295a8 @name="Cat">, #<Animal:0x00007f7a05c29468 @name="Eagle">, #<Animal:0x00007f7a05c293c8 @name="Blue Jay">, #<Animal:0x00007f7a05c29328 @name="Penguin">]`.

This behavior is not what we would expect from a `+` method as it does not respect the conventional meaning of `+`.

The `+` method appears as an operator because of its syntactic sugar, but it is a method. The conventional meaning of the method should be respected so that defining a `+` method in our class makes it easier to use, and our code easier to understand, rather than more difficult. The conventional meaning for `+` is either addition, or, as is the case for container classes, concatenation. The return value of `+` should be a new object of the calling class. This means our `AnimalClass#+` method should return a new `AnimalClass` object, not an Array.

To remedy this we need to make changes to the `AnimalClass#initialize` constructor to allow us to create a new object with an existing `animals` array. Then we need to change the `+` method definition itself:

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

8m50s



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

The reason our `change_info` method fails to change the state of our `sparky` `GoodDog` object has to do with the syntax for calling setter methods.

On line 22, we instantiate a new `GoodDog` object, `sparky`, passing three strings through to the constructor. We can see from the definition of `GoodDog#initialize` (lines 4-8), that these strings are used to initialize the `@name`, `@height`, and `@weight` instance variables.

On line 23, we call the `GoodDog#change_info` method with three new strings passed as arguments. We can see from the return value of `GoodDog#info`, passed to `Kernel#puts` on line 24, that the instance variables of `sparky` have not been reassigned by `change_info`.

The `GoodDog#change_info` method is defined on lines 10-14 with three parameters `n`, `h`, and `w`. The body consists of what seem like attempts to call the `name=`, `height=` and `weight=` setter methods to reassign the appropriate instance variables to the values of the parameters.

However, this syntax actually initializes three new local variables `name`, `height` and `weight`. Normally, we can call an instance method of the class from within another instance method of the class on the calling object implicitly, without having to reference the calling object explicitly with `self` or use the dot operator. However, for setter methods whose name ends in `=`, the syntax for calling the setter implicitly on the calling object cannot be disambiguated from the syntax for initializing a new local variable. Thus it is necessary to call the setter method explicitly on `self` using the dot operator. Within an instance method, `self` references the calling object.

Thus we could change the method to

```ruby
  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end
```

And our code would work as expected.

8m26s

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

The reason that our call to `change_name` invocation on `bob` on line 15 raises a `NoMethodError` exception is to do with the syntax for calling setter methods, as well as the order in which assignments are evaluated.

The `Person#change_name` method is defined on lines 8-10. The only expression in the body of the method is `name = name.upcase`. This is surely an attempt to call the simple setter method `name=`, which was generated with a call to `Module#attr_accessor` on line 2. When we call an instance method of the class within the class within another instance method definition, we can normally implicitly call the method on the calling object by simply not using the dot operator or naming an object on which to call the method. However, setter methods whose names end in `=` are a special case. The syntax for calling such a method implicitly on the calling object cannot be disambiguated from the initialization of a new local variable. Thus it is necessary to call the method explicitly on `self`, which within an instance method references the calling object.

The reason for the exception is that Ruby first evaluates the `name =` and determines that we are initializing a new local variable, `name`. `name` is temporarily set to `nil` while Ruby evaluates the right-hand subexpression `name.upcase`. Since `name` already shadows the getter method `Person#name`, `name` evaluates to `nil`, the temporary value of the local variable being initialized. Thus we attempt to call a method `name` on `nil`, which has no such available method. This raises the `NoMethodError`.

To fix this we can simply change line 9 to `self.name = name.upcase`

7m47s

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

We define the `Vehicle` class over lines 1-7. On line 2, we initialize the `@@wheels` class variable to `4`. Since this takes place outside of any method definition, this initialization takes places as soon as Ruby evaluates the class definition. We define a `Vehicle::wheels` class method that returns the reference of `@@wheels`.

On line 9, we call `wheels` on `Vehicle` and output the return value: `4`.

On lines 11-13, we define the `Motorcycle` class as a subclass of `Vehicle`. On line 12, we reassign the `@@wheels` class variable to `2`, and again this happens as soon as `Motorcycle` is evaluated. The reason that this is reassignment is to do with how inheritance affects class variable scope. Once a class variable is initialized in a class, the variable will be shared with all descendant classes of that class, even if the subclasses are defined after the initialization takes place. This greatly expanded scope is why Rubyists advise against using class variables with class inheritance.

On lines 15-16, the calls to `Motorcycle.wheels` and `Vehicle.wheels` will both return `2` to be output by `Kernel#p`, reflecting the reassignment of the shared class variable in the `Motorcycle` definition.

We define `Car` as a subclass of `Vehicle` on line 18.

Again, the calls to `Vehicle.wheels`, `Motorcycle.wheels`, and `Car.wheels` on lines 20-22 will all return `2` to be output.

7m06s

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

On line 16, we instantiate a new `GoodDog` object `bruno`, passing the string `"brown"` through to the constructor.

On line 17, we pass `bruno` to the `Kernel#p` method, which implicitly calls `Object#inspect` on the object before outputting the string representation returned by `inspect` to the screen. The output will be similar to `<GoodDog:0x... @name="brown", @color="brown">`. 

The reason for the output has to do with the way the `super` keyword works. The `GoodDog#initialize` constructor is defined with one parameter `color`, which was assigned to the string `"brown"` when we instantiated `bruno`. On the first line of the body, we use the `super` keyword. `super` calls the method of the same name next in the method lookup path, in this case `Animal#initialize`. The superclass method takes one parameter `name`. When we use `super` without parentheses, Ruby automatically passes all arguments to the subclass method call through to the superclass method call. So `name` is assigned to the string `"brown"`. The body of `Animal#initilaize` initializes instance variable `@name` to `name`, which references `"brown"`, and returns. Back in `GoodDog#initialize`, we use the `color` parameter to initialize `@color` to `"brown"`.

This code demonstrates that `super` called without trailing parentheses will call the method of the same name next in the method lookup path, passing all arguments to the subclass method through to the superclass method.

6m09s

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

This code will raise an `ArgumentError` exception.

The reason has to do with the use of keyword `super` in the `Bear#initialize` constructor.

We attempt to instantiate a new `Bear` object on line 13, passing the string `"black"` through to the constructor.

The `Bear` class is defined on lines 6-11 as a subclass of `Animal` (lines 1-4). The `Bear#initialize` method takes one parameter, `color`, which on this invocation is assigned to `"black"`.

The first line of the method body uses the keyword `super` to call the method of the same name next in the method lookup path, in this case `Animal#initialize`. `super`, used without trailing parentheses, will pass all arguments to the subclass method through to the superclass method. Since `Animal#initialize` is defined without parameters, this will raise an `ArgumentError`. We can use `super()` with empty parentheses to call the superclass method without passing any arguments through. This is what we could do in this scenario. We can also pass specific arguments by placing them in the parentheses like regular method call syntax.

5m

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

The method lookup path when we invoke `walk` on `good_dog` on line 45 begins with the class of the `good_dog` object, `GoodAnimals::GoodDog`. Ruby searches the class and finds no `walk` method, so the search continues in each of the mixin modules that have been mixed into the class in the reverse order of the calls to `Module#include` that mixed them in: `Danceable`, then `Swimmable`. The `walk` method has still not been found, so Ruby moves on to the superclass, `Animal`.

The `Animal` class does not define a `walk` method, so Ruby now searches the mixed in module `Walkable`. The `Walkable` module defines a `walk` method. Ruby finds this `walk` method and executes it.

The full method lookup path for `GoodAnimals::GoodDog` objects would be `[GoodAnimals::GoodDog, Danceable, Swimmable, Animal, Walkable, Object, Kernel, BasicObject]`

4m35s

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

Polymorphism is the ability of different types of data, or different classes of object, to respond to a common interface, often in different ways.

On line 23, we initialize local variable `array_of_animals` to an array containing an `Animal` object, a `Fish` object, and a `Dog` object.

On the next line, we call `each` on the array, passing each element in turn to the block to be assigned to the block parameter `animal`. Within the block, on line 25, we pass the object currently referenced by `animal` to the `feed_animal` method. Note that no check has been performed on the class or type of object passed to the block.

The `feed_animal` method is defined on lines 19-21 with one parameter `animal`. The body of the method simply calls an `eat` method on any object passed to it. Like the block, the method does not check the class or type of the object.

We can see from the class definitions on lines 1-21 that all classes of all objects in the array define an `eat` method, and what the output will be for the three objects in the array when `each` block passes them to `feed_animal` and the method calls `eat` on them:

```
I eat.
I eat plankton.
I eat kibble.
```

The `feed_animal` method does not care which class an object belongs to, simply that it exposes a compatible `eat` method. This is polymorphism in action, since our client code is not concerned with the specific type or class of object, only that it exposes the right interface, the `eat` method.

The reason this work is that our classes have been designed to implement polymorphism. This polymorphic structure has been implemented through class inheritance. We define an `eat` method in the superclass `Animal`. Both `Fish` and `Dog` inherit this interface from the superclass, although both subclasses choose to override the method with a more specialized implementation of their own.

"The interface for this class hierarchy lets us work with all of those types in the same way even though the implementations may be dramatically different. That is polymorphism"

"Looking at this example, we can see that every object in the array is a different animal, but the client code can treat them all as a generic animal, i.e. an object that can `move`. Thus, the public interface lets us work with all of these types in the same way even though the implementations can be dramatically different. That is polymorphism in action."

9m45s

12. [do not bother with this, it doesn't make any clear sense as a series of questions]

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

On line 15, we initialize local variable `teddy` to a new `Dog` object, passing the string `"Teddy"` through to the constructor. On line 16, we call `dog_name` on `teddy` and pass the return value to `Kernel#puts` to be output. The output will be `"bark! bark! bark! bark!"`.

The reason for this has to do with method overriding.

The `Dog` class is defined on lines 7-13 as a subclass of `Animal` (lines 1-5). The `Dog#initialize` constructor overrides the `Animal#initialize` constructor. The superclass method takes one parameter `name` and uses it to initialize the `@name` instance variable. The `Dog#initialize` method overrides this implementation with an empty method body. The consequence is that for `Dog` objects, the `@name` instance variable is never initialized.

The `Dog#dog_name` method is defined on lines 10-12. The body of the method returns a string with a `@name` instance variable interpolated into it: `"bark! bark! #{@name} bark! bark!"`. However, since no `@name` instance variable has been initialized, this is a reference to an uninitialized instance variable. Any reference to an uninitialized instance variable evaluates to `nil`, unlike a reference to an uninitialized local variable, which would raise a `NameError`. Since string interpolation implicitly calls `to_s` on objects interpolated, `nil.to_s` is implicitly called, returning an empty string.

6m16s



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

The reason that the call to `==` returns `false`, on line 11, is that we have not defined a `==` method for the `Person` class, and so the default `BasicObject#==` method is called.

`==` can appear as an operator because of the syntactic sugar around its invocation, yet it is a method rather than a real operator. `==` is overridden by classes that intend to make use of it. The conventional meaning of the method is that is compares the principal object value of the calling object with that of the argument, returning `true` if their values are considered equivalent, `false` otherwise.

However, `BasicObject#==` uses as the object id as the principal object value. Since an object id is unique to each object, this has the effect of testing if caller and argument are the same object. Since we are comparing two different `Person` objects, `al` and `alex`, this call to `==` returns `false`.

We can fix this code to return `true` by defining a `Person#==` method that uses the `name` attributes of `Person` objects as the principal object value to check for equivalence. Since `name` references a String, the work of the method will be pushed back to `String#==`:

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

This does not mean that the String referenced by the `@name` instance variable of `al` is the same String object as the String referenced by `alex`'s `@name` variable. `String#==` checks whether the string value of two String objects can be considered equivalent (because they have the same characters), not whether the two objects are equivalent. Since we used a literal constructor each time for the strings we passed through the the constructor when `al` and `alex` were instantiated on lines 13-14, they are different String objects, though they have the same characters.

We can confirm this by comparing the object ids of the return value of calling `name` on each object:

```ruby
al.name.object_id == alex.name.object_id # => false
```

9m29s

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

The output from lines 14 to 16 will be:

```
Bob
My name is BOB.
BOB
```

The reason for this has to do with how we have defined the `to_s` method in `Person`.

The conventional meaning of a `to_s` is to return a String representation of the calling object without mutating the state of the calling object. This is not what happens with `Person#to_s`.

The sole line of the method definition body, line 9, returns a string with string interpolation: `"My name is #{name.upcase!}."` Here, we call the destructive `String#upcase!` method on the `name` attribute of our `Person` object. Since this method mutates its caller, the string referenced by `@name` will be permanently changed when the method is called.

The `to_s` method is implicitly called when an object is passed to `Kernel#puts`, as we do with `bob` on line 15. This is why the output from `puts bob.name` differs on line 16 (after `to_s` has been called) from what it was on line 14.

To fix this, we can simply use the non-mutating `String#upcase` method instead:

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "My name is #{name.upcase}."
  end
end

bob = Person.new('Bob')
puts bob.name # "Bob"
puts bob # "My name is BOB."
puts bob.name # "Bob"
```

6m38

16.

```ruby
# Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example.
```

The reason it is generally considered safer to invoke a setter method within the class rather than setting an instance variable directly is that it decouples the methods that need to change an attribute from the representation of objects of the class. This reduces dependencies within the class and makes our code more maintainable.

For instance, if we needed to add logic to perform a check or manipulation on a value before assigning it to the instance variable, we can do that within the setter method rather than everywhere the attribute needs to be changed. This means less repetition of logic, making errors easier to debug, since the logic is only in one place.

For example, if we have a class like so:

```ruby
class Person
  attr_accessor :age
  
  def initialze(age)
    self.age = age
  end
  
  # ...
end
```

we can add logic to the setter without having to change all methods that change the value of `age` attribute.

```ruby
class Person
  attr_reader :age

  def initialze(age)
    self.age = age
  end
  
  def age=(new_age)
    if new_age > 0 && new_age < 150
      @age = new_age
    end
  end
  
  # ...
end
```

Further, we could even change how data is stored, perhaps split over two different instance variables, and as long as we retain the same interface of the setter method, we do not need to update any other methods.

8m13s





17.

```ruby
# Give an example of when it would make sense to manually write a custom getter method vs. using `attr_reader`.
```

`Module#attr_reader` generates a simple getter method that returns the reference to the instance variable named by the Symbol argument to `attr_reader`. Whenever we need to add more logic than this, we must write the getter method manually.

Generally, we write manual getter methods when we wish to format, partially conceal, or otherwise manipulate the data tracked by the instance variable before returning it.

For example, if we wished to store a `name` attribute in a format suitable for database queries, say upper case, but have the getter method return the `name` in a human-readable capitalized format, we might write the `name` getter as follows:

```ruby
class Employee
  def initialize(name)
    @name = name.upcase
  end
  
  def name
    @name.split.map(&:capitalize).join(' ')
  end
  
  # rest of class omitted...
end

tom = Employee.new("Thomas Jones")
p tom #<Employee:0x... @name="THOMAS JONES">
p tom.name # "Thomas Jones"
```

5m45s



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

We define a `Shape` class on lines 1-11. Within the class outside any method definition, we initialize the class variable `@@sides` to `nil`, on line 2. This will be executed as soon as Ruby encounters the class definition. We define the `Shape::sides` and `Shape#sides` instance methods that both return the reference of the `@@sides` class variable.

We define two subclasses of `Shape`, `Triangle` (lines 13-17) and `Quadrilateral` (lines 19-23). `Triangle#initialize` sets `@@sides` to `3`. This will be executed when a new `Triangle` object is instantiated. This is the same class variable initialized on line 2. `Quadrilateral#initialize` sets `@@sides` to `4`. Again, this is the same class variable initialized in the superclass on line 2.

If we execute `Triangle.sides` the return value (with the code so far) will be `nil`, since neither a `Triangle` nor a `Quadrilateral` have been instantiated yet.

If we execute `Triangle.new.sides` the return value will be `3`, since the `Triangle::new` class method implicitly calls the `Triangle#initialize` method, which sets `@@sides` to `3`.

What this code demonstrates is that a class variable initialized in a superclass is shared between all descendant classes and all instances of all those classes. This greatly expanded scope is why Rubyists often advise against using class variables with class inheritance. The enlarged scope can cause many of the problems with code dependencies and difficulty of reasoning that OOP and encapsulation are intended to ameliorate.

6m37s





19.

```ruby
# What is the `attr_accessor` method, and why wouldn’t we want to just add `attr_accessor` methods for every instance variable in our class? Give an example.
```

The `Module#attr_accessor` method takes Symbols as arguments and generates simple getters and setters for each instance variable whose name is represented by a Symbol argument.

There are two main reasons we would not want to use `attr_accessor` for every instance variable in a class.

First, `attr_accessor` generates setter methods that simply set the instance variable to an argument, and getter methods that simply return the reference of the instance variable. If we wish to add any logic, we need to write either getter or setter manually.

Secondly, since `attr_reader` generates both setter and getter at the same time, they will be at the same level of method access control. If we wanted a `public` simple reader and a `private` simple setter method, we could use `Module#attr_reader` and `Module#attr_writer` after the appropriate access control modifiers, or we could write the methods manually if we wished to add more logic.

As an example, if we needed a `private` simple setter and a `public` getter method that obscured some of the data tracked by an instance variable, we might write:

```ruby
class Customer
  def initialize(credit_card_number)
    self.credit_card_number = credit_card_number
  end
  
  def credit_card_number
    "xxxx-xxxx-xxxx-#{@credit_card_number[-4..-1]}"
  end
  
  private
  
  attr_writer :credit_card_number
end

dave = Customer.new('4239-9823-2918-1234')
puts dave.credit_card_number # "xxxx-xxxx-xxxx-1234"
dave.credit_card_number = '3287-9873-2342-4321' # raises NoMethodError, private method called
```

9m23s

20.

```ruby
# What is the difference between states and behaviors?
```

Objects encapsulate state and classes group behaviors.

An object's state, tracked by its instance variables, is unique to that object and distinct from every other object, even those of its own class.

The behaviors, or instance methods, available to an object are predetermined by the class of that object, and those behaviors are shared with every other object of the class.

The set of potential instance variables available to be initialized in an object are determined by the class in that instance methods initialize instance variables. But any instance variable initialized in the calling object by a method is distinct to that object and separate from the instance variable of the same name in another object of the class, tracking the distinct state of that object.

5m26s

21.

```ruby
# What is the difference between instance methods and class methods?
```

Instance methods are the behaviors available to an object. They are defined within the class definition with the keyword pair `def...end` with the name of the method immediately following `def`. Instance methods can only be called on objects, or instances, of the class.

Class methods are defined on the class itself and can only be called on the class itself. The keyword `self`, which outside of instance method bodies references the name of the class, is prepended to the name of the method using the dot operator when the class method is defined.

Since objects encapsulate state, instance methods usually deal with the state of individual objects, and instance variables can only be accessed within instance methods.

Class methods are often stateless, though class variables can be used to track information about the class as a whole.

As an example,

```ruby
class Cat
  @@total_cats = 0
  
  def initialize(name)
    @name = name
    @@total_cats += 1
  end
  
  def self.total_cats
    @@total_cats
  end
  
  def speak
    puts "#{@name} says meow!"
  end
end

puts Cat.total_cats # 0

fluffy = Cat.new("Fluffy")
tom = Cat.new("Tom")

fluffy.speak # Fluffy says meow!
tom.speak # Tom says meow!

puts Cat.total_cats # 2
```

7m17s



22.

```ruby
# What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.
```

A collaborator object is an object that becomes part of another object's state. A collaborator object helps the containing object carry out its responsibilities.

A collaborator object might be of any class including custom classes. The collaborator might become part of another object's state directly by being assigned to one of the containing object's instance variables, or indirectly through an intermediate data structure such as an Array.

Collaborations are important to consider from the design stage onwards, since collaborations between classes represent the network of communications between the actors in our program: objects. If an object contains a reference to another object as part of its state, it can easily invoke methods on the collaborator as part of its own functionality.

As an example,

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#{@name} says meow!"
  end
end

class Owner
  attr_reader :pet

  def initialize(name, pet)
    @name = name
    @pet = pet
  end
end

fluffy = Cat.new("Fluffy")
mike = Owner.new("Mike", fluffy)

mike.pet.speak # "Fluffy says meow!"
```

23.

```ruby
# How and why would we implement a fake operator in a custom class? Give an example.
```

In Ruby, fake operators are methods that appear as operators due to the syntactic sugar surrounding their invocation. They can be defined in our custom classes like any other method, but we can then use operator-like syntax to invoke them.

So long as we respect the conventions of meaning established by the Ruby core classes and standard library, custom fake operators can make our code more readable and our classes easier to use. For instance, the `+` method conventionally denotes an operation analogous to addition or concatenation. If we define `+` to mean something else, then we make our classes harder to use and our code less readable.

The `==` method conventionally compares the principal object value of the caller for equivalence with the object value of the argument. As an example of defining a custom `==` method:

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

house1 = House.new('23 Elm Drive')
house2 = House.new('72 Sycamore Lane')
house3 = House.new('23 Elm Drive')

puts house1 == house2 # false
puts house1 == house3 # true
```



24.

```ruby
# What are the use cases for `self` in Ruby, and how does `self` change based on the scope it is used in? Provide examples.
```



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



26.

```ruby
# How do class inheritance and mixing in modules affect instance variable scope? Give an example.
```



27.

```ruby
# How does encapsulation relate to the public interface of a class?
```



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



29.

```ruby
# When does accidental method overriding occur, and why? Give an example.
```



30. [should possibly be broken into parts]

```ruby
# How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers.
```



31.

```ruby
# Describe the distinction between modules and classes.
```



32. [half an hour's worth of stuff]

```ruby
# What is polymorphism and how can we implement polymorphism in Ruby? Provide examples.
```



33.

```ruby
# What is encapsulation, and why is it important in Ruby? Give an example.
```



34. [Don't bother with this, weak question]

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



35. [problems it solves are in one of the quizzes, lesson 1 I think]

```ruby
# What is Object Oriented Programming, and why was it created? What are the benefits of OOP, and examples of problems it solves?
```



36.

```ruby
# What is the relationship between classes and objects in Ruby?
```



37.

```ruby
# When should we use class inheritance vs. interface inheritance?
```



38.

```ruby
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new


# If we use `==` to compare the individual `Cat` objects in the code above, will the return value be `true`? Why or why not? What does this demonstrate about classes and objects in Ruby, as well as the `==` method?
```



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



49.

```ruby
number = 42

case number
when 1          then 'first'
when 10, 20, 30 then 'second'
when 40..49     then 'third'
end


# What methods does this `case` statement use to determine which `when` clause is executed?
```



50. [probably should be several questions, the second instance variable doesn't actually exist either since there is no way for it to be set]

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

