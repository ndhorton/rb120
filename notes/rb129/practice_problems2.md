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

We define a `Person` class on lines 1-7. On line 2, we generate a getter method for a `@name` instance variable with a call to `Module#attr_reader`. We define a `Person#set_name` method on lines 5-6. The method definition body sets `@name` to `"Bob"`.

On line 9, we initialize local variable `bob` to a new `Person` object. On line 10, we call `Person#name` on `bob`, and pass the return value to `Kernel#p` to be output. The output will be `nil`.

This is because the `@name` instance variable whose reference is returned by `Person#name` has not been initialized. We have not called the `Person#set_name` method and the variable is not set by a constructor.

This demonstrates that in Ruby referencing an uninitialized instance variable evaluates to `nil` (without causing the variable to be initialized to `nil`). This is different from the behavior of local variables. Referencing a local variable before initializing it will raise a `NameError`.

5m51s



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

We define a `Dog` class on lines 7-13. We define one instance method in the class itself, the `Dog#swim` method (lines 10-12). This method is defined to return `"swimming!"` if the `@can_swim` instance method is initialized to reference a truthy value; otherwise the method will return `nil`.

The `Dog` class mixes in the `Swimmable` module (lines 1-5). The `Swimmable` module provides the instance method `enable_swimming`. This method is defined on lines 2-4, and the body of the definition simply sets a `@can_swim` instance variable to `true`.

We instantiate a `Dog` object on line 15, and then on line 16 we call `Dog#swim` on it, passing the return value to the `Kernel#p` method. This will output `nil`.

The reason is that we have not called `enable_swimming` on our `Dog` object, so the `@can_swim` instance variable is uninitialized. The reference to the uninitialized instance variable in the `if` modifier condition on line 11 in `Dog#swim` evaluates to `nil` since an uninitialized instance variable in Ruby will always evaluate to `nil`. Since `nil` is falsy, the `if` condition fails and since there is no other expression to evaluate, the method returns `nil`.

This demonstrates two things about Ruby. First, as noted, referencing an uninitialized instance variable evaluates to `nil`, without initializing the variable to `nil`. Secondly, instance variables are not directly inherited from mixin modules or class inheritance. The method `enable_swimming` needs to be actually invoked on a `Dog` object before the `@can_swim` instance variable that it sets will be initialized.

9m19s



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

We define a `Shape` class on lines 7-17. `Shape` mixes in module `Describable` (defined on  lines 1-5). The `Quadrilateral` class is defined as a subclass of `Shape` (lines 19-21). On line 23, we define `Square` as a subclass of `Quadrilateral`.

On line 25, the argument to the `Kernel#p` method is a call to the class method `sides` on the `Square` class. The `sides` method is inherited from the `Shape` class, and is defined on lines 10-12. This method returns a reference to the constant `self::SIDES`. The `self` keyword used in a class method references the class itself, dynamically, so that the class referenced in this method call is `Square` and Ruby will attempt to find a `SIDES` constant in `Square` before searching its inheritance hierarchy. `Square` does not define a `SIDES` constant, so Ruby moves on to `Quadrilateral` which defines `SIDES` as `4`. Thus the integer `4` is what is returned and output on line 25.

On line 26, we call the instance method `sides` on a newly created `Square` instance before passing the return value to `p` to be output. This calls the inherited `Shape#sides` instance method, defined on lines 14-16. This method calls the `Kernel#class` method on `self` in the expression `self.class::SIDES`. Since `self` in an instance method resolves to the calling object, and the `class` method returns the class of the caller, this expression resolves to `Square::SIDES` once more. The same constant lookup path is then followed as before, returning `4` to be output by `p`.

On line 27, we call the `describe_shape` instance method on a new `Square` instance before passing the return value to `p`. The `describe_shape` method is inherited from the `Describable` module, mixed in to the `Shape` ancestor class of `Square`. `describe_shape` is defined on lines 2-4 to return a string involving the interpolation of two expressions, `self.class` and `SIDES`. `self.class` evaluates to the class of the instance method's calling object, which is `Square` in this case.

The unqualified reference to `SIDES` causes Ruby to search lexically of the reference. Ruby searches the lexically enclosing structure of the reference, in this case the `Describable` module where no such constant is defined. Ruby would widen the search to any other lexically enclosing structures up to but not including top-level, but there are none. Next, Ruby attempt to search the inheritance hierarchy not of the caller's class but rather the lexically enclosing structure of the reference, in this case the `Describable` module. Since there is no inheritance hierarchy for a module, Ruby then searches the top-level, but finds no `SIDES` constant defined here either. At this point, a `NameError` is raised.

If we wanted to reference the definition for `SIDES` in `Quadrilateral`, we could change the unqualified reference on line 3 to `self.class::SIDES`, as in the other methods. `self` in an instance method always references the calling object, and the namespace operator `::` allows us to begin our search at the specified class before moving to that class's inheritance hierarchy rather than searching lexically of the reference itself.

18m26s.

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

On lines 1-16, we define a collection class called `AnimalClass`. Objects of this class will serve as a collection of `Animal` objects. The `Animal` class itself is defined on lines 18-19. The `AnimalClass` class uses an Array object to store the `Animal` objects that are added to the collection using the `AnimalClass#<<` method defined on lines 9-11. The array is referenced by the instance variable `@animals` initialized in the constructor on line 6.

The `AnimalClass#+` method is defined on lines 13-15. This method takes another `AnimalClass` object as argument, used to initialize parameter `other_class`. The method definition body calls the `animals` getter method (generated by a call to `Module#attr_accessor` on line 2), to return the calling objects' `@animals` array. We then call `Array#+` on that array, and call `animals` on `other_class` to pass the other `AnimalClass` `@animals` array as argument. This will return a new Array object that is a concatenation of caller and argument. Since this is the last evaluated expression, this new Array is what `AnimalClass#+` returns.

On lines 26-29, we build an `AnimalClass` collection object, referenced by local variable `mammals`, containing three `Animal` objects. On lines 31-34, we build another `AnimalClass` collection referenced by `birds` containing another three `Animal` objects. When we initialize local variable `some_animal_classes` to the return value of calling `AnimalClass#+` on `mammals` with `birds` passed as argument, the return value will be a new Array object. This is what is passed to `Kernel#p` on line 38, a string representation thereof being output to screen.

This behavior is contrary to the conventions established by Ruby's core and standard library classes. The `+` operator is in fact a method, and can be defined or overridden in custom classes like any other method. Conventionally, the `+` method performs an operation analogous to either addition or, in the case of collection classes, concatenation. However, the return value is conventionally expected to be a new object of the caller's class, here the `AnimalClass` class. Instead, our method is defined to return a new Array, which is not predictable by convention.

To remedy this, we can use the new Array object to instantiate a new `AnimalClass` object before returning that from `AnimalClass#+`:

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
    new_animals_array = animals + other_class.animals
    AnimalClass.new("temporary name", new_animals_array)
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

p some_animal_classes.class

```

Here, we have modified the `AnimalClass#initialize` method defined on lines 4-6 so that we can instantiate a new `AnimalClass` with an Array passed to the second parameter `animals` to be used to initialize `@animals` on line 6. We provide a default value of an empty array for `animals` in order to keep the interface consistent with existing code.

We then modify the `AnimalClass#+` method so that the new Array object is used as the second argument to the constructor of a new `AnimalClass` object, with `"temporary name"` passed as the required first argument.

So as we can see from the output of line 27, the object returned by `AnimalClass#+` is now an `AnimalClass` object.

19m07s





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

The above code outputs a string that reflects the initial state of the `GoodDog` object `sparky` because the `GoodDog#change_info` method has failed to reassign the instance variables of `sparky`.

`Sparky#initialize` initializes three instance variables `@name`, `@height`, and `@weight` (lines 5-7). These variables have setter and getter methods generated by the call to `Module#attr_accessor` on line 2. The `change_info` method attempts to use the setter methods `name=`, `height=`, and `weight=` (lines 11-13). This does not work.

The reason has to do with the syntax for calling setter methods within a class. When we call a method within an instance method definition without using the dot operator on an explicit caller, we are implicitly calling the method on the calling instance. However, the syntax for calling a setter method without an explicit caller cannot be disambiguated from the initialization of a new local variable. So when on line 11 we attempt to call setter method `name=`, we are actually initializing a new local variable `name`. The three new local variables initialized by `change_info` are then simply destroyed when the method returns. This is why `change_info` does not change the state of the caller, and why we receive the wrong output on line 24.

To remedy this, we can explicitly call the setter methods on the calling instance by using the `self` keyword, which within an instance method definition references the caller. This will disambiguate the calls to setter methods from the initialization of new local variables.

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
```

8m41s



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

We define the `Person` class on lines 1-11. The `initialize` constructor method has one parameter `name` which it uses to initialize instance variable `@name`. Setter and getter methods for this variable are generated with the call to `Module#attr_accessor` on line 2.

On line 13, we initialize local variable `bob` to a new `Person` object, passing the string `"Bob"` to the constructor, which will use it to initialize the instance variable `@name` in our `bob` object. On the next line, the call to `Person#name`, the return value of which is passed to `Kernel#p` to be output, confirms this. 

On line 15, we call the `Person#change_name` method on `bob`. This method is defined on lines 8-10. The body of the method appears as though it is reassigning the `@name` instance variable to the return value of calling `String#upcase` on the return value of the `name` getter method. However, this is not the case.

When a method is called with no explicit caller within an instance method, the implicit caller is the calling object. Thus it might seem like the body of the `change_name` method, `name = name.upcase` is calling `name=` on the calling object. However, this syntax cannot be disambiguated from the initialization of a new local variable `name`, which is what actually happens here. The `name` local variable is destroyed at the end of the method call, and the state of the calling object remains unchanged.

Thus when we call `Person#name` on `bob` again on line 16 and pass the return value to `p`, the output is `"Bob"` without the effect of the `upcase` method.

In order to change this so that the `name` attribute of `bob` is changed to the uppercase version, we need `Person#change_name` to call `name=` explicitly on `self`, which references the calling object in an instance method definition:

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

The output from line 16 will now be `"BOB"`.

10m30s



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

We define a `Vehicle` class on lines 1-7. Within the class definition outside of any method definition we initialize the class variable `@@wheels` to `4`. We define a class method `Vehicle::wheels` on lines 4-6 to return the value of `@@wheels`.

When we call `wheels` on `Vehicle` on line 9 and pass the return value to `Kernel#p` to be output, we can see that the value of `@@wheels` is `4`.

Next, we define a `Motorcycle` class as a subclass of `Vehicle`. As a subclass, `Motorcycle` will not inherit the `@@wheels` class variable but actually shares it with `Vehicle`. Thus line 2 is a reassignment of the same `@@wheels` variable to the integer `2`. `Motorcycle` inherits the class method `wheels`.

So the calls to `Motorcycle::wheels` and `Vehicle::wheels` on lines 15-16 both return `2`.

On line 18, we define the `Car` class as a subclass of `Vehicle`. The calls to `Vehicle::wheels`, `Motorcycle::wheels` and `Car::wheels` on lines 20-22 will all return `2`, since this is what `@@wheels` was last set to.

This demonstrates that class variables are not inherited but shared between the class in which the variable is initialized and all of its subclasses (and all instances of all those classes). This greatly expanded scope can pose great problems in readability and debugging, making it difficult to reason about where modification of the class variable is happening in the code base, similarly to the problems of global variables. Due to these problems, many Rubyists advise against using class variables when working with inheritance.

9m29s

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

We define an `Animal` class on lines 1-7. The call to `Module#attr_accessor` on line 2 generates setter and getter methods for a `@name` instance variable. The `Animal#initialize` constructor is defined on lines 4-6 with one parameter `name`, which it uses to initialize instance variable `@name`.

We define the `GoodDog` class on lines 9-14 as a subclass of `Animal`. The `GoodDog#initialize` method overrides the constructor of the superclass. `GoodDog#initialize` has one parameter, `color`. The definition body uses the `super` keyword on line 11 to call the method of the same name that is next along the inheritance hierarchy, `GoogDog#initialize`. When called without parentheses, `super` will pass all arguments to the subclass method through to the superclass method. Here, the reference of the `color` parameter is passed as argument to the superclass method where it is assigned to the parameter `name` and then used to initialize a `@name` instance variable in the `GoodDog` instance. After the superclass method returns, the reference of `color` is used again to initialize the instance variable `@color`, back in the `GoodDog#initialiize` method.

So when we initialize local variable `bruno` to a new `GoodDog` object, on line 16, with the string `"brown"` passed to the constructor, this string will be used to initialize both the `@name` and `@color` instance variables. We confirm this on line 17 by passing `bruno` to the `Kernel#p` method which calls `Object#inspect` on the `GoodDog` object to return a string containing the instance variables and their values.

This demonstrates that `super` called without parentheses will pass all arguments through to the superclass method. If we wanted to fix this, we could add a second parameter to `GoodDog#initialize` for the `name` attribute of the `GoodDog` object. Then we could use parentheses to pass only this `name` argument through to the superclass constructor:

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
p bruno # <GoodDog:0x... @name="Bruno", @color="brown">
```

10m01s



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

On line 13, we attempt to instantiate a new `Bear` object and this raises an `ArgumentError`.

The reason this happens has to do with the use of the `super` keyword in the `Bear#initialize` constructor on line 8.

The `Bear` class (lines 6-11) is a subclass of the `Animal` class (lines 1-4). `Animal#initialize` is defined with no parameters. `Bear#initialize` (lines 7-10) is defined with one parameter `color`. When, on line 8, the `super` keyword is used to call the superclass method `Animal#initialize`, we are using the keyword without parentheses. This causes all arguments to `Bear#initialize` to be passed through to the superclass method. Since `Animal#initialize` takes no arguments, an `ArgumentError` is raised.

This points to the way the `super` keyword uses parentheses. `super` without trailing parentheses passes all arguments to the subclass method through to the superclass. `super()` with empty parentheses calls the superclass method without passing any arguments. We can also use the parentheses to pass any specific objects we wish to the superclass method.

To fix this code, we need simply add empty parentheses after the `super` keyword.



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

7m01s



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

On line 44, we initialize local variable `good_dog` to  a new `GoodAnimals::GoodDog` object. On line 45, we call the instance method `walk` on this object.

The method lookup path Ruby traverses is as follows. Ruby first searches the class of the object, `GoodAnimals::GoodDog`. No `walk` method is defined here, so Ruby next searches the mixed in modules in the reverse order of their inclusion via `Module#include`: first `Danceable`, then `Swimmable`. No `walk` method is found, so Ruby searches the superclass `Animal`. No `walk` method is defined here, so Ruby searches the mixed in module `Walkable`, where it finds a `walk` method definition.

If we were to call the `Module#ancestors` method on the `GoodAnimals::GoodDog` class, the full method lookup for objects of this class would be `GoodAnimals::GoodDog, Danceable, Swimmable, Animal, Walkable, Object, Kernel, BasicObject`.

6m23s



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

We define an `Animal` class on lines 1-5. `Animal` has one instance method, `Animal#eat`. The method body calls `Kernel#puts` to output the string `"I eat."`.

We define class `Fish` as a subclass of `Animal` (lines 7-11). `Fish` overrides the `eat` instance method, to pass the string `"I eat plankton."` to `puts`.

Class `Dog` is defined as another subclass of `Animal` (lines 13-15). `Dog` also overrides `eat`, to pass the string `"I eat kibble."` to `puts`.

On lines 19-21 we define a top-level method, `feed_animal`, with one parameter `animal`. The body of the method calls an `eat` method on `animal`.

On line 23 we initialize local variable `array_of_animals` to a new Array containing an `Animal` object, a `Fish` object, and a `Dog` object. On line 24, we call the `Array#each` method on `array_of_animals` with a block. The block has one parameter `animal` to which each object in the array is passed in turn.

The body of the block passes the object currently referenced by `animal` to the `feed_animal` method.

The output from this `each` call will be

```
I eat.
I eat plankton.
I eat kibble.
```

This is because the `eat` method is called in turn on `Animal`, `Fish`, and `Dog` objects.

This demonstrates how class inheritance can be used to implement polymorphic structure. The `Animal` class defines an `eat` method that is inherited (though overridden with a more specialized implementation) by the subclasses `Fish` and `Dog`. The `feed_animal` method shows us polymorphism in action, since the method does not perform any check on the class or type of the objects it is passed, but simply requires the object expose an `eat` method. Since we are passing it objects from the inheritance hierarchy described, `feed_animal` can call a compatible `eat` method on each object in turn and they will respond appropriately.

This illustrates how polymorphism can be implemented through class inheritance, so that objects of different types can respond to a common interface, often with different implementations, here through method overriding.

10m50s



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



The `Person` class is defined on lines 1-8. `Person#initialize` is defined on lines 4-8 with one parameter `name`, which it uses to initialize instance variable `@name`. The method definition also initializes instance variable `@pets` to an empty array.

We generate setter and getter methods for `@name` and `@pets` on line 2 with a call to `Module#attr_accessor`.



The `Pet` class is defined on lines 10-14. Instance method `Pet#jump` is defined on lines 11-13. The body of the definition simply passes the string `"I'm jumping!"` to `Kernel#puts` to be output to screen.

We then define classes `Cat` and `Bulldog` as subclasses of `Pet` (lines 16-18).

On line 20, we initialize local variable `bob` to a new `Person` object. On line 22, we initialize local variable `kitty` to a `Cat` object. On line 21, we initialize local variable `bud` to a `Bulldog` object.



On line 25, we call getter method `pets` on `bob` and chain `Array#<<` on the array returned with `kitty` passed as argument. On the next line we do the same thing with `bud`. At this point, the `@pets` array of `bob` has had `kitty` and `bud` added to it. `kitty` and `bud` thus represent collaborator objects with respect to our `Person` object since they have become part of the `Person` object's state.

The code as it stands raises a `NoMethodError` because on line 28 we attempt to call a `jump` method on an Array object, which provides no such method. We call the getter method `Person#pets` on `bob`, which returns an Array. In a sense, this Array is also a collaborator object of the `Person` object, though it is an object of a built-in class, and its main purpose is an implementation detail to encapsulate `Pet` objects. This is why calling `jump` on the return value of `pets` raises an exception.

In order to achieve the probable intent of this code, we need to iterate over the array returned by `bob.pets`:

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

This will output

```
I'm jumping!
I'm jumping!
```

12m06s



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

On lines 1-5, we define an `Animal` class. The `Animal#initialize` constructor is defined on lines 2-4 with one parameter `name`, which is used to initialize instance variable `@name`.

We define the `Dog` class on lines 7-13 as a subclass of `Animal`. On line 8, `Dog` overrides the `Animal#initialize` method. `Dog#initialize` has one parameter, but the method body is empty.

On lines 10-12 we define the instance method `Dog#dog_name`. This method returns a string with the `@name` instance variable interpolated: `"bark! bark! #{@name} bark! bark!"`.

On line 15, we initialize local variable `teddy` to a new `Dog` object. We pass the string `"Teddy"` to the `Dog#initialize` method via `Dog::new`, but since the constructor method definition is empty, no instance variable is initialized to this string.

On line 16, we call `Dog#dog_name` on `teddy` and pass the return value to `Kernel#puts`. This outputs `bark! bark!  bark! bark!`.

The reason is that `Dog` has overridden the `Animal#initialize` method with an empty implementation, so `@name` is never initialized. 

When we interpolate an object into a string, as on line 11, the appropriate `to_s` method is called implicitly on the object. Here, we are referencing an uninitialized instance variable, `@name`, and in Ruby, a reference to an uninitialized instance variable evaluates to `nil`. This is very different to local variables; a reference to an uninitialized local variable will raise a `NameError`. The `NilClass#to_s` method returns an empty string, and so nothing is meaningfully interpolated into the string on line 11 that the `dog_name` method returns to be output by `puts`.

In order to rectify this, we can simply remove the `Dog#initialize` empty definition, and the `Animal#initialize` implementation will be found in the method lookup path when a new `Dog` is constructed.

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

This will now output `bark! bark! Teddy bark! bark!` as expected.

11m08s

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

The reason the code currently returns `false` is that we have not overridden the default implementation of the `==` method, inherited from the `BasicObject` class.

The `==` method appears as an operator in Ruby, but this is syntactic sugar -- it is a method like any other and can be overridden. The conventional usage of `==` is to compare the principal values of two objects for equivalence. However, `BasicObject#==` compares the object id of the two objects as the principal value. This means that `BasicObject#==` returns `true` only if the objects being compared are the same object.

To remedy this, we can simply override the `==` method in our custom class. Since the only state tracked by our `Person` objects is the `name` attribute, we will use this as the object value to compare for equivalence. Since `name` tracks a string, we will use `String#==` to compare the `name` values for equivalence.

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

This code now outputs `true`.

This does not mean that the strings tracked by `al.name` and `alex.name` are the same. We pass a new string constructed through literal notation for each of the two objects, so they are not the same String object.

We can check this by comparing the object id of the two object's `name` strings, either by calling `object_id` on each string and comparing their ids with `Integer#==` or by using the `equal?` method, whose purpose is to compare two references to determine if they are references to the same object:

```ruby
p al.name.object_id == alex.name.object_id # false
p al.name.equal?(alex.name) # false
```

Both these lines will output `false` since the strings are not the same object, though they have the same principal object value: `"Alexander"`.

10m07s



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

We define a `Person` class on lines 1-11, whose `initialize` constructor has one parameter `name`, which is used to initialize the instance variable `@name`. On line 2, we generate a getter method for `@name` with a call to `Module#attr_reader`.

We define a `Person#to_s` method on lines 8-10. The `to_s` method is conventionally overridden to provide a custom string representation for objects of a custom class. `Person#to_s` returns a string interpolated into which is the return value of calling the destructive method `String#upcase!` on the return value of calling the `name` getter method. This will permanently change the value of the object referenced by `@name`.

On line 13, we initialize local variable `bob` to a new `Person` object with the string `"Bob"` passed through to the constructor. When we call getter method `name` on `bob` on the next line and pass the return value to `Kernel#puts`, we can see that `@name` in `bob` has been set to `"Bob"`.

On line 15, we pass `bob` to `puts`. This implicitly calls `Person#to_s` on `bob`, the return value of which is output by `puts`: `"My name is BOB."`. For the reason stated above, this method permanently mutates `bob` object's `name` string to `"BOB"`

Thus, when we again pass the return value of `bob.name` to `puts` on line 16, the output will be `"BOB"`.

Since we generally do not want the `to_s` method to mutate the state of the calling object, we can rectify this by using the non-mutating `String#upcase` method on line 9 instead of `upcase!`:

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
puts bob.name
puts bob
puts bob.name
```

The final line now outputs `"Bob"`, which is consistent with Ruby's conventions.

9m10s



16

Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example.



Instance variables can be set from any instance method within the class. However, it is generally considered safer to invoke an available setter method than it is to set an instance variable directly because a setter method can encapsulate the logic that has to deal with setting the variable in a single place. This permits us to change this logic in one place only -- the setter method --rather than in every place in the class where the variable is set. Further, we could decide to actually change the way objects of the class track the data being stored by the setter (e.g. storing parts of the data in multiple instance variables instead of one) without breaking existing code. Separating the logic that directly sets the variable from the places in the class where the variable needs to be set allows us later to add manipulations or checks on data before it is allowed to become part of the object's state, without affecting the other methods in the class.

As an example, if we begin with this code:

```ruby
class Person
  def initialize(name)
    self.name = name
  end

  def name=(name)
    @name = name
  end
  
  def name
    @name
  end
end

mike = Person.new("mike")
puts mike.name # "mike"
```

We can decide we always want to ensure that the `name` string of a `Person` object is capitalized before we allow the string to be tracked by the object's `@name` variable. Since we call the setter method on line 3 rather than setting the variable directly we can simply change the logic of the setter method itself.

```ruby
class Person
  def initialize(name)
    self.name = name
  end
  
  def name=(name)
    @name = name.capitalize
  end
  
  def name
    @name
  end
end

mike = Person.new("mike")
puts mike.name # "mike"
```

In a class where there are many instance methods that need to set the variable, only having to change the setter method logic itself rather than the code at the many places where the variable needs to be set allows for code reuse and avoids repetition. This reduces the chance of error and makes for more maintainable code.

16m46s



17

Give an example of when it would make sense to manually write a custom getter method vs. using `attr_reader`.



Rather than generating a simple getter method using `Module#attr_reader`, we might write a custom getter method whenever we need to manipulate or partially obscure the data tracked by the variable before returning it.

As an example, we may wish to store a string in a format that is suitable for one purpose, such as database queries, but generally want a different format for human readable purposes. For instance, we could store a `name` string in lowercase format and then have our getter method convert the string to a capitalized format before returning it.

```ruby
class Person
  def initialize(name)
    @name = name.downcase
  end
  
  def name
    @name.split.map(&:capitalize).join(' ')
  end
end

mike = Person.new("Mike Smith")
puts mike.inspect # <Person:0x... @name="mike smith"
puts mike.name # "Mike Smith"
```

6m36s



18

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

We define a `Shape` class on lines 1-11. The class variable `@@sides` is initialized to `nil` within the `Shape` class outside of any method definition. This variable is set when Ruby encounters the class definition. The class method `Shape::sides` (lines 4-5) and the instance method `Shape#sides` (lines 8-10) both act as getter methods for `@@sides`.

The `Triangle` class is defined on lines 13-17 as a subclass of `Shape`. The `Triangle#initialize` constructor, which is only executed when called implicitly during the instantiation of a new `Triangle` object, sets class variable `@@sides` to `3`. This is a reassignment of the same `@@sides` variable initialized in the `Shape` definition above. This is because a class variables is not inherited but actually shared by all descendant classes of the class in which it is initialized, as well as all instances of all these classes. This greatly expanded scope is why many Rubyists advise against using class variables in classes that have subclasses.

On lines 19-23, the `Quadrilateral` class is defined as another subclass of `Shape`. The `Quadrilateral#initailize` constructor sets the same `@@sides` variable initialized in `Shape` to `4`. Again, this will only happen once the constructor is called during instantiation.

So if we execute `Triangle.sides` after this code, the return value from the inherited class method `sides` will be `nil`, the value `@@sides` was initialized to on line 2, since we have not instantiated any subclass objects. If we call `Triangle.new.sides`, we instantiate a new `Triangle` object, which executes the reassignment on line 15. So the return value of the inherited instance method `sides` will now be `3`, reflecting the reassignment.



13m53s



19

What is the `attr_accessor` method, and why wouldn’t we want to just add `attr_accessor` methods for every instance variable in our class? Give an example.



The `Module#attr_accessor` method takes Symbol objects as arguments. For each Symbol, simple getter and setter methods will be generated for an instance variable whose name is the Symbol value with an `@` prepended. For instance,

```ruby
class Cat
  attr_accessor :name
end

cat = Cat.new
cat.name = "Fluffy"
puts cat.name # "Fluffy"
```

The call to `attr_accessor` on line 2 generates the simple getter and setter methods we call on lines 6-7 on a `Cat` object.

There are multiple reasons why we would not call `attr_accessor` for every instance variable in a class. Since the getter and setter are generated at the same level of method access control, we cannot have a `public` getter and a `private` setter, for instance, if we use `attr_accessor`. Since we wish to restrict the public interface of a class to be as simple as possible, we should especially avoid generating public getters and setters that expose unnecessary details of an object or that might lead to accidental modification of an object's state by client code.

Another reason would be if we needed a custom getter to manipulate the data tracked by an instance variable before returning it. Similarly, we may want a custom setter. Since `attr_accessor` only generates simple getters and setters, and generates both getter and setter at the same time, it is not a good fit for these cases. If we needed a simple getter or a simple setter we could use `Module#attr_reader` or `Module#attr_writer` respectively.

12m09s



20

What is the difference between states and behaviors?

Objects encapsulate state and classes group behaviors.

An object's state tracks the data associated to it. Every object has its own state distinct from all other objects, even objects of the same class. The state of an object is tracked by its instance variables. Each object has its own unique instance variables.

A class predetermines what behaviors are available to all objects of the class. Thus all objects of a class have their own distinct state but they share the behaviors defined by their class. These behaviors are the instance methods defined in the class definition.

The instance variables of an object are unique to that object, even though objects of the same class may have the same set of names for their instance variables, since these variables are initialized by instance methods.

For instance,

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#@name says meow!"
  end
end

cat1 = Cat.new("Fluffy")
cat2 = Cat.new("Tom")

cat1.speak # "Fluffy says meow!"
cat2.speak # "Tom says meow!"
```

We can see from lines 14-15, that both `Cat` objects, `cat1` and `cat2`, share access to the `speak` behavior defined in the `Cat` class (lines 6-8). However, each object has a unique `@name` instance variable interpolated into the string on line 7, each set to a different string when the objects were instantiated on lines 11-12, which results in different output from the `Cat#speak` instance method.

9m49s



21.

What is the difference between instance methods and class methods?

Instance methods can only be called on an instance of a class. This means we must instantiate an object of the class to call the method on. Every instance of the class has the ability to call any instance method defined in the class.

Class methods are called directly on the class itself.

We define an instance method of a class within a class definition using the keyword pair `def...end` with the name of the method following `def`.

We define a class method within a class definition similarly to instance methods but we prepend `self.` to the name of the method.

```ruby
class Cat
  def what_am_i
    "a Cat object"
  end
  
  def self.what_am_i
    "the Cat class"
  end
end

fluffy = Cat.new
puts fluffy.what_am_i # "a Cat object"
puts Cat.what_am_i # "the Cat class"
```

In the above code, the method defined within the `Cat` class on lines 2-4 is an instance method. We must call it on an instance of the `Cat` class, as on line 12. The method defined on lines 6-9 is a class method. We can call it directly on the `Cat` class itself, as on line 13. We do not need to instantiate a `Cat` object to call class method `Cat::what_am_i`.

Since objects encapsulate state, instance methods often (though not always) operate with or on the state of the object tracked by the object's instance variables. Class methods generally do not operate on persistent state, though some class methods may make use of class variables, which can be used to track details of the class as a whole.

Instance methods have access to instance variables (of the calling object) and class variables, whereas class methods only have access to class variables.

9m15s



One thing I missed but probably an edge case rather than something you need to mention:

Both instance methods and class methods are inherited by subclasses. However, only instance methods can be inherited from a mixin module. Methods that are defined on a module using the syntax for defining class methods (sometimes called module methods) are not inherited as class methods by a class that mixes in the module.



22.

\# What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.



Any object that becomes part of another object's state is a collaborator object.

The relationship between an object and its collaborator objects is a 'has-a' relationship.

Any class of object can be a collaborator object, objects of built-in classes such as String or Integer as well as objects of custom classes.

We call such objects collaborators because they work in collaboration with the object to fulfill its responsibilities. An object may depend on calling methods on its collaborators as part of its own behavior.

When designing a class, it is important to think about what its significant collaborator classes are, since these collaborations define the network of communication between objects in our program, determining which classes of object will be able to readily invoke a method on another class of object. Collaborations represent the connections between actors in our programs.

In the design phase, the most significant collaborations are between classes we define ourselves. Built-in classes can be seen as more of an implementation detail, though objects of built-in classes that form part of an object's state are still technically collaborator objects.

As an example,

```ruby
class Car
  def initialize
    @engine = Engine.new
  end
  
  def start_car
    puts "Turning the ignition key..."
    @engine.start
  end
end

class Engine
  def start
    puts "The engine starts..."
  end
end

my_car = Car.new
my_car.start
# Turning the ignition key...
# The engine starts...
```

Here, we have designed a `Car` class (lines 1-10) and an `Engine` class (lines 12-16). The `Engine` class collaborates with the `Car` class to fulfill its responsibilities.

As soon as we instantiate a `Car` object, as on line 18, the `Car#initialize` method (defined on lines 2-4) instantiates an `Engine` object to which the `@engine` instance variable is initialized. At this point, the new `Engine` object is a collaborator object of the `my_car` object.

On line 19, we call the `Car#start` method on `my_car`. This method (defined on lines 6-9) makes use of the behavior of the `Engine` object to fulfill the `Car` object's own responsibilities, calling `Engine#start` on `@engine` on line 8.

The purpose of thinking in terms of collaborations between objects is that it helps break down the problem domain into manageable, modular pieces that can be assembled to work in conjunction with each other. Collaborator objects can further encapsulate part of an object's state as well as allowing the object to delegate part of the work it needs to carry out to another actor. This delegation allows us to break up a complex problem into small pieces. Thinking in terms of a class's collaborators in the design phase allows us to analyze and solve complicated problems at the problem domain level.



23.

\# How and why would we implement a fake operator in a custom class? Give an example.



Many operators in Ruby are actually methods that can be defined or overridden in custom classes. When defining an operator method, it is important to respect the conventional usage of the operator in Ruby's core classes. For instance, the `+` operator conventionally signifies an operation analogous to addition or concatenation, so it would be confusing to users of the class to define the method to do something else entirely. Furthermore, Ruby's built-in classes define `+` to return a new object of the class, so we should respect this convention.

We can define a fake operator method similarly to any other method. Once defined, the method can then be called using the special fake operator syntactic sugar. For instance:

```ruby
class Tree
  attr_reader :height

  def initialize(height)
    @height = height
  end
  
  def >(other_tree)
    height > other_tree.height
  end
end

tree1 = Tree.new(14)
tree2 = Tree.new(16)

puts tree1 > tree2 # false
puts tree2 > tree1 # true
```

Here we have defined a `Tree` class on lines 1-11. A `Tree` as defined here has one attribute, its `height`, and we have defined a custom `>` method (lines 8-10) to compare the height of the caller (left hand operand) and the argument (right hand operand). The `>` method is conventionally defined to compare the principal attribute of an object with another object of the same class, returning `true` if the caller is greater with respect to the value of this attribute, and `false` if the argument is greater in value. `Tree#>` achieves this by calling the `Tree#height` method on the calling object and comparing the return value to the return value of calling `height` on the `Tree` passed as argument. This comparison is actually made using `Integer#>`, since that is the class of object with which the `height` is represented.

The main reason to define fake operator methods is to provide a familiar, expressive and readable interface for our classes. This is why it is important to respect the conventional semantics of the operators we are defining as methods.

15m42s

The `House#==` with `address` as the principal attribute is probably a more logical example, since it is not completely intuitive that we compare trees based on height, whereas an address uniquely defines a house.

```ruby
class House
  attr_reader :address
  
  def initalize(address)
    @address = address
  end
  
  def ==(other_house)
    address == other_house.address
  end
end

house1 = House.new("23 Elm Drive")
house2 = House.new("82 Sycamore Lane")
house3 = House.new("23 Elm Drive")

puts house1 == house2 # false
puts house1 == house3 # true
```



24.

\# What are the use cases for `self` in Ruby, and how does `self` change based on the scope it is used in? Provide examples.

In Ruby, the keyword `self` will reference different objects depending on context.

When used in a class definition outside of any instance method definition, `self` references the class itself. This is why we prepend `self` and the dot operator to define a class method on the class. Within a class method definition, `self` still references the class.

Within an instance method definition, `self` references the calling instance. This is a dynamic way of referencing the particular object on which the instance method is called during any given invocation.

As a demonstration:

```ruby
class SelfConscious
  puts self # "SelfConscious"
  
  def self.who_is_self
    puts self
  end
  
  def who_is_self
    puts self
  end
end

SelfConscious.who_is_self # "SelfConscious"
SelfConscious.new.who_is_self # <SelfConscious:0x...>
```

We define a `SelfConscious` class on lines 1-10. On line 2, within the class definition outside of any method definition we output the reference of `self` by passing it to `Kernel#puts`. This outputs the name of the class `"SelfConsious"`.

We define a class method `SelfConscious::who_is_self` (lines 4-6) and an instance method `SelfConscious#who_is_self` (lines 8-10), both of which output a string representation of the object referenced by `self` by passing it to `puts`.

On line 13, we call `who_is_self` on the class, which outputs the name of the class.

On line 14, we call the instance method `who_is_self` on a new instance of the class, which outputs a string representation of the instance with its object id.

10m16s

Forgot about calling setter methods within the class.

In addition to defining class methods, a very important use case for `self` is when calling setter methods within the class. Normally, an instance method can call other instance methods of the class implicitly on the calling object without needing to use the dot operator on an explicit caller. However, the syntax for calling a setter method (with names ending in `=`) cannot be disambiguated from the initialization of a new local variable. For this reason, it is necessary to call setter methods explicitly on the calling object using `self` to reference it dynamically. For instance,

```ruby
class Cat
  attr_accessor :name

  def initialize(n)
    self.name = n
  end
end

cat = Cat.new("Fluffy")
puts cat.name # "Fluffy"
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

We define a `Person` class on lines 1-9. The constructor initializes a new `@name` instance variable to the object passed as argument (line 3). We define an instance method `Person#get_name` which returns the reference of `@name`.

On line 11, we initialize local variable `bob` to a new `Person` object, passing string `"bob"` to the constructor via the `Person::new` method.

On line 12, we initialize local variable `joe` to a new `Person`, passing `"joe"` through to the constructor.

On line 14, we call `inspect` on `bob` and pass the detailed string representation of the object that this method returns to the `Kernel#puts` method. On line 15, we do the same thing with `joe`.

The output demonstrates that each individual instance of `Person` has its own unique `@name` instance variable which is distinct from the `@name` instance variable of any other object of the class. Each instance's `@name` variable references a different String object.

Objects encapsulate state. The state of each object is distinct from every other object, including objects of the same class. The state of an object is tracked by its instance variables.

All objects of the class share the instance methods defined in the class. An instance variable is only initialized in an object when an instance method (which might be the constructor) is called that initializes the variable. Thus the set of *names* of potential instance variables might be predetermined by the shared behaviors of objects of the class. Nevertheless, each instance has its own unique instance variable of each name, and its own totally distinct and unique set of instance variables.

This is because instance variables are scoped at the object level and are unique to the instance. Once initialized, an object's instance variables can persist for the lifetime of the object.

9m03s



26.

How do class inheritance and mixing in modules affect instance variable scope? Give an example.

Instance variables are scoped at the object level, and neither class inheritance nor mix in modules changes this. Any instance variable initialized in an object is particular to that object and distinct from the instance variables of any other object.

Instance variables are not directly inherited, but instance methods are.

An instance variable can only be initialized in an object when an instance method that initializes the variable is called on the object. This might be the `initialize` constructor, in which case the instance variables the constructor initializes will be present as soon as the object is instantiated. 

Unlike instance variables, which are not shared with any other object, the instance methods defined by a class are shared by all objects of that class. The names of instance variables are thus determined by shared behaviors, but any given instance variable is unique to the calling object in which an instance method initializes it, though other objects of the class may have instance variables with the same name.

Instance methods might be defined in the class definition, or inherited either through class inheritance or mixin modules. In either case, the instance variables that the method definition initializes will only actually be initialized in a given object once the method is called on that object.

As an example,

```ruby
module Nameable
  def name=(n)
    @name = n
  end
end

class Cat
  include Nameable
end

fluffy = Cat.new
p fluffy # <Cat:0x...>
fluffy.name = "Fluffy"
p fluffy # <Cat:0x... @name="Fluffy">
```

We define a `Nameable` module (lines 1-5) which defines an instance method `name=` that sets an instance variable called `@name`. We define a `Cat` class (lines 7-8) that mixes in `Nameable`.

We initialize local variable `fluffy` to a new `Cat` object on line 11. When we pass `fluffy` to `Kernel#p` on line 12, the `inspect` method is implicitly called by `p` and a detailed string representation of the object is output to screen. No instance variables are present in `fluffy`. On the next line, we call `name=`, an instance method inherited from `Nameable`, on `fluffy`, with string `"Fluffy"` passed as argument.

When we again pass `fluffy` to `p` on line 14, the output shows that an instance variable, `@name`, has now been initialized in the `fluffy` object.

What this demonstrates is that the set of potential instance variables an object might have is determined by the instance methods available to it, but that these variables will only exist if the instance methods that initialize them are called on the object. These instance methods may be shared with other classes in the inheritance hierarchy, whether through class inheritance or mixin modules, but when an instance method initializes an instance variable, the variable is scoped at the object level and is particular to the calling object.

16m47s

This is what is meant by instance variable scope:

Instance variables are scoped at the object level.

Instance variables track an individual object's state and are not shared with any other objects. "For instance, we can use a `@name` instance variable to separate the state of `Person` objects". All `Person` objects have a distinct `@name` that is particular to the individual object.

An instance variable is available only in all of an object's instance methods, regardless of which instance method initializes it. Instance variables cannot be accessed outside of an object's instance methods.

Referencing an uninitialized instance variable evaluates to `nil`.

The section on instance variable scope and inheritance gives an example of class inheritance where an instance variable is initialized by the constructor inherited from the superclass and then referenced from an instance method defined in the subclass.

Another example then demonstrates that if the constructor is overridden and the instance variable is not initialized, the instance variable is uninitialized and will evaluate to `nil`.

An example of mixin module inheritance is given, where again the instance variable is not initialized until the method inherited from the module is called.

The section concludes that instance variables "don't really exhibit any surprising behavior. They behave very similarly to how instance methods would, with the exception that we must first call the method that initializes the instance variable. Once we've done that, the instance can access that instance variable. This distinction suggests that, unlike instance methods, instance variables and their values are not inherited"

None of this really explains how "instance variable scope" is affected by inheritance. It simply isn't. The only thing affected by inheritance is what instance methods are available to objects of the class. These methods may or may not initialize instance variables. If an instance variable is initialized, it is scoped at the object level, regardless of whether the instance method is defined in a superclass, the class itself, or a mixin module. Instance variables are not inherited because an instance variable will only come into existence when the method that initializes it is called on the object.



26.

How do class inheritance and mixing in modules affect instance variable scope? Give an example.

Instance variables are scoped at the object level. Instance variables track an individual objects state and are not shared with any other object. For instance, if we have a `@name` instance variable initialized by the constructor of a `Cat` class, each `Cat` object will have its own individual `@name`. An instance variable thus separates the state of all objects of a class.

Instance variables are initialized by instance methods. An instance variable is accessible throughout the instance methods of a class, regardless of which particular instance method initialized a given instance variable. Instance variables are not accessible outside of the instance methods available to an object.

Instance methods are inherited whether via class inheritance or mixin modules. Instance variables are not inherited, in that an instance variable only comes into being when the instance method that initializes it is called on a particular instance of the class. The variable is then initialized in that particular calling object, and is distinct to that object and not shared by any other object.

As an example,

```ruby
module Nameable
  def name=(n)
    @name = n
  end
end

class Cat
  include Nameable
  
  def name
    @name
  end
end

fluffy = Cat.new
p fluffy.name # nil
p fluffy # <Cat:0x...>

fluffy.name = "Fluffy"
p fluffy.name # "Fluffy"
p fluffy # <Cat:0x... @name="Fluffy">
```

Here, we define a `name=` instance method in a `Nameable` module (lines 1-5). This method initializes a `@name` instance variable. We mix this module into the `Cat` class (lines 1-9). `Cat` defines a `name` method that returns the reference of an instance variable, `@name`.

On line 15, we initialize local variable `fluffy` to a new `Cat` object. We pass the return value of calling `Cat#name` on `fluffy` to the `Kernel#p` method. This outputs `nil` because no instance variable `@name` has yet been initialized. Passing `fluffy` itself to `p` confirms this.

On line 19, we call `name=`, inherited from `Nameable`, on `fluffy` with the string `"Fluffy"` passed as argument. When we call `name` on `fluffy` on the next line, the return value is now `"Fluffy"` because the inherited method, once called, initializes the `@name` instance variable. Passing `fluffy` to `p` again confirms this.

Thus inheritance does not affect variable scope, but rather affects which instance methods are available to an object, and thus which potential instance variable might be initialized if the methods that do so are actually called on an object.

17m04s





26.

How do class inheritance and mixing in modules affect instance variable scope? Give an example.



Instance variables are scoped at the object level. The purpose of instance variables is to keep track of an individual object's state, and an object's instance variables are not shared with any other object.

Instance variables are instantiated by instance methods. An object's instance variables are accessible by any instance method the object has access to, regardless of which instance method initialized a given instance variable.

Since instance variables only come into existence when an instance method that initializes an instance variable is called on the object, instance variables are not directly inherited. However, instance methods that initialize instance variables are inherited, both from class inheritance and any modules mixed in to the class.

For instance,

```ruby
module Nameable
  def name=(n)
    @name = n
  end
end

class Cat
  include Nameable
  
  def name
    @name
  end
end

fluffy = Cat.new
p fluffy.name # nil
p fluffy # <Cat:0x...>

fluffy.name = "Fluffy"
p fluffy.name # "Fluffy"
p fluffy # <Cat:0x... @name="Fluffy">
```

Here, we define a `Nameable` module (lines 1-5) that defines instance method `name=` to set a `@name` instance variable. We define a `Cat` class (lines 7-13) that mixes in module `Nameable` and defines an instance method `name` that returns the reference of instance variable `@name`.

We initialize a local variable `fluffy` to a new `Cat` object on line 15. Next, we call the `Cat#name` method on `fluffy` and pass the return value to `Kernel#p`. The output is `nil`, because `@name` is uninitialized and an uninitialized instance variable reference evaluates to `nil`.

On line 19, we call the `name=` method, inherited from `Nameable`, on `fluffy` with the string `"Fluffy"` passed as argument. When we again call `name` on `fluffy` and pass the return value to `p`, the output is `"Fluffy"` because the `name=` method has now initialized an instance variable `@name` in `fluffy`. We can access the instance variable created by an inherited method from an instance method defined in the class itself. When we pass `fluffy` to `p` on line 21, the output confirms that this instance variable has been initialized in our `Cat` object.

Class inheritance and mixin modules do not affect the scope of instance variables, which remain scoped at the object level. However, inheritance does affect which methods are available to be called on an object, and some of those methods may initialize instance variables in the object. Those variables will be distinct to the object, and will be accessible from any instance method available to the object, regardless of where in the method lookup path the method is defined.

11m22s



27

How does encapsulation relate to the public interface of a class?



Encapsulation means hiding pieces of functionality behind a public interface. One of the main purposes of encapsulation is to separate the implementation details of a class, which may change, from the public interface, which should not.

The public interface of a class represents how users of the class will interact with it, and consists of `public` methods. We can use method access control to restrict which methods are publicly available, and which methods  are `private` or `protected` implementation details that should not be exposed to users of the class.

The interface should be as simple as possible, in order to simplify use of the class and to avoid exposing unnecessary details. This restricts the elements of the class that client code can become dependent on, meaning that we can make more changes to the class without breaking existing code. This greatly enhances maintainability of code.

7m52s

Encapsulation means hiding functionality from the rest of the code base behind a publicly exposed interface. The notion of a public interface is a vital part of encapulation.

In Ruby, encapsulation is achieved by defining classes and instantiating objects.

The public interface of a class defines how users of the class can interact with its objects. The public interface of a class is comprised of its `public` methods. We can use method access control to restrict access to `private` and `protected` methods, leaving `public` only those methods that are necessary to expose as part of the public interface.

Encapsulation is also a form of data protection. Hiding the representation of an object behind its public interface protects data from accidental or invalid modification. In Ruby, an object's instance variables can only be accessed through deliberately exposed public methods (getter and setter methods) that form part of the public interface. These may, for instance, perform validation checks before setting an instance variable to a new value. This prevents users of  the class from depending directly on the representation of objects of the class, the specific instance variables used to track state.

The separation of the implementation of a class from the public interface reduces code dependencies. Users of the class can only become dependent on a public interface that should not change, leaving us free to make changes to the implementation without breaking existing code.



Encapsulation means hiding functionality behind a public interface. Thus the notion of separating implementation details from a public interface is key to encapsulation.

In Ruby, encapsulation is achieved by defining classes and instantiating objects. The public interface of a class defines how users of the class can interact with its objects, and is comprised of the `public` methods exposed by the class. We can use method access control to specify which methods are `public` and part  of the interface, and which methods are `private` or `protected`, and remain part of the implementation.

The public interface should be as simple as possible, meaning we should expose as few public methods as possible in order to provide the necessary functionality. This simplifies use of the class, but also reduces code dependencies. Client code can only become dependent on the interface to a class, leaving us free to make changes to the implementation and representation.

Encapsulation is also a form of data protection. Hiding the representation of an object behind a public interface reduces the chance of accidental or invalid modification of the state of objects of the class. In Ruby, instance variables can only be accessed via deliberately exposed public methods (such as getter and setter methods). This protection of the representation of our objects behind a simplified public interface gives us greater control over how users can or cannot modify the state of our objects. We can perform validation checks before allowing data to become part of an object's state, and we can even change how data is represented so long as the interface remains consistent without worrying about breaking existing code.

By reducing code dependencies, the encapsulation of functionality and state behind a public interface greatly enhances code maintainability and reduces the likelihood of accidental data modification.

11m39s



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

We define a `GoodDog` class on lines 1-10. The `GoodDog#initialize` constructor is defined on lines 6-9 with two parameters `n` and `a` that it uses to initialize instance variables `@name` and `@age` respectively.

On line 12, we initialize local variable `sparky` to a new `GoodDog` object, passing the string `"Sparky"` and the integer `4` through to the constructor.

On line 13, we pass `sparky` to the `Kernel#puts` method. `puts` calls the `to_s` method on its arguments. Since we have not overridden the default `to_s` in our custom `GoodDog` class, `Object#to_s` will be called, since a custom class will subclass `Object` by default. The string that is output will be of the form `<ClassName:0x...>` where `ClassName` is the name of the class, and `0x...` represents an encoding of the object id of our `GoodDog` instance.

If we wanted to output a message of our own, we can simply override `Object#to_s` with a custom `GoodDog#to_s` method:
```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
  
  def to_s
    "#{name} is a GoodDog"
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky # Sparky is a GoodDog
```

The reason that the second piece of code produces a slightly different output from the first, is that on line 32, we pass `GoodDog` object `sparky` to the `Kernel#p` method instead of `puts`. The `p` method implicitly calls `inspect` rather than `to_s`. Again, the default `Object#inspect` method is called since we have not overridden it. This returns a string similar to that produced by `Object#to_s` but with the addition of a list of the object's instance variables and their current values.

10m49s



29.

When does accidental method overriding occur, and why? Give an example.



Method overriding occurs when we define a method in a subclass with the same name as a method defined in a superclass. When a method of that name is called on an object of the subclass, Ruby searches the method lookup path, finds a definition for a method of that name in the subclass and calls it, at which point the search ends and the superclass method is never considered.

Accidental method overriding occurs whenever we unintentionally override a method inherited from a superclass by defining a method with the same name in the subclass. This is perhaps most likely to occur with methods inherited from the `Object` class, since a custom class will inherit from `Object` by default, and `Object` is the ancestor of almost all Ruby classes. Whereas we might remember which methods we have defined in our own custom class hierarchies, it is much easier to forget which methods we inherit by default from the `Object` class.

The methods contained in `Object` are important parts of Ruby's core functionality. While a small number of these methods are conventionally overridden to give more specialized behaviors to custom classes, such as `Object#to_s`, most should not be overridden. This is because they implement functionality that we expect most Ruby objects to have access to.

As an example, we define a `Message` class as follows:

```ruby
class Message
  def initialize(text)
    @text = text
  end
  
  def send
    # code omitted ...
    puts "Sending message..." 
  end
  
  def show_text
    puts @text
  end
end

message = Message.new("Hello world")
message.send # "Sending message..."

message.send(:show_text) # raises ArgumentError
```

Here, we have defined a `Message#send` method for our class (lines 6-9), which we might perhaps use to send the `@text` of the `Message` object over a network connection. This seems a reasonable name for such a method, but unfortunately this means we have accidentally overridden `Object#send`, which implements a key element of Ruby functionality: the ability to explicitly send a message to an object, meaning the name of a method we wish to invoke on that object (and any arguments it might take).

When we instantiate a `Message` object (line 16) and then call `Message#send` with no arguments on the object (line 17), we successfully call the method we have defined in our class. However, when we attempt to call the `Message#show_text` method on our message object on line 19, expecting to be able to use the core message-passing functionality implemented by `Object#send`, we raise an `ArgumentError`. This is because we have accidentally overridden `Object#send` with our `Message#send` definition, which unlike `Object#send` takes no arguments.

Errors like these can be difficult to debug, so it is important to familiarize oneself with the methods inherited by almost all custom classes from `Object` in order not to override core Ruby functionality that users of our class might reasonably expect all Ruby objects to have access to.

12m40s



30.

How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers.



Most OOP languages feature some form of access control. In Ruby instance variables are completely hidden from users of the class (except indirectly via instance methods), so it is common to speak specifically of method access control, since methods comprise the interface to a class.

Method access control is achieved in Ruby through the use of three methods inherited from the `Module` class: `public`, `private`, and `protected`. These are called access modifier methods. When we call, for example, `private` within a class definition, all instance methods defined after the call are treated as `private` methods (until another access modifier method is called).

Ruby methods are `public` by default. This means that instance methods defined without a specified access modifier (or after an explicit call to `public`) can be called on an object of the class from anywhere in the code base. `public` methods comprise the public interface of the class.

`private` methods can only be called from within the class. If an instance method is defined after the `private` access modifier, it can only be called from other instance methods on the calling object. Methods are defined as `private` when we do not need them or wish them to be part of the public interface of the class.

`protected` is similar to `private`, with the exception that a `protected` method can be called from within the class on another object of the same class (usually one that has been passed to an instance method as argument). When we do not wish a method to be part of the public interface, but still need to be able to call the method from within the class on other objects of the class (such as in a comparison method) , we define the method as `protected`.

As an example,

```ruby
class Person
  def initialize(name, age)
    self.name = name
    self.age = age
  end
  
  def >(other_person)
    age > other_person.age
  end

  protected
  
  attr_reader :age
  
  private
  
  attr_writer :name, :age
end

bob = Person.new("Bob", 49)
jim = Person.new("Jim", 28)

puts bob > jim # true
puts bob.age # raises NoMethodError: protected method called from outside class
bob.age = 25 # raises NoMethodError: private method called from outside class
```

It is worth noting that here, we use the `private` setter methods generated with a call to `attr_writer` on line 17 to set the instance variables in the constructor (lines 3-4). While it has always been possible to call `private` setter methods in Ruby explicitly on `self` using the dot operator, it used to be impossible to call any other `private` method explicitly on `self`. Since Ruby 2.7, it is now possible to call any `private` method explicitly on `self`, but still not on any other object than the calling object.

13m59s



31.

\# Describe the distinction between modules and classes.

The principal difference between modules and classes is that a class can be instantiated and a module cannot.

This means that classes are used to group behaviors that objects instantiated from the class will have access to. Modules are used to group methods and constants. Modules may be mixed into a class to provide behavior and constants to objects of that class via the `Module#include` method. Such a module is called a 'mixin'. However, we still cannot instantiate objects from the module, only from the class the module has been mixed in to.

Modules are also used to namespace classes, and as containers for methods that do not pertain to any specific class, often called 'module methods'.

Since the purpose of objects is to encapsulate state, module methods are often stateless methods that do not need to be called on an object with a state.

It is also worth noting that, unlike classes, a module cannot inherit through class inheritance (though it can mix in other modules through `include`).

5m54s



32.

\# What is polymorphism and how can we implement polymorphism in Ruby? Provide examples.

Polymorphism is the ability of multiple data types to respond to a common interface, often but not always in different ways. 'Poly' means 'many' and 'morph' means 'forms'.

Polymorphism is the ability for objects of different classes to respond to a common interface. In Ruby, polymorphism is achieved in three main ways: through class inheritance, through mixin modules (sometimes called 'interface inheritance'), and through duck typing.

To give polymorphic structure to our programs through class inheritance, we can create a class hierarchy in which a superclass provides a common method (or methods) to various subclasses. The subclasses may override the superclass method(s) with their own specialized implementations. However, this is still understood to be polymorphism through inheritance.

As an example,

```ruby
class Animal
  def move
    puts "I'm moving"
  end
end

class Cat < Animal
  def move
    puts "I'm walking"
  end
end

class Jellyfish < Animal
  def move
    puts "I'm swimming"
  end
end

animals = [Animal.new, Cat.new, Jellyfish.new]
animals.each { |animal| animal.move }
```

Output:

```
I'm moving
I'm walking
I'm swimming
```

Here, we define a superclass `Animal` (lines 1-5). We define a `Cat` class (lines 7-11) and a `Jellyfish` class (lines 13-17) as subclasses of `Animal`. Both subclasses inherit a `move` method from `Animal`, though we have chosen to override the method with specialized implementations in the subclasses. Even if `Cat` and `Jellyfish` did not define their own overriding method, however, inheritance ensures that objects of these classes share a public `move` method, meaning they can respond to a common interface - the invocation of a `move` method.

We can see polymorphism in action on line 20. We call `each` on an array of `animals`, containing one instance each of our three classes. `Array#each` iterates through the array passing each element in turn to the block to be assigned to block parameter `animal`. Here we can see polymorphism in action. The block does not care what type of object it is being passed; the block can simply call `move` on the object, and through class inheritance all three types can respond appropriately to the method invocation.

Similarly, we can achieve polymorphism through mixin modules.

```ruby
module Moveable
  def move
    puts "I'm moving"
  end
end

class Car
  include Moveable
end

class Pedestrian
  include Moveable
end

movers = [Car.new, Pedestrian.new]
movers.each { |mover| mover.move }
```

Output:

```
I'm moving
I'm moving
```

We can also achieve polymorphism through duck typing. Duck typing is the ability of completely unrelated types to respond to a common interface. So long as the different types of objects share a common part of their interfaces needed by a particular piece of code, they can be treated as belonging to the right category of object for the task at hand.

Duck typing is an application of the 'duck test': if an object quacks like a duck then it can be treated like a duck. This is to say, in Ruby, we can simply define a method with the same name and number of required parameters in multiple unrelated classes and they can be used polymorphically, even though they do not share a mixin module or a class inheritance chain.

As an example,

```ruby
class Duck
  def fly
    puts "I'm flying"
  end
end

class Beetle
  def fly
    puts "I'm flying"
  end
end

winged_things = [Duck.new, Beetle.new]
winged_things.each { |winged_thing| winged_thing.fly }
```

17m37s



```ruby
class Vehicle
  def start
    puts "Starting engine..."
  end
end

class Car < Vehicle
end

class Boat < Vehicle
  def start
    puts "Starting outboard motor..."
  end
end

vehicles = [Vehicle.new, Car.new, Boat.new]
vehicles.each { |vehicle| vehicle.start }
# output:
# Starting engine...
# Starting engine...
# Starting outboard motor...
```



```ruby
module Climbable
  def climb
    puts "I'm climbing"
  end
end

class Person
  include Climbable
end

class Cat
  include Climbable
end

climbers = [Cat.new, Person.new]
climbers.each { |climber| climber.climb }
# output:
# I'm climbing...
# I'm climbing...
```

```ruby
class Alien
  def draw
    # code to draw Alien on screen
  end
end

class Spaceship
  def draw
    # code to draw Spaceship on screen
  end
end

screen_elements = [Alien.new, Spaceship.new]
screen_elements.each { |element| element.draw }    
```



(a) Without getting into specific implementation details: what is polymorphism, what role does it play in OOP, and why is it desirable?
(b) What are three ways that polymorphism is implemented in ruby? (i.e. *name them*)
(c) For each implementation listed above, (i) explain how this variety of polymorphism works in ruby, (ii) explain *why* this variety counts as a kind of polymorphism (i.e. why is what you've just described clearly an instance of *polymorphism,* given the definition you offered in part (a)?) (iii) explain what the primary use cases are for this variety of polymorphism, and (iv) give an example or two in ruby code (edited) 



What is polymorphism?

In Ruby, we can implement polymorphism in three distinct ways: through class inheritance, through the use of mixin modules (sometimes called 'interface inheritance'), and through duck typing.

Explain class inheritance with example. How does it work, and why is what is does polymorphism? What are the main use cases for polymorphism through class inheritance?



33.

\# What is encapsulation, and why is it important in Ruby? Give an example.

Encapsulation means to enclose as if in a capsule. Encapsulation is hiding pieces of functionality from the rest of the code base behind a public interface. Encapsulation is also a form of data protection, helping to prevent accidental or invalid modification of data.

In Ruby, encapsulation is achieved by defining classes and instantiating objects. Objects encapsulate state; the instance variables of an object track that object's distinct state and are inaccessible to the rest of the code base except through the public interface of the class. The public interface of a class is composed of its public methods. We can use method access control to restrict which methods form part of the public interface, and which are part of the implementation (`private` or `protected` methods).

Encapsulation is important in Ruby because it reduces code dependencies and makes code easier to maintain. Client code can only become dependent on the public interface of a class, which should not change. This leaves us free to change the implementation of a class, so long as the interface remains constant, without breaking existing code. The public interface also simplifies use of the class, since users only need to know the public interface rather than how a class is implemented.

Encapsulation is also important in protecting data from accidental or invalid modification, since an object's instance variables can only be accessed through the class's interface. For instance:

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def name
    @name
  end
end

fluffy = Cat.new("Fluffy")
p fluffy.name # "Fluffy"
fluffy.name = "Tom" # raises NoMethodError
```

In this example, we define a `Cat` class on lines 1-9. The `Cat#initialize` constructor takes one parameter `name` and uses it to set a `@name` instance variable. We define a getter method for the instance variable `@name` (lines 6-8).

On line 11, we initialize a local variable `fluffy` to a new `Cat` object whose `@name` variable will be set to the string `"Fluffy"`. On line 12, we call `Cat#name` and pass the return value to `Kernel#p` to be output to screen: `"Fluffy"`.

However, when we attempt to reassign the `@name` instance variable on line 13, we cannot, since we have not exposed a public setter method for this instance variable. So a `NoMethodError` is raised. The encapsulation of state in an object has prevented us from modifying the state of the object in a way the class designer does not wish to happen.

15m29s



33.

\# What is encapsulation, and why is it important in Ruby? Give an example.

Encapsulation means to enclose as if in a capsule. Encapsulation is hiding pieces of functionality from the rest of the code base behind a publicly exposed interface. Encapsulation is also a form of data protection, helping prevent data from accidental or invalid modification.

Encapsulation is Ruby is achieved by defining classes and instantiating objects. Objects encapsulate state. In Ruby, an object's instance variables track the distinct state of that object and cannot be accessed unless through the public interface.

In Ruby, the public interface of a class is comprised of its public methods. We can achieve a fine-grained determination of which methods form part of the public interface and which are part of the implementation through method access control, the use of the access modifier methods `public`, `private`, and `protected` (defined in `Module`).

Encapsulation is important in Ruby and other OO languages because it reduces code dependencies, making code easier to maintain. Users of a class need only know the public interface, and do not need to understand the implementation of the class. As well as simplifying the use of the class, this reduces code dependencies, since client code can only become dependent on the public interface, which should not change. This leaves us free to change the implementation without breaking existing code.

Encapsulation is also important in protecting data from accidental or invalid modification. Since an object's state can only be changed, if at all, through the `public` methods of the interface, this means the class designer can have control over what modifications can be made to the object's state.

For instance,

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def name
    @name.dup
  end
end

fluffy = Cat.new("Fluffy")
puts fluffy.name # "Fluffy"
fluffy.name = "Tom" # rasises NoMethodError
```

Here, we define a `Cat` class on lines 1-9. The `Cat#initialize` constructor has one parameter which is used to set the instance variable `@name`. We define an instance method `name` to return a copy of the string referenced by `@name` (lines 6-8).

We instantiate a new `Cat` object whose `@name` will be set to `"Fluffy"`, on line 11. We can retrieve a copy of this String object by calling `Cat#name` on `fluffy`, as on line 12. Since this is a copy, even if we mutated the state of the String object, this would have no effect on the object referenced by `fluffy`'s `@name` variable. Attempting to reassign `@name` on line 13 raises an exception, since we have not exposed a method as part of the interface to allow this variable to be reassigned. Encapsulation of state here ensures that once set, the `@name` of a `Cat` object cannot be changed.

12m49s



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
"Mike strolls forward"
"Kitty saunters forward"
```

Line 40, calls a `walk` method on a `Person` object whose `@name` attribute is set to `"Mike"`, before passing the return value to `Kernel#p` to be output to screen. The `Person` class (lines 7-21) does not define a `walk` method but mixes in the `Walkable` module (lines 1-5) where a `walk` method is defined.

The `walk` method is defined to interpolate the return values of `name` and `gait` methods into a string: `"#{name} #{gait} forward"`. `Person` defines a `name` getter method for instance variable `@name`, which is set to `"Mike"` for our object. The `Person#gait` method returns the string literal `"strolls"`.

On line 43, we again call `walk`, this time on a `Cat` object. `Cat` (lines 23-37) also mixes in `Walkable`, and defines `name` and `gait` methods that return appropriate values to be interpolated into the string in the `walk` method.

It makes more sense to use the module `Walkable` as a mixin rather than defining a parent class to extract the `walk` method to. This is because the problem level entities we are modeling, a `Person` and a `Cat`, have no logical superclass. Since our two classes are logically unrelated, it does not make sense to model them as being specialized types of a common superclass.

Rather, both classes represent entities that 'have the' ability to `walk`. This 'has-a' relationship is better expressed through mixing in a module to provide the common behavior. 

11m48s



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

This code will output

```
"Mike strolls forward"
"Kitty saunters forward"
```

This is because we have called the method `walk` on objects of the `Cat` and `Person` classes and passed the return values to `Kernel#p` on line 40 and line 43. Since both classes mix in the `Walkable` module that provides a `walk` instance method, and provide the `gait` and `name` methods called by `walk`, we receive appropriate output from `p`.

The reason it makes sense to use a module here instead of extracting `walk` to a common superclass is to do with the entities we are modeling at the problem domain level. The nouns `Cat` and `Person` do not fit neatly into a taxonomic hierarchy. Rather, these are unrelated entities that simply share a common behavior. Both classes of object need to 'have an' ability to `walk`. Since this kind of 'has a' relationship can be expressed by mixing in a module, the module is the better choice over class inheritance.

4m38s



35.

\# What is Object Oriented Programming, and why was it created? What are the benefits of OOP, and examples of problems it solves?

OOP is a programming paradigm created to deal with the problems of large, complex software projects. OOP aims to reduce code dependencies and improve the maintainability, reusability, and scalability of code.

As pre-OOP programs grew in scale and complexity, they tended to become a mass of dependencies, with every part of the program depending on every other part. Code could not be changed or new features added without a ripple of adverse effects throughout the code base.

OOP aims to modularize programs, providing containers for data that can be changed without affecting the rest of the code base, a way to section off functionality and data behind publicly exposed interfaces, so that a program becomes the interaction of many small parts rather than a mass of dependency.

By abstracting away implementation details behind interfaces, OOP also aims to allow us to think it terms of the problem domain. OOP objects can represent real world objects, or entities from the problem domain. This provides a high-level way to break down and analyze complex problems, and a way to solve them one piece at a time.

By allowing us to modularize programs in this fashion, OOP also permits us to reuse code in a greater variety of contexts.

OOP languages provide ways to implement encapsulation, polymorphism and inheritance, in order to achieve these ends.

10m54s



36.

\# What is the relationship between classes and objects in Ruby?

In Ruby, the relationship of a class to its objects is that of a template or blueprint.

Classes group behaviors, and objects encapsulate state. A class defines what behaviors will be shared by its objects, meaning which instance methods can be called on these objects.

An object's state is tracked by its instance variables. Each object has its own distinct set of instance variables that are not shared with any other object. 

Instance variables are only initialized in an object by an instance method. Instance methods themselves are shared by all objects of a class. But the scope of an instance variable initialized by an instance method is the calling object, and any instance variable initialized in an object is not shared by any other object. This means that a class might predetermine the set of potential names for instance variables that objects of the class might have, but each object will have its own set of actual instance variables.

Creating a new object from a class is called 'instantiation', and is usually achieved by calling class method `new` on the class. Any arguments to the `new` method will be passed through to the `initialize` instance method, the constructor method, which sets the initial state of that particular object.

For instance,

```ruby
class Cat
  def initialize(name)
    @name = name
  end
end

fluffy = Cat.new("Fluffy")
tom = Cat.new("Tom")

p fluffy # <Cat:0x... @name="Fluffy">
p tom # <Cat:0x... @name="Tom">
```

Here, we define a `Cat` class (lines 1-5). The `Cat#initialize` constructor is defined with one parameter which it uses to set the `@name` instance variable in the calling object.

On line 7, we initialize local variable `fluffy` to a `Cat` object with string `"Fluffy"` passed to the constructor.

On line 8, we repeat this for variable `tom` with string `"Tom"` passed through to `Cat#initialize`.

We have instantiated two distinct `Cat` objects from the class definition, each of which has its own `@name` instance variable that is set to a different value. We confirm this by passing `fluffy` and `tom` to the `Kernel#p` method on lines 10-11, which implicitly calls `Object#inspect` on these `Cat` objects to output detailed string representations with the instance variables and their values.

This demonstrates that each object is the instantiation of a common class, with common behaviors, but that each encapsulates its own individual state.

11m22s



37.

\# When should we use class inheritance vs. interface inheritance?

Class inheritance is used most effectively to model entities in the problem domain that are related in a naturally hierarchical way. A subclass is a specialized type with respect to the superclass, which means that the relationship between a subclass and its superclass is an 'is a' relationship. The subclass is more specific type of the superclass type.

Inheritance through mixin modules, sometimes called interface inheritance, models a 'has-a' relationship. The class that mixes in the module 'has an' ability provided by the module. Thus, interface inheritance is useful for any situation where two or more entities in the problem domain 'have a' specific behavior or ability, but are not otherwise related.

It can also be useful to use interface inheritance to replicate the advantages of multiple inheritance. Ruby is a single inheritance language, meaning that each subclass can have only one immediate superclass. Mixin modules allow us to provide common behaviors to classes in an existing class hierarchy where there is no common superclass to extract the common behavior to without giving it to subclasses that should not have it.

For instance,

```ruby
module Swimmable
  def swim
    puts "I'm swimming"
  end
end

class Animal
end

class Dog < Animal
  include Swimmable
end

class Cat < Animal
end

class Fish < Animal
  include Swimmable
end

dog = Dog.new
cat = Cat.new
fish = Fish.new

dog.swim # "I'm swimming"
fish.swim # "I'm swimming"
cat.swim # raises NoMethodError
```

Here, our `Swimmable` module allows us to provide the method `swim` to classes `Dog` and `Fish`. We cannot extract the method to their common superclass, `Animal`, without providing it to the `Cat` class, which should not have it.

8m35s



38.

```ruby
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new


# If we use `==` to compare the individual `Cat` objects in the code above, will the return value be `true`? Why or why not? What does this demonstrate about classes and objects in Ruby, as well as the `==` method?
```

If we use `==` to compare the different `Cat` objects in the given code, the return value will be `false`. This is because we have not overridden the default implementation of `==` that all classes inherit from `BasicObject`.

The `==` method looks like an operator and has special syntactic sugar to make it appear like an operator, but is a method like any other. Most core classes override the default `BasicObject#==` in order to check for object value equivalence. This means the conventional usage of `==` is to compare two objects of the same class, returning `true` if the most significant value tracked by the objects is considered equivalent. So for instance, `String#==` will compare the string value of the caller to the string value of the argument, returning `true` only if every character in the two string values is the same, `false` otherwise.

The `BasicObject#==` method compares two objects based on the value of their object id. An object's object id is unique to that object, so `BasicObject#==` will only return `true` if both the caller and argument are the same object. Testing whether two references reference the same object is the purpose of the `BasicObject#equal?` method, whereas `==` should generally be overridden by custom classes whose objects need to be tested for value equivalence.

Since the `Cat` objects in the code above are three different objects, they all have their own unique object id. This is why `==` would return `false`.

This demonstrates that a class is a blueprint for the objects of the class, but each object instantiated from the class is a unique object with its own distinct  state and its own unique object id.

9m22s



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



The `Thing` class is defined on lines 1-2. On lines 4-5, we define an `AnotherThing` class as a subclass of `Thing`. On lines 7-8, we define the `SomethingElse` class as a subclass of `AnotherThing`.

`Thing` is the immediate superclass of `AnotherThing`. `AnotherThing` is the immediate superclass of `SomethingElse`. In a looser sense, we could also say that the ancestor `Thing` is a superclass of `AnotherThing`.

Since `Thing` has no explicit superclass, it subclasses `Object` by default, since all Ruby custom classes with no explicit superclass will subclass `Object`. `Object` in turn subclasses `BasicObject`, which is the ancestor (or ultimate superclass) of all Ruby classes.

3m27s

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



We instantiate a `Penguin` object on line 24 and then call the `fly` method on it on the next line.

Ruby begins searching the method lookup path with the class of the calling object, which is `Penguin`. Since there is no `fly` method defined here, Ruby moves on to search the mixed in modules in the reverse order of the calls to `Module#include` that mixed them in. So Ruby first searches `Migratory` and then `Aquatic`. Since there is no `fly` method defined in these, Ruby then moves on to search the superclass `Bird`. The method is not found here, so Ruby moves to the next superclass, `Animal`.

There is no `fly` method defined in `Animal`, so Ruby searches the superclass of `Animal`, `Object`. Since there is no `fly` here, Ruby searches the mixin module `Kernel`, and then the superclass `BasicObject`. This is the end of the method lookup path for `Penguin` objects, so Ruby raises a `NoMethodError` exception.

We could verify this by calling `Module#ancestors` on the class of our `Penguin` object, to return an array containing the method lookup path in order:

```ruby
pingu.class.ancestors # [Penguin, Migratory, Aquatic, Bird, Animal, Object, Kernel, BasicObject]
```

6m16s



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



This code outputs `Daisy says moooooooooooo!`.

We define an `Animal` class on lines 1-8. The `Animal#initialize` constructor has one parameter which it uses to set the `@name` instance variable.

We define an `Animal#speak` instance method that passes the return value of calling the `sound` method to `Kernel#puts` to be output to screen.

We define an `Animal#sound` method that interpolates instance variable `@name` into the string `"#{@name} says "` and returns the resulting string.

Next we define a `Cow` class (lines 15-19) as a subclass of animal. `Cow` overrides the `Animal#sound` method it inherits with an implementation of its own. The method definition body uses the `super` keyword to call `Animal#sound` and then concatenates the string `"moooooooooooo!"` to the return value before returning the resulting string.

We instantiate a new `Cow` object, passing string `"Daisy"` through to the constructor to be used to initialize the `@name` instance variable, and initialize local variable `daisy` to this new `Cow` object. Next we call `speak` on `daisy`. This invokes the inherited `Animal#speak`, which invokes a `sound` method. Since the method lookup path begins with the class of the calling object, a `Cow` object, it is `Cow#sound` that is invoked by `Animal#speak`. `Cow#sound` then calls `Animal#sound` to return the first part of the string, involving the interpolation of the `daisy` object's `@name` variable, and then concatenates the extra string to the end before returning the new String object. This is returned to the `Animal#speak` method to be passed to `puts` and output to screen.

That is why this code outputs `Daisy says moooooooooooo!`.

8m45s



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

We define a `Cat` class on lines 1-14. The `Cat#initialize` constructor has two parameters `name` and `coloring`, which it uses to initialize two instance variables `@name` and `@coloring` respectively. We also define instance methods `purr`, `jump`, `sleep`, and `eat`.

Next, on line 16, we initialize local variable `max` to a new `Cat` object, passing the strings `"Max"` and `"tabby"` through to the constructor.

On line 17, we initialize local variable `molly` to a new `Cat` object, passing `"Molly"` and `"gray"` to the constructor.

Classes group behaviors and objects encapsulate state. This means that the behaviors defined by a class are shared by all of its objects, but each object has its own distinct state, tracked by its instance variables. An object's instance variables are unique to that object, and are not shared with any other object of the class.

Thus `max` and `molly` have their own separate states, meaning for instance that `max` has its own `@name` variable and `molly` has its own `@name` variable, referencing different String objects from each other's. However, `max` and `molly`, like all objects of the `Cat` class, share the behaviors defined by the class, meaning they share the instance methods defined in the `Cat` class: `initialize`, `purr`, `jump`, `sleep`, and `eat`.

This demonstrates how all objects in Ruby encapsulate their own distinct state.

6m42s



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

The above code returns `nil` instead of `"A"`. The reason has to do with the syntax for calling setter methods.

The `Student` class is defined on lines 1-12. The `Student#initialize` constructor is defined with one parameter `name` which it uses the initialize instance variable `@name`. It initializes instance variable `@grade` to `nil`. On line 2, we generate getter and setter methods for `@name` and `@grade` with a call to `Module#attr_accessor`.

The `Student#change_grade` instance method is defined with one parameter `new_grade`, on lines 9-11. Within the body of the method, we have clearly attempted to call the setter method `grade=` with `new_grade` passed as argument. However, to call a setter method inside the class we must explicitly call it on `self`, which references the calling object, using the dot operator. 

Calling a regular instance method within the class without an explicit object will implicitly call the method on the calling object. However, the syntax for calling a setter method like this cannot be disambiguated from initializing a new local variable. So line 10 initializes the local variable `grade` to `new_grade` and does not reassign `@grade`, which remains set to `nil`.

On line 14, we initialize local variable `priya` to a new `Student` object with `"Priya"` passed through to the constructor to be assigned to `@name`. On the next line we call `change_grade` on `priya` with `"A"` passed in. This does nothing, for the reasons stated above.

This is why calling the getter method `Student#grade` on `priya` on line 16 returns `nil`.

In order to fix this, we must change line 10 to call `grade=` explicitly on the calling object referenced by `self` using the dot operator:

```ruby
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end
  
  def change_grade(new_grade)
    self.grade = new_grade
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade # "A"
```

This code now returns `"A"`.

8m31s



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

We define a `MeMyselfAndI` class over lines 1-11. On line 2, within the class but outside any method definition, the `self` keyword references the class itself, `MeMyselfAndI`. This reference will be evaluated when the class definition is evaluated, though nothing is done with it.

The `MeMyselfAndI::me` class method is defined on lines 4-6. Within the definition, on line 5, `self` again references the class, since we are inside a class method. This will be evaluated only when `me` is called on the class.

The `MeMyselfAndI#myself` instance method is defined on lines 8-10. On line 9, within the instance method definition, `self` references the calling object, whichever instance of the class the instance method is currently called on. This reference will only be evaluated once the `myself` method is called on an instance of the class.

4m21s



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

We define a `Student` class on lines 1-7. We generate getter and setter methods for a `@grade` instance variable with the call to `Module#attr_accessor` on line 2. The `Student#initialize` constructor has two parameters. The first, `name`, is used to initialize instance variable `@name`. The second parameter `grade` has a default value of `nil`. However, the method definition body does nothing with the second parameter.

On line 9, we initialize local variable `ade` to a new `Person` object, passing the string `"Adewale"` through to the constructor to be assigned to `@name`. On the next line, we pass `ade` to `Kernel#p`.

`p` implicitly calls `inspect` on its arguments, in this case `Object#inspect`, since our `Person` class does not override it. This returns a string representation of our `Person` object, showing its class, its object id, and a list of its instance variables and their values.

Since our `Person` class constructor has only initialized the `@name` instance variable, this is the only instance variable in the `inspect` string. This is despite the fact that we have generated getter and setter methods for a `@grade` variable.

The reason for this is that an instance variable is only initialized in an object when some instance method is called on the object that initializes it. This could be the `initialize` constructor instance method, called by class method `new` when a new object is instantiated to set its initial state, a setter method, or any other kind of instance method. If we were to call `grade=` with an object passed as argument, then the `@grade` variable would be initialized.

This code demonstrates that instance variables are only initialized in an object when an instance method that initializes them is actually called on the object.

In order to get the expected output, we could simply change the constructor to set `@grade` to the second parameter:

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
    @grade = nil
  end 
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

10m05s



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

We define a `Character` class on lines 1-11. The `Character#initialize` constructor is defined with one parameter `name` which it uses to initialize instance variable `@name`. We generate getter and setter methods for `@name` on line 2 with a call to `Module#attr_accessor`.

We define the `Character#speak` method on lines 8-10. The body of the definition simply interpolates `@name` into a string and returns it.

We define class `Knight` as a subclass of character. We override the simple `name` getter method by defining a `Knight#name` instance method. The definition body concatenates the string `"Sir "` to the return value of calling the superclass method, `Character#name`, which simply returns the reference of `@name`, and we return the new string returned by this concatenation.

We initialize a local variable `sir_gallant` on line 19 to a new `Knight` object, passing the string `"Gallant"` through to the constructor to be assigned to instance variable `@name`.

When we call `name` on `sir_gallant` on line 20 and pass the return value to `Kernel#p` to be output, the output will be `"Sir Gallant"`. This is because the `Knight#name` method is earlier in the method lookup path for a `Knight` object than the superclass method, so `Knight#name` is called.

However, when we call `Character#speak` on `sir_gallant` on line 21 and pass the return value to `p`, the output will simply be `"Gallant is speaking"`.

This is because we have defined `Character#speak` to interpolate a direct reference to the `@name` instance variable, rather than calling the `name` getter method (which has been overridden for `Knight` objects).

To fix this we can simply change the reference to the variable to a call to the getter method:

```ruby
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{name} is speaking."
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
```

This now outputs `"Sir Gallant is speaking"` on the final line.

8m19s



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



We define a `FarmAnimal` class on lines 1-5. We define a single instance method `FarmAnimal#speak`. This method interpolates the calling object, referenced by keyword `self`, into a string: `"#{self} says" `.

We define a `Sheep` class as a subclass of `FarmAnimal` on lines 7-11. We override the superclass `speak` with `Sheep#speak`. The method definition body calls the superclass method `FarmAnimal#speak` using the `super` keyword and concatenates the return value to the string `"baa!"`, returning this new concatenated string.

We define a `Lamb` class on lines 13-17. We override the superclass `speak` with a `Lamb#speak` method. This method calls the superclass method `Sheep#speak` (which will in turn call its superclass method `FarmAnimal#speak`) with the `super` keyword and concatenates the return value to the string `"baaaaaaa!"`, returning the new string.

We define a `Cow` class as a subclass of `FarmAnimal`. This class overrides `FarmAnimal` speak method. The `Cow#speak` method calls superclass method `FarmAnimal#speak` using the `super` keyword and concatenates the return value to the string `"mooooooo!"`, returning the new string.

This when we instantiate new `Sheep`, `Lamb`, and `Cow` instances, call speak on them, and pass the return values to the `Kernel#p` method, on lines 25-27, the output will be something like:

```
"#<Sheep:0x00007f60b86d9cf8> says baa!"
"#<Lamb:0x00007f60b86d99b0> says baa!baaaaaaa!"
"#<Cow:0x00007f60b86d9708> says mooooooo!"
```

The object ids may be different.

8m58s



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

Collaborator objects are objects of any class that become part of another object's state. They are called collaborators because they provide functionality that aids the object in fulfilling its responsibilities.

We define a `Person` class on lines 1-5. The `Person#initialize` constructor is defined with one parameter, `name`, which it uses to initialize the instance variable `@name`

We define a `Cat` class on lines 7-12. The `Cat#initialize` constructor is defined with two parameters, `name` and `owner`. It uses the parameters to initialize two instance variables, `@name` and `@owner` respectively.

On line 14, we initialize local variable `sara` to a new `Person` object, passing the string `"Sara"` through to the constructor, where it is used to initialize `@name` in our `Person` object. Since this String object is now part of the state of `sara`, `"Sara"`, is thus a collaborator object of `sara`.

On line 15, we initialize a local variable `fluffy` to a new `Cat` object, passing through to the constructor the String `"Fluffy"` and the `Person` object `sara` to be used to initialize `@name` and `@owner` respectively. This means that `"Fluffy"` and `sara` are now collaborator objects of the `Cat` object `fluffy`, since they have become part of the state of `fluffy` and could be used to fulfill the `Cat` object's responsiblities.

It is most important to think about collaborations between objects from the class design phase onward. We can say that our `Person` class has the String class as a collaborator, since a String object should become part of a `Person` object's state by being tracked by its `@name` variable. We can say that `Person` and String are both collaborators of the `Cat` class. 

10m08s



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

A `case` statement like the one above implicitly calls the `===` method on the expressions following the `when` keywords. If the `===` method returns `true`, the `when` clause is followed, otherwise we move to the next `when` condition.

The `===` method can be invoked through syntactic sugar that makes it appear as an operator, but it is a method like any other. The `Object` class defines `===` as an alias for `BasicObject#==`, but most classes that make use of it override it with their own implementation with a more meaningful semantic.

In our example, we initialize local variable `number` to the integer `42`.

On lines 3-7, we have a `case` statement that compares `number` against the `when` conditional expressions. Each comparison is made using the `===` method of the class of the object following the `when` keyword.

On line 4, the object following `when` is the Integer `1`, so `Integer#===` will be called with `number` passed as argument. An Integer caller and Integer argument means that `Integer#===` will return `true` only if caller and argument are the same. They are not, and so we  move to the next `when` clause.

On line 5, there are three Integer objects separated by commas. The commas here are equivalent to logical OR, so the `Integer#===` method is called for each of the Integer objects, `10`, `20`, and `30`, with `number` passed as argument until either one returns `true` or they all return `false`. In this case, they all return `false` so we move to the next `when` clause.

On line 6, the calling object will be a Range, and so `Range#===` is called with `number` passed as argument. Since `42` is contained in the Range `40..49`, the `===` method returns `true` and the object following the `then` keyword for this clause, `'third'`, is returned by the `case` statement.

11m30s



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

On line 1, we initialize local variable `number` to the integer `42`.

On lines 3-7 is a `case` statement, which switches on `number`. The `case` statement has a sequence of `when` clauses. Ruby implicitly calls the `===` method on each of the conditional expressions following the `when` keyword. If `===` returns `true`, that `when` clause is followed. Otherwise, we move to the next clause.

The `===` method is defined in `Object` but is overridden by classes that make use of it to offer a meaningful semantic. Although syntactic sugar makes `===` appear as an operator, in Ruby it is a method like any other. The meaning of `===` is to check whether the object passed as argument could be considered part of the group represented by the caller.

On line 4, the object following the `when` keyword is an Integer, so `Integer#===` is called with `number` passed as argument. This would return `true` if `1` and `number` reference the same Integer. They do not, so `===` returns `false` and we move to the next clause.

On line 5, the `when` condition is a sequence of comma-separated Integer objects. The commas act similarly to logical OR, so Ruby will implicitly call `Integer#===` for each of the Integer objects `10`, `20`, and `30`, with `number` passed as argument. If any of these calls return `true`, the clause is executed. But they all return `false`.

On line 6, the object following `when` is a Range, so `Range#===` is called with `number` passed as argument. Since `42` is a member of the Range `40..49`, this call to `===` returns `true` and this clause is followed, returning the string `'third'`.

7m12s



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

We define a `Person` class on lines 1-13.

`TITLES` , on line 2, is a constant variable. Since its reference should not change once initialized, a constant variable is normally called a constant. Ruby will give a warning if the constant is reassigned. Constants have lexical scope. This means that the scope of the constant `TITLES` is the lexical structure in the source code surrounding its definition, any lexical structures lexically-enclosed by that lexical structure, and through inheritance, any subclasses of the lexical structure (if it is a class) or any classes that include it (if a module) along with their subclasses. Since `Person` is not a module and has no subclasses, the scope of `TITLES` without namespace qualification is the `Person` class. A constant can also be referenced directly using the `::` namespace resolution operator from anywhere in the program, e.g. `Person::TITLES`.

On line 4, we initialize `@@total_people`, a class variable. The scope of a class variable is the class that initializes it, any descendant classes, and all instances of all of those classes. This greatly expanded scope is why many Rubyists advise using class variables with inheritance.

On lines 6-9 we define the instance method `initialize` constructor. On line 7, we initialize an instance variable `@name` within the instance method. An instance variable initialized in an instance method is scoped at the object level and tracks the individual state of the object. Whenever the instance method that initializes the variable is called on an object, a new instance variable is initialized in the object's scope and is particular to that object. The instance variable is not accessible to any other object (except via the public methods that expose it, if any). An instance variable is accessible throughout the instance methods of the object, regardless of which one initialized it. Instance variables persist for the lifetime of their object.

On lines 10-12, we define another instance method, `age`. Within the definition body, on line 11, the `@age` variable referenced is an instance variable. The scope of this variable again at the object level. However, since no method in `Person` actually initializes an `@age` instance variable, this reference will simply evaluate to `nil` without initializing an instance variable called `@age`. This is because any reference to an uninitialized instance variable simply evaluates to `nil`, unlike references to uninitialized local variables, which raise a `NameError`.

14m24s



51.

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

We define a `Person` class on lines 1-13. `TITLES`, initialized on line 2, is a constant variable. Since the reference of a constant variable should not change once it is initialized (or defined), constant variables are usually just called constants.

Constants have lexical scope. This means a reference to a constant is first searched for in the lexically enclosing structure surrounding the reference in the source code. This lexical search is widened to any lexical structures that enclose the enclosing lexical structure, continuing outward up to but not including the top-level. After this, the inheritance hierarchy of the lexically enclosing structure is searched, and finally top-level.

`TITLES` can therefore be referenced from anywhere in the `Person` class. Since `Person` does not nest any other classes or modules, and has no subclasses, this is the limit of the unqualified scope. We can also reference a constant from anywhere in the program using the name of the class or module where it is defined and the namespace resolution operator `::`, e.g. `TITLES::Person`.

The `@@total_people` variable initialized on line 4 is a class variable. The scope of a class variable is the class where it is initialized and all of its instances, and any descendant classes and their instances. This greatly expanded scope is why Rubyists advise against using class variables with inheritance. The scope of `@@total_people` is therefore the `Person` class and any instances of it.

The `@name` variable initialized in the `Person#initialize` instance method on line 7 is an instance variable. Instance variables are scoped at the object level and track the individual state of an object. Therefore, when `initialize` is called on a `Person` object when the object is instantiated, a `@name` instance variable is initialized in that instance and is unique to that instance, tracking its unique state. An instance variable is accessible throughout the instance methods of the instance, regardless which instance method initialized it.

On line 11, in the `Person#age` instance method definition, we have what appears to be a reference to another instance variable, `@age`. However, since there is no instance method that initializes an `@age` instance variable available to `Person` objects, calling the `age` method on a `Person` object will simply return `nil`. A reference to an uninitialized instance variable will always evaluate to `nil` without initializing  any instance variable.

11m39s



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

We define the `Cat` class on lines 1-12. The call to `Module#attr_accessor` on line 2 generates getter and setter methods for `@type` and `@age` instance variables. The constructor `Cat#initialize` initializes these instance variables.

The `Cat#make_one_year_older` instance method is defined on lines 9-11. The only line in the definition body calls the `age=` setter method to reassign `@age` to the integer one higher than the one it currently references.

It is necessary to call the setter method `age=` explicitly on `self` because otherwise the syntax would be impossible to disambiguate from the initialization of a local variable `age`. Thus  in order to avoid using the keyword `self`, we cannot call the setter method. Instead, we would need to set the instance variable `@age` directly:

```ruby
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    @age += 1
  end
end
```

It is considered best practice to use a setter method, if available, rather than setting an instance variable directly, even within instance methods within the class. This means that any additional logic surrounding setting the variable that we may wish to implement later can simply be added in one place to the setter method, rather than in every place in the class where the variable needs to be set. This reduces code dependencies (the instance methods no longer depend on a specific variable, only on a method interface whose implementation can be changed) and makes code more maintainable.

9m0s



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

This code will raise a `NoMethodError` exception. The reason has to do with mixin modules and module methods.

We define a `Driveable` module on lines 1-4. We define a `drive` method on the module itself using the `self` keyword to reference the `Driveable` module, using the same syntax we would use to define a class method. Methods defined on the module itself are sometimes called 'module methods' and are called directly on the module, e.g. `Driveable.drive`.

We define a `Car` class on lines 6-8. On line 7, we mix in the `Driveable` module. Mixing in a module gives instances of the class access to the instance methods defined in the module, but not methods defined on the module itself. These module methods will not be available to invoke on `Car` or its instances.

On line 10, we instantiate a new `Car` object to which we initialize local variable `bobs_car`. When we call `drive` on `bobs_car` on line 11, we raise a `NoMethodError` because we have attempted to call a module method defined on the `Driveable` module on an instance of `Car`, and mixing in the module to the `Car` class does not make this possible.

If we wanted to be able to call `drive` on `Car` objects, we could remove the `self.` prefix from the `drive` definition.

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

`drive` is now defined as an instance method rather than a module method and can now be called on objects of `Car`, since `Car` mixes in the `Driveable` module and its objects gain access to instance methods defined therein.

8m27s



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

Running this code as it stands would produce a `NoMethodError` instead of the desired output. The reason is that we have not defined the `House#<` or `House#>` that we attempt to call on lines 11-12, nor does the `House` class inherit definitions for these methods.

In Ruby, the `>` and `<`  methods have syntactic sugar that allows their invocations to appear as operators, but they are methods like any other. Many classes acquire these methods by defining a `<=>` method and mixing in the `Comparable` module, which depends only on a `<=>` definition to grant many comparison methods. We can simply define these methods directly, however.

The `>` method is conventionally defined to compare a chosen principal object value of the caller with the object value of the argument (an object of the same class), returning `true` if the caller's value is greater, `false` otherwise. The `<` operator checks if the caller's value is less than the argument's.

In our `House` class, our only object value is the Integer tracked by the `@price` instance method. We already have a public `price` method that can return the reference of this variable, so we can define our `House#>` and `House#<` methods to compare the return values of calling `price` on the calling  object and on the argument using the `Integer#>` and `Integer#<` methods:

```ruby
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
  
  def >(other)
    price > other.price
  end
  
  def <(other)
    price < other.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```

This code now gives the desired output.

8m02s

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

As it stands our code will raise a `NoMethodError` for each attempt to call `>` or `<` on a `House` object. This is because we have not defined these methods for the `House` class (lines 1-7) and `House` does not inherit these methods either.

`>` and `<` have syntactic sugar that means their invocations appear as operators, but they are methods like any other. `>` is conventionally defined to compare a chosen value in the calling object with the value in the argument of the same class, returning `true` if the caller's value is considered greater than the argument's, `false` otherwise. The `<` method checks if the caller's principal object value is less than the argument's.

We could define these methods directly in `House`, but `>` and `<` are some of the methods we can provide to our class by mixing in the `Comparable` module. The only dependency to make this possible is that we must define a `<=>` method in our class for `Comparable` instance methods to use.

The `<=>` method is conventionally defined to compare the principal object value of the caller with that of an argument of the same class. `<=>` returns `-1` if the caller's value is less than the argument's, `1` if the caller's is greater, and `0` if they are equivalent.

So we can simply define a `House#<=>` method that makes comparison using the only object value in our `House` class, the `price` attribute. Then we can mix in `Comparable` and gain access to `>` and `<` methods. Since the `price` attribute tracks an Integer object, `Integer#<=>` will provide the return value.

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

This code now produces the desired output.

8m31s



















