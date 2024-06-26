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

We define a `Person` class on lines 1-7. On line 2, we generate a getter method `name` for the instance variable `@name` with a call to `Module#attr_reader`. We define a `set_name` instance method that sets `@name` to the string `"Bob"`.

After the class definition, we initialize a local variable `bob` to a new `Person` object. On line 10, we call `name` on `bob` and pass the return value to `Kernel#p` to be output. The output will be `nil`.

The reason for this is that we have not initialized a `@name` instance variable in our `bob` object, so `Person#name`, which returns a reference to `@name`, returns `nil`. A reference to an uninitialized instance variable always evaluates to `nil`, unlike a reference to an uninitialized local variable, which raises a `NameError` exception.

4m24s



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

We define a `Swimmable` module on lines 1-5, within which we define an instance method `enable_swimming`. The body of the method definition sets a `@can_swim` instance variable to `true`.

On lines 7-13, we define a `Dog` class that mixes in `Swimmable`. We define a `Dog#swim` instance method that returns the string `"swimming"` if the `@can_swim` variable evaluates to a truthy value.

After these definitions, on line 15, we initialize local variable `teddy` to a new `Dog` object.

On line 16, we call `swim` on `teddy` and pass the return value to `Kernel#p` to be output. The output will be `nil`.

Since we have not called `enabled_swimming` on our `teddy` object, the reference to `@can_swim` in the `swim` method on line 11 will evaluate to `nil`. This is because an uninitialized instance variable always evaluates to `nil`, without initializing the variable. Since `nil` is the only object in Ruby other than `false` which is a falsey value, the `if` modifier condition fails, and so the `"swimming"` string is not evaluated. Since there is no other expression in the method definition, `swim` returns `nil`.

This demonstrates two things about instance variables. First, as previously mentioned, uninitialized instance variables evaluate to `nil`, rather than raising a `NameError` as references to uninitialized local variables do. Secondly, an instance variable will only be initialized in an object once the instance method that initializes it has actually been called on the object.

If we were to call `enable_swimming` on `teddy`, then `@can_swim` would be initialized to a truthy value and `swim` would return `"swimming!"`.

8m25s

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

The code as it stands will output `4` twice and then raise a `NameError`.

We define a `Describable` module on lines 1-5. This module contains an instance method definition for the `describe_shape` method. This interpolates two expressions into a string and returns the string. The first expression is `self.class`. `self` here references the calling object, and the `Kernel#class` method returns the class of the caller. Therefore, this expression evaluates to the class of the calling object. The second expression is an unqualified reference to a `SIDES` constant.

Constants have lexical scope. This means that when Ruby encounters an unqualified reference to a constant, it first performs a lexical search to resolve it. This begins with searching the lexically enclosing structure that surrounds the reference in the source code, in this case the `Describable` module, where it is not found. The lexical search widens to search every lexical structure that encloses the first lexical structure up to but not including top-level. In this case, the lexical search just searches `Describable`. Next, Ruby searches the inheritance hierarchy of the lexically enclosing structure, and then finally top-level. Since the lexically enclosing structure here is a module, and it does not include any other modules, this part of the search will only include top-level, where no `SIDES` constant is defined. This is why the call to `describe_shape` on line 27 raises a `NameError`.

The `Shape` class is defined on lines 7-17 and mixes in the `Describable` module. We define a class method `Shape::sides` on lines 10-12. This returns the return value of the expression `self::SIDES`. `self` here references the class the method has been called on. This could be `Shape` or any of its descendant classes. We use the namespace operator `::` to qualify the reference to a `SIDES` constant. The whole expression thus dynamically resolves to the `SIDES` constant of the calling class. This is why the call to `sides` on `Square`, a subclass of `Shape`, on line 25 returns `4`. The `Square` class inherits from `Quadrilateral`, which defines `SIDES` as `4`, and once the lexical search is over, the inheritance part of the constant resolution search will find it there.

On lines 14-17 we define a `Shape#sides` instance method. This returns the return value of the expression `self.class::SIDES`. In an instance method, `self` references the calling object. We call `class` on this object to return the calling object's class, then use the namespace operator to reference the `SIDES` constant of that class. This is why when we call `sides` on a new instance of the `Square` class, a subclass of `Shape`, on line 26, the return value will be `4`. Again, Ruby will search `Square` for a `SIDES` constant, will not find it, and begin the inheritance part of the search. This begins with the superclass `Quadrilateral`, where `SIDES` is defined as `4`.

15m44s



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

The code as it stands outputs something like the following (object ids will vary):

```ruby
[#<Animal:0x00007f0ea94996e8 @name="Human">, #<Animal:0x00007f0ea94995f8 @name="Dog">, #<Animal:0x00007f0ea9499580 @name="Cat">, #<Animal:0x00007f0ea9499440 @name="Eagle">, #<Animal:0x00007f0ea9499378 @name="Blue Jay">, #<Animal:0x00007f0ea9499300 @name="Penguin">]
```

This Array object is not in line with what we would expect a custom collection class like `AnimalClass` to return from a custom `+` method.

`AnimalClass` is defined on lines 1-24 as a collection class. As is clear from line 6 in the constructor definition body, and from the `Animal#<<` method (lines 9-11), this class stores objects in an Array, and these objects will be of the `Animal` class, defined on lines 18-24.

The `AnimalClass#+` method is defined on lines 13-15. Although the `+` method has syntactic sugar that makes it appear as an operator when invoked, it is a method like any other. Conventionally, this method performs either addition or, in the case of collection classes and String, concatenation, and it conventionally returns a new object of the calling class.

The `AnimalClass#+` method does not return a new `AnimalClass` however. This breaks convention unexpectedly, making the class harder to use and understand, and therefore making errors more likely. The `AnimalClass#+` method has one parameter, `other_class`, which we expect to reference another `AnimalClass` object. The definition body calls the getter method `AnimalClass#animals`, which returns the Array of `Animal` objects referenced by `@animals`, and then uses `Array#+` to concatenate this Array to the return value of calling `animals` on the `AnimalClass` argument. The return value of `Array#+` will be an Array, and this is what `AnimalClass#+` returns.

In order to return a new `AnimalClass` object, we can redefine the constructor to allow a new object to be constructed with an existing `animals` array, and then use the return value from `Array#+` in the `AnimalClass#+` method to instantiate a new object:
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

This code now returns a new `AnimalClass` object as expected from Ruby core classes and standard library conventions.

11m59s





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

We define a `GoodDog` class on lines 1-19. The constructor `GoodDog#initialize` is defined with three parameters that it uses to initialize the instance variables `@name`, `@height`, and `@weight`. We generate getter and setter methods for these instance variables with a call to `Module#attr_accessor` on line 2.

The `GoodDog#info` method interpolates these three instance variables into a string and returns it.

The `GoodDog#change_info` method defined on lines 16-18 is where the problem with our code lies. The method is defined with three parameters, and seems to intend to call the three setter methods to reassign the `GoodDog` object's instance variables to the parameters.

When we call an instance method on the calling object within another instance method definition within the class, we can simply call the method without an explicit object or the dot operator. The implicit caller is the calling object. However, setter methods cannot be called this way because the syntax for calling a method that ends in `=` is impossible to disambiguate from the initialization of a new local variable. So lines 11-13 of the `change_info` method simply initialize three new local variables `name`, `height`, and `weight`, instead of calling the setter methods. To call a setter method within an instance method definition within the class, we must explicitly call the method on `self`, which references the calling object within an instance method.

This is why the code as it stands outputs: `Spartacus weighs 10 lbs and is 12 inches tall.`.

To rectify this, we can simply call the setter methods explicitly on the calling object using the keyword `self`:

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

This code now outputs the expected output.

9m04s

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

We define the `Person` class on lines 1-11. The `initialize` constructor is defined with one parameter `name` which it uses to initialize instance variable `@name`. We generate getter and setter methods for this variable with a call to `Module#attr_accessor` on line 2.

The `Person#change_name` method, defined on lines 8-10, is where the problem with our code lies. The method definition body seems to attempt to call the `name=` setter method in order to reassign `@name` to the return value of calling `String#upcase` on the return value of the `name` getter method. However, this is not what is happening.

In an instance method definition, we can normally call another instance method of the class implicitly on the calling object simply by not calling it on any explicit object using the dot operator. With setter methods, this is not the case, since the syntax for calling a method whose name ends in `=` without an explicit object is impossible to disambiguate from the initialization of a new local variable. Instead, we must explicitly call a setter method on the calling object referenced by keyword `self` using the dot operator.

What is actually happening here is that the `name` on the left side of the assignment operator is a new local variable. Since we have referred to this variable on the left hand side, Ruby quietly initializes the new local variable `name` to `nil` before evaluating the right hand side. Therefore, the `name` on the right hand side is also this new local variable, which evaluates to `nil`. Ruby then tries to call `upcase` on `nil`, which does not have such a method, leading to the `NoMethodError` that this code raises when `change_name` is called on a `Person` object on line 15.

In order to rectify this, we can simply change line 9 to call `name=` explicitly on `self`:

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

This code now outputs the expected output.

9m11s



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

The code above outputs

```
4
2
2
2
2
2
```

We define a `Vehicle` class on lines 1-7. On line 2, we initialize a class variable `@@wheels` to `4`. Since this happens within the class but outside of any method definition, this initialization takes place as soon as the class is evaluated by Ruby. We define a class method `Vehicle::wheels` that returns the reference of `@@wheels`.

On line 9, we call class method `wheels` on `Vehicle`, pass the return value to `Kernel#p` and this outputs `4`.

On lines 11-13, we define class `Motorcycle` as a subclass of `Vehicle`. Within the class definition outside of any method definition, we reassign `@@wheels` to `2`. This is a reassignment rather than an initialization because a class variable is shared between the class that initializes it (here `Vehicle`) and all of its descendant classes, and every instance of all of those classes.

On lines 15-16, we call `wheels` on `Motorcycle` and on `Vehicle` and pass the return values to `p`, which for both superclass and subclass outputs `2`. This code demonstrates that class variables are not inherited but actually shared by descendant classes. When we set `@@wheels` to `2` on line 12 within the `Motorcycle` class, this changed the reference of the `@@wheels` variable in the `Vehicle` class because they are the same variable.

On line 18, we define a `Car` class as another subclass of `Vehicle`.

We then call `wheels` on `Vehicle`, `Motorcycle`, and `Car` on lines 20-22, each time passing the return value to `p`. For the superclass and both its descendant classes, the value of `@@wheels` is still `2`.

Since a class variable initialized in a superclass is shared with all of its descendant classes, this greatly expanded scope can be very difficult to reason about, in ways similar to global variables. Because of this, many Rubyists advise not using class variables with inheritance. Some advise not using class variables at all.

11m51s



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

This code will output something like `#<GoodDog:0x00007f4939e9a4b0 @name="brown", @color="brown">`, though the object id may be different. This is a string representation of a `GoodDog` object with both instance variables, `@name` and `@color`, assigned to the string `"brown"`.

We define the `Animal` class over lines 1-7. The `Animal#initialize` constructor is defined with one parameter `name` which it uses to initialize instance variable `@name`.

We define the `GoodDog` class (lines 9-14) as a subclass of `Animal`. The `GoodDog#initialize` constructor takes one parameter `color`. Within the definition body, on line 11, we use the `super` keyword to call the next method further up the method lookup path with the same name, here the `Animal#initialize` method. Since we have not used parentheses after `super`, the arguments to `GoodDog#initialize` are all passed through to `Animal#initialize`. Thus the string assigned to parameter `color` will be used to initialize an instance variable `@name` in our `GoodDog` object. After the superclass method returns, we then use `color` to initialize another instance variable `@color`. This explains why the `GoodDog` object that is passed to `Kernel#p` to be output, on line 17, has the same string `"brown"` for the value of both instance variables.

The object is instantiated on line 16 with the string `"brown"` passed through to the constructor and as things stand this string is used to initialize both variables.

This demonstrates that the `super` keyword used without parentheses passes all arguments to the subclass method through to the superclass method. If we use empty parentheses, no arguments will be passed. We can also pass specific objects within the parentheses.

8m23s



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

As it stands, this code will raise an `ArgumentError` exception.

We define an `Animal` class on lines 1-4. The `Animal#initialize` constructor takes no parameters.

We define the `Bear` class on lines 6-11 as a subclass of `Animal`. The `Bear#initialize` constructor takes a single parameter `color`. Within the definition body, on line 8, we call the superclass method `Animal#initialize` using the `super` keyword. `super` will call a method of the same name as the current method further up the inheritance hierarchy. When used without parentheses, as here, all the arguments to the subclass method will be passed through to the superclass method. Here, this is a problem, since `Bear#initialize` takes one argument but `Animal#initialize` takes none. This is why this code raises an exception on line 13, when we attempt to instantiate a new `Bear` object. We pass the string `"black"` through to the `Bear#initialize` method, and this method uses the `super` keyword without parentheses, calling `Animal#initialize` with `"black"` passed as argument. Since the superclass method takes no arguments, the `ArgumentError` exception is raised.

`super` called without parentheses passes all arguments to the subclass method through to the superclass method of the same name. With empty parentheses after `super`, no arguments are passed to the superclass method. We can also pass specific arguments within the parentheses like an ordinary method call.

6m04s



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

We instantiate a new `GoodAnimals::GoodDog` object on line 44, and then on line 45 we call a `walk` method on the object.

The method lookup path begins with the class of the object, `GoodAnimals::GoodDog`. Ruby does not find it here, so it searches the mixed in modules in the reverse order of the calls to `Module#include` that mixed them in: first `Danceable`, then `Swimmable`. Since there is no `walk` method in either of these, Ruby then searches the superclass, `Animal`.

The `Animal` class does not define a `walk` method. So next, Ruby searches the mixed in module `Walkable`. Here, Ruby finds a `walk` definition and executes the method. This method, defined on lines 2-4, returns a string, which back on line 45 is passed to the `Kernel#p` method to be output: `"I'm walking."`

We could view the entire method lookup path for methods called on `GoodAnimals::GoodDog` objects by calling `ancestors` on the class. This returns the array of the classes and modules searched in the order Ruby would search them: `[GoodAnimals::GoodDog, Danceable, Swimmable, Animal, Walkable, Object, Kernel, BasicObject]`

5m50s

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

This code outputs

```
I eat.
I eat plankton.
I eat kibble.
```

We define an `Animal` class on lines 1-5. `Animal` defines an `eat` instance method, which outputs the string `"I eat."` using the `Kernel#puts` method.

The `Fish` class is defined on lines 7-11 as a subclass of `Animal`. The `Fish` class overrides the `Animal#eat` method with its own implementation. This uses `puts` to output `"I eat plankton."`.

On lines 13-17 the `Dog` class is defined as a subclass of `Animal`. This class also overrides `Animal#eat` with its own implementation, which outputs `"I eat kibble."`.

This demonstrates applying polymorphic structure to our code through class inheritance. Through inheritance, the subclasses of `Animal` can respond to a common interface -- the `eat` method (although method overriding is used to provide specialized implementations for the subclasses).

We can see polymorphism in action on lines 19-26.

On line 23, we initialize local variable `array_of_animals` to an array containing a new `Animal` object, a new `Fish` object, and a new `Dog` object.

On lines 24-26, we call `Array#each` on `array_of_animals`, which iterates through the array passing each object to the block to be assigned in turn to the `animal` block parameter. The block is not concerned with the class or type of the objects. The block simply passes each `animal` in turn to the `feed_animal` method.

The `feed_animal` method is defined on lines 19-21 with one parameter `animal`. The `feed_animal` method is not concerned with the type or class of the objects passed to it. All it needs to be concerned with is that the objects respond to the common interface of an `eat` method invocation. This is polymorphism, the ability of types to respond to a common interface, often but not always with different implementations.

This code demonstrates implementing polymorphism through class inheritance.

9m27s

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

We raise an error on line 28 because we have attempted to call a `jump` method on an Array object.

We define the `Person` class on lines 1-8. The `Person#initialize` constructor is defined with one parameter `name` which it uses to initialize instance variable `@name`. The body of the definition also initializes instance variable `@pets` to an empty array. We generate getters and setters for these variables with a call to `Module#attr_accessor` on line 2.

We define a `Pet` class on lines 10-14. The `Pet` class defines the instance method `jump`.

On lines 16-18 we define the `Cat` class and `Bulldog` class as subclasses of `Pet`.

On line 20, we initialize local variable `bob` to a new `Person` object. On line 22, we initialize local variable `kitty` to a new `Cat` object. On line 23, we initialize local variable `bud` to a new `Bulldog` object.

On line 25, we call the `pets` getter method on `bob` and chain the `Array#<<` method to add `kitty` to the `@pets` array. On line 26 we repeat this for `bud`.

On line 28, we call the `pets` getter method on `bob` again, returning the array tracked by `@pets`. We then attempt to call `jump` on this array, raising a `NoMethodError` exception.

`kitty` and `bud` are tracked by the state of the `bob` object and thus represent collaborator objects. Although it is an Array object that is actually tracked by `bob`'s instance variable, this could be considered largely an implementation detail. Collaboration is as much a class design consideration as it is something that happens at runtime, and as such the significant collaborators of the `Person` class are the `Cat` and `Bulldog` classes, since these are the classes we have designed ourselves and Array is a built-in class that allows us to implement this relationship between our classes.

Clearly the intent of the code is to call `jump` on the objects in the `pets` array. We can do this using an iterator method:

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

10m52s



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

The above code outputs `bark! bark!  bark! bark!`.

We define an `Animal` class on lines 1-5. The `Animal#initialize` constructor is defined with one parameter `name`, which it uses to initialize instance variable `@name`.

We define the `Dog` class as a subclass of `Animal` on lines 7-13. The `Dog#initialize` method overrides the superclass constructor, and again is defined with one parameter. However, the method definition body is empty.

We define a `Dog#dog_name` instance method on lines 10-12. The body of the definition returns a string involving interpolation of a `@name` instance variable: `"bark! bark! #{@name} bark! bark!"`.

On line 15, we initialize local variable `teddy` to a new `Dog` object. We pass the string `"Teddy"` to the `Dog#initialize` constructor, but as noted, this method does nothing.

Therefore, when we call `dog_name` on `teddy` on line 16, the `dog_name` method will attempt to interpolate an uninitialized instance variable into the string it returns. Unlike references to uninitialized local variables, which raise a `NameError`, references to uninitialized instance variables simply evaluate to `nil`. Thus `@name` on line 11 will here evaluate to `nil`. Since string interpolation implicitly calls `to_s` on interpolated expressions, and `NilClass#to_s` returns an empty string, there will simply be no characters added to the string. This is why, when the return value of `dog_name` is passed to `Kernel#puts`, the output is simply `bark! bark!  bark! bark!`.

We could fix this code by simply removing the empty definition for `Dog#initialize`, since the constructor `Dog` inherits from `Animal` will initialize the `@name` variable.

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

This code now outputs `bark! bark! Teddy bark! bark!`

8m47s

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

We define a `Person` class with a `name` attribute on lines 1-7. The `Person#initialize` constructor takes one parameter and uses it to initialize the instance variable `@name`. A getter method is generated for `@name` with a call to `Module#attr_reader` on line 2.

On line 9, we initialize local variable `al` to a new `Person` object with the string literal `"Alexander"` passed through to the constructor. On line 10, we initialize local variable `alex` to a new `Person` object with the string literal `"Alexander"` passed through to the constructor.

On line 11, we call the `==` method on `al` with `alex` passed as argument, and pass the return value to `Kernel#p`, which outputs `false`.

The `==` method has syntactic sugar that makes it appear as an operator, but it is a method that can be defined like any other. The conventional meaning of `==` for classes in Ruby's standard library is to compare the principal value of two objects of the same class, returning `true` if these principal object values are equivalent, `false` otherwise. By default, a custom class will inherit `BasicObject#==`. This implementation compares as the principal value the object id of the caller and argument, returning `true` only if they have the same object id, `false` otherwise. This means that it will only return `true` if caller and argument are exactly the same object. This functionality is typically handled by the `equal?` method, and most built-in classes override it to provide a principal object value to compare.

We can override `==` in our custom class to compare `Person` objects based on the principal value of their `name`, like so:

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

This code now returns `true`.

This does not mean that the string referenced by the `name` attribute of `al` is the same object as the string referenced by calling `name` on `alex`. Since we used string literals to construct both objects, each string will be a new String object. We can confirm this by calling `object_id` on their `name` attributes and comparing them using `Integer#==`:

```ruby
al.name.object_id == alex.name.object_id # false
```

12m25s



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

We define a `Person` class on lines 1-11. The `initialize` constructor is defined with one parameter `name`, which it uses to initialize instance variable `@name`. We generate a getter method for this variable with a call to `Module#attr_reader` on line 2.

We define a `Person#to_s` method on lines 8-10. The body of the definition interpolates into a string the return value of calling the destructive method `String#upcase!` on the return value of getter method `Person#name`. Since this method mutates the object, this means that the first time we call this method the string referenced by `name` will be permanently changed.

On line 13, we initialize local variable `bob` to a new `Person` object, passing the string `"Bob"` through to the constructor to be used to set `@name`. On line 14, we call `name` on `bob` and pass the return value to `Kernel#puts` which outputs `"Bob"`. 

On line 15, we pass `bob` directly to `puts`. Since `puts` implicitly calls `to_s` on its arguments, `Person#to_s` is called on `bob`, returning the string `"My name is BOB."`, which is output. The string tracked by `@name` has been permanently mutated.

This is confirmed by line 16, when we again call `name` on `bob` and pass the return value to `puts`. The output is `"BOB"`.

5m57s

16.

```ruby
# Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example.
```

It is considered safer to invoke a setter method (if available) rather than setting the instance variable directly even within the class because this isolates the logic for actually setting the variable in one place. This means we are free to make changes to the logic in one place without having to change every method in the class that needs to set the variable. This makes the class more maintainable, and reduces dependencies on the representation of the object. We could split the data tracked by the variable so that it is tracked by two variables and, as long as we continue to expose the setter method with the same name, our existing code will not break.

For instance, if we started with the following code:

```ruby
class Person
  attr_accessor :name, :age

  def initialize(name, age)
    self.name = name
    self.age = age
  end
  
  def change_name(new_name)
    self.name = new_name
  end
  
  def change_info(new_name, new_age)
    self.name = new_name
    self.age = new_age
  end
end

bob = Person.new("Robert Jones", 33)
bob.change_name("Bob Jones")
```

Since we have used the setter method `name=` in our instance methods, if we want to split the name so that it is tracked by `@first_name` and `@last_name` variables, we need only change the implementation of the `name=` and `name` setter and getter methods, rather than every method that deals with the `name` attribute:

```ruby
class Person
  attr_accessor :age

  def initialize(name, age)
    self.name = name
    self.age = age
  end
  
  def change_name(new_name)
    self.name = new_name
  end
  
  def change_info(new_name, new_age)
    self.name = new_name
    self.age = new_age
  end
  
  def name=(name)
    @first_name, @last_name = name.split
  end
  
  def name
    @first_name + ' ' + @last_name
  end
end

bob = Person.new("Robert Jones", 33)
bob.change_name("Bob Jones")
```

Using the setter method rather than setting the variable directly means that we can change the logic surrounding setting the variable in one place only. This greatly reduces the chances of human error is repeating code, and isolates the logic in one place, making debugging simpler if we do make a mistake.

12m27s



17.

```ruby
# Give an example of when it would make sense to manually write a custom getter method vs. using `attr_reader`.
```

We need to write a custom getter method rather than relying on `Module#attr_reader` whenever we need to manipulate, format, or obscure the data tracked by an instance variable before returning it.

For instance, if we decided to store the `name` of a `Customer` in a format that was amenable to database queries, for instance all-uppercase, but wanted to expose a getter method that returned the `name` in standard human-readable capitalized format, we might write the getter method as follows:

```ruby
class Customer
  def initialize(name)
    @name = name.upcase
  end
  
  def name
    @name.split.map(&:capitalize).join(" ")
  end
end

bob = Customer.new("Robert Jones")
p bob
p bob.name
```

Output (object id will be different):

```
#<Customer:0x00007f6d5619aa30 @name="ROBERT JONES">
"Robert Jones"
```

4m34s

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

We define a `Shape` class on lines 1-11. Within the class definition outside of any method definition, on line 2, we initialize class variable `@@sides` to `nil`. This initialization happens as soon as the class definition is evaluated by Ruby. We define a class method `Shape::sides` that returns the reference of `@@sides`.

We define a `Triangle` class as a subclass of `Shape`. The `Triangle#initialize` constructor sets `@@sides` to `3`. This is reassignment, not an initialization, and since this is an instance method, this will only happen when a new `Triangle` is instantiated and the constructor method is called.

On lines 19-23, we define a `Quadrilateral` class as a subclass of `Shape`. The `Quadrilateral#initialize` constructor sets `@@shape` to `4`. Again, this will only happen if a `Quadrilateral` is instantiated.

So, if we were to execute `Triangle.sides` after these definitions, the return value would be `nil`, since the only setting of the variable that has been executed so far is on line 2.

If we were to execute `Triangle.new.sides`, the `Triangle#initialize` constructor would be called by `Triangle::new` and the reassignment on line 15 would take place. Then, calling the inherited `Shape#sides` method on the new `Triangle` instance would return `3`.

This demonstrates that class variables are not inherited by subclasses but actually shared between the class that initializes them and all of its subclasses, and all of their instances. Because of this greatly expanded scope, many Rubyists advise against using class variables in combination with inheritance. Some Rubyists advise against using class variables at all.

8m49s

19.

```ruby
# What is the `attr_accessor` method, and why wouldn’t we want to just add `attr_accessor` methods for every instance variable in our class? Give an example.
```

The `Module#attr_accessor` method takes Symbol objects as arguments and generates setter and getter methods for an instance variable with the name given by the Symbol value.

For instance, to generate setter method `name=`, getter method `name`, for a `@name` instance variable, in a `Person` class definition, we would write:

```ruby
class Person
  attr_accessor :name
end
```

There are multiple reasons we would not simply use `attr_accessor` to generate setters and getters for every instance variable in a class.

The getters and setters generated by `attr_accessor` are simple getters and setters. If we wish to add checks on the argument to our setter method, we need to write a custom setter. If we wish to format data tracked by an instance variable before returning it from our getter method, we must write a custom getter.

As an example, we may wish to format or obscure data before returning it from a getter. This leaves us no choice but to write a custom getter. We can use `Module#attr_writer` for the setter method, which only generates a setter method. (We could use `Moduile#attr_reader` to generate only a getter).

```ruby
class Customer
  attr_writer :bank_number

  def initialize(bank_number)
    self.bank_number = bank_number
  end
  
  def bank_number
    "xxxx-xxxx-xxxx-#{@bank_number[-4..-1]}"
  end
end

customer = Customer.new("4234-9823-3293-2134")
puts customer.bank_number # xxxx-xxxx-xxxx-2134
```



We wish to keep the interface to our class as simple as possible. Generating public setters and getters for every instance variable is not always desirable. Since `attr_accessor` generates both getter and setter at once, we cannot use different method access control qualifiers for the setter and the getter.

11m48s

20.

```ruby
# What is the difference between states and behaviors?
```

Classes group behaviors and objects encapsulate state.

An object encapsulates state in that the state of each object is distinct from all other objects, even those of the same class. The set of instance variables that track the state of an object are distinct and particular to that object.

Classes group behaviors in that the instance methods defined in a class (and inherited by that class) are available to all objects of the class.

Thus behaviors are shared whereas states are distinct to each object.

As an example,

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
cat2 = Cat.new("Snowball")

cat1.speak # "Fluffy says meow!"
cat2.speak # "Snowball says meow!"
```

We define a `Cat` class on lines 1-9. The `initialize` constructor takes one parameter `name` and uses it to initialize instance variable `@name`. The `Cat#speak` instance method is defined on lines 6-8. The definition body interpolates the value of the calling object's `@name` variable into a string and passes it to the `Kernel#puts` method to be output.

We initialize local variable `cat1` to a new `Cat` object, passing string `"Fluffy"` through to the constructor to be assigned to `@name` in `cat1`.

We initialize local variable `cat2` to a new `Cat` object, passing string `"Snowball"` through to the constructor to be assigned to `@name` in `cat2`.

When we call `speak` on each of these objects on lines 14-15, we can see that although these objects call the same `speak` method shared by all `Cat` objects, the data interpolated tracked by each `@name` variable is distinct, because each `Cat` object has its own unique state.

8m17s

21.

```ruby
# What is the difference between instance methods and class methods?
```

Instance methods are available to be called on all instances (objects) of the class. Class methods are available to be called only on the class itself.

Since objects encapsulate state, instance methods may well be concerned with the state of the calling object. Class methods are often stateless methods, or if they are concerned with the state tracked by class variables then this is concerned with data related to the class as a whole rather than any particular object of the class.

We define an instance method within the class using the `def...end` keywords. We define a class method within the class using `def...end` but prefixing `self.` to the name of the method.

As an example,

```ruby
class Cat
  @@number_of_cats = 0

  def initialize(name)
    @name = name
    @@number_of_cats += 1
  end
 
  def self.number_of_cats
    @@number_of_cats
  end
  
  def speak
    puts "#@name says meow!"
  end
end

cat = Cat.new("Fluffy")
cat.speak # Fluffy says meow!
puts Cat.number_of_cats # 1
```

Here, we define a `Cat` class on lines 1-11. We define a class method on lines 9-11, ` Cat::number_of_cats`, using the `self` keyword and the dot operator before the name. We define an instance method `Cat#speak` on lines 16-15.

When we call the instance method on line 19, we call it on an instance of the class and the method is concerned with the state of that particular object.

When we call the class method on line 20, we call it on the `Cat` class itself, and it is not concerned with the state of any particular object of the class.

8m09s

22.

```ruby
# What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.
```

A collaborator object is any object that becomes part of an object's state in order to help the object fulfill its responsibilities. A collaborator object can be of any class, whether built-in or custom.

Collaborator objects make up the state of an object, thus they further encapsulate state. They also expose methods which the object can call at any time, since the collaborators are already part of its state and so its 1instance methods have ready access to them. In this way, collaborations represent the connections between actors (objects) in our program.

Collaborator objects may be directly tracked by an object's instance variables or even contained in an intermediate collection object like an array.

Collaborations are relationships that exist from the design stage onward, and are vital to consider since they represent the connections between actors in our program. Modeling these relationships is an integral part of OO design, helping us break down the overall problem into a network of interconnected entities from the problem domain, helping us analyze and solve complex problems. 

As an example of working with collaborator objects:

```ruby
class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Owner
  def initialize(name, pet)
    @name = name
    @pet = pet
  end
  
  def show_info
    puts "#@name's pet is #{@pet.name}."
  end
end

fluffy = Cat.new("Fluffy")
mike = Owner.new("Mike", fluffy)

mike.show_info # "Mike's pet is Fluffy."
```

Here, the `fluffy` `Cat` object, instantiated on line 19, becomes part of the state of the `Owner` object `mike` when we instantiate `mike` on line 20. Thus `fluffy` is a collaborator of `mike`, and from a design perspective, the `Cat` class is a collaborator class of the `Owner` class.

When we call the `Owner#show_info` method on line 23, the `fluffy` object is helping the `mike` object fulfill its responsibilities. The `Cat#name` method is called on `fluffy` by the `Owner#show_info` method, which it can access because `fluffy` is tracked by the `@pet` instance variable.

18m40s



22.

```ruby
# What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one.
```

The collaborators objects of an object are the objects that become part of its state. Any class of object can be a collaborator object.

The relationship between an object and its collaborators is a 'has-a' relationship and a relationship of association. Collaboration exists from the design phase onward as an association between classes. It is important to think about the collaborations between a class and other classes because these relationships model the network of communication between actors in our program.

The purpose of using collaborator objects is to modularize our programs into a network of interconnected pieces, helping us break down the overall problem into discrete subproblems that are related through the collaborations between objects. In this sense, thinking in terms of the collaborations between objects is an intrinsic part of OO design.

As an example,

```ruby
class Car
  def initialize
    @engine = Engine.new
  end
  
  def start
    @engine.start
  end
end

class Engine
  def start
   puts "Starting engine..."
  end
end

car = Car.new
car.start # "Starting engine..."
```

Here, we design a `Car` class on lines 1-8. As soon as a `Car` object is instantiated as on line 17, the constructor (lines 2-4) instantiates a new `Engine` object which is tracked by the instance variable `@engine`. This `Engine` object is now part of the `Car`'s state and thus a collaborator object. The `Engine` class is clearly a collaborator of the `Car` class and helps `Car` objects fulfill their responsibilities. This is demonstrated when we call the `Car#start` method on our `Car` object on line 18, which in turn calls `Engine#start` on its `Engine` collaborator in order to carry out the work of the method.

10m51s

If an OO program is the interaction of small, discrete parts, then collaboration models the connections that facilitate this interaction. In this sense, using collaborator objects, thinking in terms of collaborations from the class design phase onward, is an intrinsic part of OOP and OO design.



23.

```ruby
# How and why would we implement a fake operator in a custom class? Give an example.
```

Many operators in Ruby are actually methods, and can be defined like other methods.

These fake operators can be defined in a class like any other method. When defining an operator, it is vitally important to respect the conventional meanings of the operators as established by Ruby's core classes and standard library. For instance, the `==` method should compare a principal object value in the caller with that in an argument object, returning `true` if they are considered equivalent values, `false` otherwise. If the method did something else, this would make our code confusing.

Indeed, one of the benefits of defining fake operators for our custom classes is that it can make our code easier and faster to read and comprehend. If we follow the conventional meanings of these operators, many of which conventionally mean the same thing across programming languages and in mathematics etc, then our classes become easier to use.

We can define and override fake operators similarly to other methods.

As an example,

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
house2 = House.new("83 Sycamore Lane")
house3 = House.new("23 Elm Drive")

puts house1 == house2 # false
puts house1 == house3 # true
```

Here, we have defined the `==` method for our `House` class. This method (lines 8-10), will return `true` if the `address` attribute of one `House` is equivalent to the `address` of another `House` object. This is achieved through the use of `String#==` to make the comparison (line 9).

7m46s

24.

```ruby
# What are the use cases for `self` in Ruby, and how does `self` change based on the scope it is used in? Provide examples.
```

There are two extremely common use-cases for the keyword `self` in Ruby.

When we use `self` within the class but outside of an instance method definition, then `self` references the class itself. Thus `self` can be used to define class methods.

For instance,

```ruby
class Temperature
  def self.celsius_to_fahrenheit(celsius)
    celsius * 9 / 5.0 + 32
  end
end

p Temperature.celsius_to_fahrenheit(100) # 212.0
```

Here, we prepend `self` and the dot operator to the name of the method defined on line 2 in order to signify that this is a class method, `Temperature::celsius_to_fahrenheit`. This is equivalent to defining the method as `Temperature.celsius_to_fahrenheit`.

The other extremely common use of `self` is within instance method definitions, where `self` references the calling object. Normally when we call an instance method of the class from another instance method definition, we can simply state the name of the method we are invoking, without using the dot operator on a particular object, and this will invoke the method on the calling object. With setter methods whose names end in `=`, this is not the case. The syntax for calling such setter methods is impossible to disambiguate from the initialization of a new local variable. Here, we must explicitly call the setter method on `self`, referencing the calling object:

```ruby
class Cat
  def initialize(n)
    self.name = n
  end
  
  def name=(n)
    @name = n
  end
  
  def name
    @name
  end
end

cat = Cat.new("Fluffy")
puts cat.name # "Fluffy"
```

On line 3 of the `initialize` method definition of the `Cat` class, it is necessary to call `name=` explicitly on `self`, referencing the calling object.

7m54



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

The `Person` class is defined on lines 1-9. The `Person#initialize` constructor is defined with one parameter `n` which it uses to initialize instance variable `@name` in the calling object. The `Person#get_name` method acts as a getter method for `@name`.

On line 11, we initialize local variable `bob` to a new `Person` object, passing string `"bob"` through to the constructor to be assigned to the `@name` variable of the `bob` object.

On line 12, we initialize local variable `joe` to a new `Person` object, passing string `"joe"` through to the constructor to be assigned to the `@name` variable of the `joe` object.

On line 14, we call `inspect` on `bob` and pass the return value to `Kernel#puts` to be output. We do the same on line 15 with `joe`. We can see from the output that `bob` and `joe` have their own distinct `@name` variable that tracks a different object.

On line 17, we call `get_name` on `bob` and pass the return value to `Kernel#p`, this outputs `"bob"` as we would expect.

This code demonstrates that instance variables are scoped at the object level. The `initialize` constructor is called for each new `Person` object. In this sense, all objects of the class share the instance methods defined in the class. However, the state of each object is distinct, as are the instance variables. `initialize` initializes the `@name` variable in the calling object of any given call, and this instance variable is unique to that object, even though other objects of the class have their own, distinct `@name` instance variables.

6m25s

26.

```ruby
# How do class inheritance and mixing in modules affect instance variable scope? Give an example.
```

Inheritance, whether class inheritance or inheritance from mixin modules, does not affect the scope of instance variables, which are scoped at the object level, regardless of where the instance method that initializes them is defined. Any given instance variable of an object is accessible from any of its instance methods, regardless of which instance method initialized the variable, and regardless of where any available instance method is defined.

As an example,

```ruby
module Nameable
  def name=(n)
    @name = n
  end
end

class Person
  include Nameable
  
  def name
    @name
  end
end

bill = Person.new
p bill # <Person:0x...>
bill.name = "Bill"
p bill # <Person:0x... @name="Bill">
p bill.name
```

We define a `Nameable` module on lines 1-5 that provides one instance method, a setter method `name=` for an instance variable `@name`. We define a `Person` class on lines 7-13 that mixes in `Nameable`.

We initialize local variable `bill` to a new `Person` object on line 15. On line 16, we pass `bill` to `Kernel#p` to output a detailed string representation of the object. It is clear from this that `bill` has no instance variables initialized.

On line 17, we call the method `name=`, inherited from `Nameable`, on `bill`, passing the string `"Bill"` as argument. When we again pass `bill` to `p`, it is clear from the output `bill` now has a `@name` instance variable that references `"Bill"`.

The method `name=` is inherited from the `Nameable` module, but the instance variable it initializes is specific to the `bill` object. Like any other instance variable it is accessible from every instance method of the `bill` object, regardless of where these methods are defined. So when, on line 19, we call `Person#name` on `bill` and pass the return value to `p`, it is clear from the output that an instance method defined in `Person` can access the instance variable initialized in `bill` by a method inherited from `Nameable`. This is because the variable itself is scoped at the object level.

9m24s



26.

```
# How do class inheritance and mixing in modules affect instance variable scope? Give an example.
```

Instance variables are scoped at the object level. Inheritance, whether from class inheritance or from mixin modules, does not change this.

Objects encapsulate state. Every object has a distinct set of instance variables that track the distinct state of that unique object. Any given instance variable of an object is accessible to all of an object's instance methods, regardless of which instance method initialized the variable.

An instance variable does not come into being in an object until it is initialized by an instance method being called on the object. This means that instance variables are not directly inherited. Instance methods can be inherited, and those instance methods may initialize instance variables in an object, though only once they have been called on the object.

Once initialized, an instance method is accessible from any of the instance methods in the method lookup path for the object, regardless of which class or module they are defined in.

For instance,

```ruby
module Nameable
  def name=(name)
    @name = name
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

fluffy.name = "Fluffy"
p fluffy.name # "Fluffy"
```

We instantiate an object of the `Cat` class, `fluffy`. The `@name` instance variable only comes into being in `fluffy` once it is initialized by `name=`, a method inherited from the `Nameable` module. However, once initialized, it is accessible from `name`, an instance method defined in the `Cat` class itself.

Inheritance does not affect instance variable scope, instance variables are not inherited, and instance variables remain scoped at the object level.

13m37s



26.

```ruby
# How do class inheritance and mixing in modules affect instance variable scope? Give an example.
```

Instance variables are scoped at the object level. Inheritance, whether class inheritance or from mixin modules, does not change this.

Objects encapsulate state, meaning every object has its own distinct state different to all other objects. An object's state is tracked by its instance variables. An object's set of instance variables is unique to that object. Instance variables are initialized by instance methods. Once initialized in an object, an instance variable is accessible to any of the instance methods available on an object, regardless of which method initialized the variable, and regardless of where in the method lookup path for the object the instance methods are defined.

Since an instance variable only comes into being in an object once the instance method that initializes it is called on the object, instance variables are not inherited. Instance methods themselves are. However, whether an instance variable is initialized by an inherited method or by one defined in the class of the object does not affect the scope of the variable, which is still scoped at the object level.

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

fluffy.name = "Fluffy"
p fluffy.name # "Fluffy"
```

Here we define a `Nameable` module on lines 1-5, which provides a `name=` instance method to set a `@name` instance variable.

We define the `Cat` class on lines 7-13, which mixes in `Nameable`. `Cat#name` is a defined as an instance method that returns the reference of a `@name` instance variable.

We initialize local variable `fluffy` to a new `Cat` object on line 15. When we call `name` on `fluffy` and pass the return value to `Kernel#p` to be output, the `nil` shows that the instance variable `@name` has not been intialized.

We then call `name=` on `fluffy` to set the variable to `"Fluffy"`. Calling `name` on `fluffy` demonstrates that although we initialized the instance variable with an inherited method, an instance method defined in the class itself can still access it.

In short, inheritance does not affect instance variable scope, instance variables are not inherited, and instance variables remain scoped at the object level.

8m38s

27.

```ruby
# How does encapsulation relate to the public interface of a class?
```

Encapsulation is hiding pieces of functionality, and containing state, behind a public interface. The notion of a public interface is thus integral to the notion of encapsulation.

Objects encapsulate state. The state of an object is distinct from any other object and is tracked by the particular instance variables of that object. In Ruby, we can only access an object's instance variables from outside the object, if at all, indirectly via its public interface -- the `public` instance methods of the class.

For instance,

```ruby
class Person
  def initialize(name)
    @name = name
  end
end

bill = Person.new("Bill")
puts bill.name # raises NoMethodError
```

Here, we cannot access the `@name` instance variable initialized in a `Person` object by its constructor because there is no public method defined which can permit this.

The public interface of a class is made up of its `public` methods (or more specifically, the calling signatures of these methods). It determines how other objects can interact with objects of the class. The separation of the implementation of the class from its public interface, which is a primary motivation for encapsulation, means that we are free to change the implementation of the class so long as the public interface remains consistent without worrying about breaking existing code. This reduces code dependencies, since client code can only become dependent on the public interface of a class, and makes code more maintainable. It also simplifies use of the class, since the simplified public interface is all users need to know.

9m55s





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

The first code example ends with passing a `GoodDog` object to `Kernel#puts`. `puts` implicitly calls `to_s` on its arguments. Custom classes inherit from the `Object` class by default, and so they inherit `Object#to_s`. Since we have not overridden this method in the `GoodDog` class, this is the implementation that is called. The string returned takes the form `<ClassName:0x...>`, where `ClassName` is the name of the class and `0x...` is an encoding of the object id of the calling object.

We could output a message of our choice by overriding the `to_s` method in the `GoodDog` class:

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
  
  def to_s
    "Hello from GoodDog"
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky # "Hello from GoodDog"
```

The reason the second piece of code has a different output to the first is that the second piece of code ends by passing the `GoodDog` object to `Kernel#p`. `p` implicitly calls `inspect` on its arguments rather than `to_s`. This is inherited from `Object`. The `Object#inspect` method returns a string similar to `Object#to_s` but with the addition of a list of all the object's instance variables and their current values. Unlike `to_s`, `inspect` is less commonly overridden, since the detailed string representation of the calling object it returns is useful in debugging.

6m23s

29.

```ruby
# When does accidental method overriding occur, and why? Give an example.
```

Accidental method overriding occurs whenever we override an inherited method without meaning to because of a name clash.

We override a method inherited from an ancestor class simply by defining a method with that name in the descendant class. While it is generally easy to keep track of which methods we are inheriting from ancestor classes we have defined ourselves, it is harder to keep track of which methods we are inheriting from built-in classes.

All custom classes inherit from the `Object` class by default, and it is the methods inherited from `Object` that are most likely to be accidentally overridden.

For instance, if we defined a `Message` class, it might be natural to name a method `Message#send`. However, this would override the method `Object#send`, which implements a key piece of Ruby functionality, allowing us to call methods on an object by passing the name of the method as an argument to `send`.

```ruby
class Message
  def initialize(text)
    @text = text
  end
  
  def send
    # code to send message over network
  end
  
  def show
    puts @text
  end
end

message = Message.new("hello world")
message.send(:show) # raises ArgumentError
```

Here, we have accidentally overridden the inherited `Object#send` method with our own `Message#send` (lines 6-8). When we attempt to call the `Message#show` method via `Object#send`, on line 16, we raise an `ArgumentError`, since unlike `Object#send`, `Message#send` takes no arguments.

This means it is important to be familiar with the methods defined in `Object` in order not to accidentally override them.

8m14s

30.

```ruby
# How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers.
```

Most OO languages provide some form of access control. Since in Ruby, instance methods are not accessible from outside the object except indirectly through the public interface, it is common to speak of method access control.

In Ruby, methods can be `public`, in which case they form part of the interface of the class, or they can be `private` or `protected`, in which case they are part of the implementation.

`public`, `private`, and `protected` are access control modifier methods, defined in the `Module` class. Methods defined in a class are `public` by default. In order to make methods `private`, we simply call the `private` method, and any methods defined thereafter are `private` methods, at least until another access modifier method is called.

`public` methods form the public interface of a class and can be called from anywhere in the program. `private` methods can only be called from within the class. `protected` methods are similar to `private` methods but can also be called from outside the object but within the class. This means we can pass an object of the same class into the public instance method of one object, and that method can call a `protected` method on the other object, the argument.

An example of using a `protected` method might be:

```ruby
class Person
  def initialize(height_in_cm)
    @height = height_in_cm
  end
  
  def >(other)
    height > other.height
  end

  protected
  
  attr_reader :height
end

person1 = Person.new(175)
person2 = Person.new(185)

puts person2 > person2 # true
person1.height # NoMethodError: protected method called from outside the class
```

Here, we need the `Person#>` method, defined on lines 6-8, to be `public` since it forms part of the class's interface. Since methods are `public` by default, we do not need to use an access modifier. We do not wish to have the method `Person#height` accessible outside the object, but `Person#>` needs to be able to call `height` on the other `Person` object passed as argument to perform a comparison. This means that a `protected` access level for `height` makes sense, so we call `Module#protected` on line 10 and then generate the `height` method with a call to `attr_reader` on line 12.

An example of using a `private` method:

```ruby
class Account
  def initialize(username, password)
    @username = username
    @password = password
  end
  
  def correct_password?(attempt)
    attempt == password
  end
  
  private
  
  attr_reader :password
end

account = Account.new("dave", "1234abc")
puts account.correct_password?("1234abc") # true
account.password # NoMethodError: private method called from outside the object
```

Here, we decide that `Account#password` should not be accessible from outside the object. This means we only want `password` to be callable from the other instance methods of the class, and only want it to be available on the calling object. Thus we call the `private` method on line 11 and then generate the `password` getter method on line 13.

17m56s

31.

```ruby
# Describe the distinction between modules and classes.
```

The most important distinction between classes and modules is that classes can be instantiated as objects and modules cannot.

For instance,

```ruby
class Cat
end

module Catlike
end

Cat.new # fine
Catlike.new # NoMethodError
```

Classes are thus blueprints for objects, and predetermine the behaviors available to an object, instance methods, and the potential instance variables that can be initialized by those methods.

Modules have a number of uses. They can be mixed in to classes to provide instance methods. They can act as namespaces for related classes. They can act as containers for methods that do not pertain to any particular class.

Another significant difference is that classes can inherit via class inheritance or via mixin modules, while modules can only inherit by mixing in other modules.

4m18s

32.

```ruby
# What is polymorphism and how can we implement polymorphism in Ruby? Provide examples.
```

Polymorphism is the ability for different data types to respond to a common interface, often but not always in different ways. This means that a piece of client code that calls a `move` method on objects passed to it does not need to care about the type or class of the object so long as it exposes a compatible `move` method. The implementation called will be the right implementation for the class of the object without the client code needing to determine the type. 

In Ruby, there are three main ways to implement polymorphism: through class inheritance, through mixin modules (sometimes called interface inheritance), and through duck-typing.

Since subclasses inherit methods from their superclass, this means that class inheritance can be used to implement polymorphism. If we define a method in a superclass, subclass objects can have access to that method as well, and the subclass can override the general, superclass implementation with a more specific implementation of their own.

For instance,

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

Here, the `Vehicle` class defines a `start` instance method. We define a `Car` class and a `Boat` class as subclasses of `Vehicle`. `Car` has access to the implementation of `start` inherited from the superclass. `Boat` overrides `start` with an implementation of its own. 

We can see polymorphism in action on line 16, where an array containing a `Vehicle` object, a `Car` object, and a `Boat` object has `Array#each` called on it. `each` passes each object in turn to the block to be assigned to the parameter `vehicle`. The block calls `start` on every object in turn without checking the type or class of the object. This works because objects of all three types expose a `start` method, and the right implementation for `start` is called without the client code needing to know which implementation is appropriate to the class of the object. This polymorphism through class inheritance: every subclass of `Vehicle` has access to a `start` method that it inherits from the superclass. If we need the object to respond differently to this common interface, we can override the method implementation.

Another way to implement polymorphism is through mixin modules. We can define instance methods in a mixin module and then 'mix in' that module to multiple classes to provide a common interface to objects of different types.

For instance,

```ruby
module Climbable
  def climb
    puts "I'm climbing!"
  end
end

class Mountaineer
  include Climbable
end

class MountainGoat
  include Climbable
end

climbers = [Mountaineer.new, MountainGoat.new]
climbers.each { |climber| climber.climb }
# output:
# I'm climbing!
# I'm climbing!
```

Polymorphism is achieved here by mixing in the `Climbable` module to two different classes, `Mountaineer` and `MountainGoat`. Now objects of these two different types can respond to the common interface of the `climb` method provided by the module.

Duck-typing is the ability of objects of completely unrelated classes to respond to a common interface. So long as an object exposes a method with the right name and number of required arguments for a task at hand, the client code performing the task does not have to care about the type or class of object. If an object quacks like a duck, it can be treated like a duck, which is to say that as long as it has a compatible subset of its interface for a given task, it can be treated as belonging to the correct category of object.

Unlike with class or mixin module inheritance, we do not need to relate classes to each other or to modules. We simply have to define a method with the same name and number of arguments in multiple classes.

```ruby
class Duck
  def fly
    puts "The duck flies..."
  end
end

class Swan
  def fly
    puts "The swan flies..."
  end
end

flyers = [Duck.new, Swan.new]
flyers.each { |flyer| flyer.fly }
# output:
# The duck flies...
# The swan flies...
```

23m28s

33.

```ruby
# What is encapsulation, and why is it important in Ruby? Give an example.
```

LS have added as section to the 'Encapsulation' section at the beginning of the OOP book. Now it says:

"**Encapsulation** is one of the fundamental concepts of object-oriented programming. At its core, encapsulation describes the idea of bundling or combining the data and the operations that work on that data into a single entity, e.g., an object."

"... the data and operations that you perform on your data are related"

"If our program keeps track of data bout entities and performs operations on that data, it makes sense to combine the data and the functionality into a single entity. That's what object-oriented programming is all about. We call this principle of combining data and the operations relevant to that data encapsulation. Encapsulation is about bundling state (data) and behavior (operations) to form an object."

"In most OOP languages, encapsulation has a broader purpose. It also refers to restricting access to the state and certain behaviors; an object only exposes the data and behaviors that other parts of the application need to work. In other words, objects expose a **public interface** for interacting with other objects and keep their implementation details hidden. Thus, other objects can't change the data of an object without going through the proper interface."



Encapsulation is a fundamental aspect of OOP. Encapsulation means bundling data with the operations that work on the data into a single entity: an object. This means that operations can only be performed on the relevant data, and data is prevented from having invalid operations (relating to some other type of data) performed on it. In this way, encapsulation is about packaging state and behavior to form an object.

Encapsulation means sectioning off functionality from the rest of the codebase behind a consistent public interface. In Ruby, encapsulation is achieved by defining classes and instantiating objects. Client code can only interact with objects via their public interface: the public instance methods determined by the class of the object.

Objects encapsulate state, which is tracked by their instance variables. An object's set of instance variables is distinct to that object, and the state they track is separate from all other objects' state. In Ruby, the instance variables of an object are only accessible from outside the object, if at all, via deliberately exposed public methods. Encapsulation thus serves as a form of data protection, preventing accidental or invalidating modification of an object's state by restricting access to it behind the public interface, limiting the ways in which an object's state can be changed.

Method access control gives us fine-grained control over which methods comprise the public interface, and which remain internal implementation details that cannot be called from outside the class. The `public` methods of a class form the public interface, while `private` and `protected` methods can only be called within the class. `private` methods can only be called by other instance methods on the calling object. `protected` methods can only be called by other instance methods of the class on objects of the class, usually on other objects of the class that have been passed as argument to a `public` method.

Since client code can only become dependent on the public interface of a class, we are free to change or add to a class and we will not break existing code so long as the interface remains consistent. This reduction in code dependencies greatly improves the maintainability of our programs.

The public interface simplifies use of the class, allowing us to think at a greater level of abstraction, the level of the problem domain itself, rather than at the level of implementation details. This helps us solve more complex problems.

As an example,

```ruby
class Cat
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def change_name(new_name)
    self.name = new_name
  end
  
  def speak
    puts "#{name} says meow!"
  end
  
  private
  
  attr_writer :name
end

cat = Cat.new("Fluffy")
cat.change_name("Tom")
cat.speak # "Tom says meow!"
```

Here, we create a `Cat` class, whose public interface consists of the `Cat#name` method, the `Cat#change_name` method, and the `Cat#speak` method. We also need to pass a `name` through to the constructor when we instantiate a `Cat` object. We do not need to know how the `name` is stored, and we can only access the `@name` instance variable indirectly through the public interface. We do not need to know such a variable exists in order to use the class.

In order to change the `name` of the `Cat` object, we must go through the `Cat#change_name` method. This method calls the `private` setter method `Cat#name=`, but we cannot call this `private` method from outside the object; it remains an implementation detail rather than part of the interface. We could change the body of any of these methods, and remove the `Cat#name=` method altogether, and so long as the interface remains constant and the behavior remains consistent, we will not break existing code.

Similarly, when we ask a `Cat` object to `speak`, it outputs a message from our `Cat` using the state of the individual object, but we do not need to know how this is achieved.



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

On lines 1-5, we define a `Walkable` module. On lines 7-21, we defined a `Person` class. On lines 23-37 we define a `Cat` class. Both `Person` and `Cat` mix in the `Walkable` module.

On line 39, we initialize local variable `mike` to a new `Person` object. We call the `walk` method, inherited from `Walkable`, on `mike` and pass the return value to `Kernel#p`  to be output: `"Mike strolls forward"`.

On line 42, we initialize local variable `kitty` to a new `Cat` object. On line 43, we call `walk`, inherited from the `Walkable` module, on `kitty` and pass the return value to `p` to be output: `"Kitty saunters forward"`.

The `walk` method, defined on lines 2-4, returns a string into which it interpolates the return values of `name` and `gait` methods: `"#{name} #{gait} forward"`. When called on a `Person` object, these will be `Person#name` and `Person#gait`. When called on a `Cat` object, `Cat#name` and `Cat#gait`. Since both classes implement the methods the `walk` method expects, this method works seamlessly for both `mike` and `kitty`. `Cat#gait` returns the string `"saunters"` and `Person#gait` returns `"strolls"`. The `name` attribute of both classes is set by the constructor, using a `@name` instance variable.

This is why this code produces the output it does.

The reason it makes sense to use a mixin module, `Walkable`, rather than class inheritance has to do with the entities our classes are modeling. There is no logical superclass of which a `Person` and a `Cat` could be subclasses of. That is to say, there is no mutual `is-a` relationship whereby a `Person` and a `Cat` are a specialized type of a more general type of entity.

Rather, a `Person` 'has-an' ability to `walk`, as does a `Cat`, so a mixin module models this more clearly and logically.

10m29s







35.

```ruby
# What is Object Oriented Programming, and why was it created? What are the benefits of OOP, and examples of problems it solves?
```

Object Oriented Programming is a programming paradigm developed to solve the problems of large, complex software projects. OOP aims to make code more maintainable, to permit code reuse in a greater variety of contexts, and to allow the programmer to think at a higher level of abstraction and so to solve more complex problems in terms of the problem domain itself.

Before OOP, as programs grew in size and complexity there was a tendency for a program to become a mass of dependency, where every part of the codebase was dependent on every other part. This made it hard to change code or add features without a ripple of adverse effects throughout the program.

OOP offers ways to modularize programs, to create containers for data that can be changed without affecting every other part of the program, ways to section off code and data behind consistent interfaces, so that programs become the interaction of small, discrete actors, rather than a single mass of dependency.

By abstracting away implementation details behind interfaces, OOP allows us to think in terms of the problem domain. OOP objects can represent real-world objects or problem-domain entities, allowing the programmer to think at a higher level of abstraction. This facilitates solving more complex problems.

OO languages provide facilities for encapsulation, polymorphism, and inheritance, in order to achieve these ends.

6m08s

36.

```ruby
# What is the relationship between classes and objects in Ruby?
```

In Ruby, classes serve as templates or blueprints for objects.

Objects encapsulate state, while classes group behaviors. The state of an object is unique to that object, and is tracked by the instance variables of that object. An object's instance variables are particular to that object, distinct from the instance variables of all other objects including objects of the same class.

Classes group behaviors, shared by all objects of the class. Specifically, the instance methods predetermined by the class are available on all objects of the class.

An instance variable is only initialized in an object when the instance method that initializes it is called on the object. Although an instance method is shared by all objects of the class that defines it, the instance variable it initializes will be scoped at the level of the calling object and is unique to that object.

As an example,

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
tom = Cat.new("Tom")

puts fluffy.name # "Fluffy"
puts tom.name # "Tom"
```

Here, we can see that the `Cat` class groups behaviors for `Cat` objects. As lines 14-15 make clear, however, each `Cat` object has its own state, reflected in the different return values for `Cat#name` instance method.

A class determines what instance methods are available to be called on objects of the class. Those instance methods determine the set of potential instance variables that can be initialized in an object. However, any given instance variables is only initialized if the instance method that initializes it is actually called on a particular object.

So a class defines what an object can do and what it is made of. The second part is ambiguous though. A class predetermines a potential set of instance variables that an object may have. Any given instance variable is only initialized in a given object if the instance method that initializes it is actually called on that object.

This is covered in the Objects and Classes material in the book, and in the exercises/"lecture" in Lesson 2. It's not that deep.



A class functions as a blueprint or template for objects.

An object's class predetermines the attributes and behaviors of an object (sort of depends what we mean by 'attributes')

An object's class predetermines the behaviors and attributes of an object. 

An 'attribute' is not exactly synonymous with an instance variable here, since any given instance variable is only initialized in an object if the instance method that initializes an instance variable of that name is actually called on the object.

Does this matter in terms of the 'relationship' between classes and objects?

"Ruby defines the attributes and behaviors of its objects in **classes**. You can think of classes as basic outlines of what an object should be made of and what it should be able to do."

"So when we say that classes define the attributes of its objects, we're referring to how classes specify the names of instance variables each object should have (i.e., what the object should be made of ). The classes also define the accessor methods (and level of method access control); however, we're generally just pointing to the instance variables. Similarly, when we say state tracks attributes for individual objects, our purpose is to say that an object's state is composed of instance variables and their values; here, we're not referring to the getters and setters."



36.

```ruby
# What is the relationship between classes and objects in Ruby?
```

Classes serve as blueprints or templates for objects. A class predetermines what attributes and behaviors an object should have: what an object should be made of and what it should be able to do.

Classes group behaviors, instance methods, that are available to be called on all objects of the class.

The attributes of an object, its potential instance variables, are predetermined by the class. Any given instance variable only comes into being in an object when an instance method that initializes it is actually called on the object. The instance methods available to an object, and thus the set of potential instance variables, are predetermined by the class.

Objects encapsulate state, tracked by their instance variables. The state of an object, and its set of actual instance variables, is distinct and particular to that object, and not shared by any other object, even objects of the same class.

Creating an object from a class is called instantiation, and for custom classes this is usually done by calling the class method `new` on the class. This in turn calls the `initialize` constructor, a private instance method, which receives all the arguments passed to `new`.

For example,

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
tom = Cat.new("Tom")

puts fluffy.name # "Fluffy"
puts tom.name # "Tom"
```

Here, we define a `Cat` class (lines 1-9) which defines what behaviors objects of the class should have (the instance methods `Cat#initialize` and `Cat#name`) and what attributes they should have (the name tracked by the `@name` instance variable initialized by the constructor). The two `Cat` objects instantiated on lines 11-12 have access to the same methods, but each has its own `@name` instance variable. As we can see from the output on lines 14-15, each object's instance variable tracks a different string.



13m38s



36.

```ruby
# What is the relationship between classes and objects in Ruby?
```

In Ruby, classes serve as templates or blueprints for objects. The class predetermines the attributes and behaviors of its objects: what the objects should be made of and what they should be able to do.

Classes group behaviors, the instance methods that are available to its objects. These behaviors are shared by all objects of the class.

Classes predetermine attributes for objects of the class, specifically the set of potential instance variables that can be initialized in objects of the class. Any given instance variable is only initialized in an object when the instance method that initializes it is actually called on that object, and a class predetermines what instance methods are available to an object.

Objects encapsulate state, tracked by their instance variables. An object's state, the set of actual instance variables initialized in the object, is unique to that object, distinct from the state of every other object, including objects of the same class.

Creating an object from a class is called 'instantiation'; objects are instances of the class that encapsulate their own distinct state. For custom classes, we usually instantiate an object by calling the class method `new`. This method in turn calls the private instance method `initialize`, the constructor, passing all arguments through to `initialize`.

For example,

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
tom = Cat.new("Tom")

puts fluffy.name # "Fluffy"
puts tom.name # "Tom"
```

Here we define a `Cat` class that determines what behavior is available to objects of the `Cat` class (i.e. the instance methods `Cat#initialize` and `Cat#name`). The `name` attribute is tracked by a `@name` instance variable initialized by the constructor when a new `Cat` is instantiated.

We instantiate two new `Cat` objects on lines 11-12. As we can see from the return value of the `name` method called on both objects on lines 14-15, each `Cat` has its own distinct `@name` instance variable tracking its own distinct state. 





37.

```ruby
# When should we use class inheritance vs. interface inheritance?
```

Class inheritance is useful for modeling entities in the problem domain with a naturally hierarchical relationship. A subclass is a specialized type with respect to the superclass, so the relationship expressed is an 'is-a' relationship. So when the entities are related in this way, it makes sense to use class inheritance.

For instance,

```ruby
class Animal
end

class Mammal < Animal
end

class Cat < Mammal
end
```

Since a `Cat` is a type of `Mammal`, which is a type of `Animal`, it makes sense to model these entities as a class hierarchy using traditional class inheritance.

Inheritance of behaviors via mixin modules is sometimes called 'interface inheritance'. Interface inheritance is useful for modeling an ability that is common to entities that do not necessarily have any other relationship to each other. The class that mixes in a module is not a specialized type with respect to the module. Rather, the class 'has an' ability provided by the module.

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

Mountaineer.new.climb # "I'm climbing"
Cat.new.climb # "I'm climbing"
```

Since a `Cat` and a `Mountaineer` have no logical superclass, it makes sense to extract their common ability to `climb` to a `Climbable` module instead.

Since Ruby is a single-inheritance language, interface inheritance can also be used to give behaviors to classes within a class hierarchy when there is no superclass to extract behaviors to that does not provide them to a subclass that should not have them.

9m52s 



* Class inheritance in Ruby is limited to single inheritance; a class can only subclass from one immediate superclass. On the other hand, a class can mix in as many modules as necessary. Thus interface inheritance can be used to extract common behaviors in a similar way to multiple inheritance
* If there is an 'is-a' relationship between two entities, class inheritance models this best
* If the relationship is purely a 'has a' relationship, i.e., multiple classes 'have a' behavior, we can extract that behavior to a module

38.

```ruby
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new


# If we use `==` to compare the individual `Cat` objects in the code above, will the return value be `true`? Why or why not? What does this demonstrate about classes and objects in Ruby, as well as the `==` method?
```

We define a `Cat` class on lines 1-2. On lines 4-6, we instantiate three new `Cat` objects.

If we were to compare any of these new `Cat` objects with each other using the `==` method, the return value would be `false`.

The reason for this has to do with the default `==` method inherited by custom classes.

Although it has syntactic sugar that makes it appear as an operator, `==` is a method in Ruby, and like any method is can be defined for custom classes. The conventional meaning of the `==` method is that it should take an argument of the same class and return `true` if the caller and the argument objects have an equivalent principal object value (e.g., the integer value of an Integer object), `false` otherwise. 

A custom class that does not explicitly subclass another class will implicitly subclass the `Object` class. `Object` subclasses `BasicObject`. Since our `Cat` class does not override `==`, it inherits `BasicObject#==`. This implementation takes as the principal object value to compare for equivalence the object id of the caller and the argument. An object's object id is unique to that object, different to all other object ids. `BasicObject#==` thus compares the caller and argument to see if they are the same  object.

Since all three of our `Cat` objects are distinct objects, comparing any of them to any of the rest of them will return `false`.

This demonstrates that the default `==` method implementation effectively tests for object identity between caller and argument. It also demonstrates that `==` is not an operator but a method that can be inherited and overridden like any other.

8m43s

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

We define a `Thing` class on lines 1-2. Next, we define an `AnotherThing` class on lines 4-5 as a subclass of `Thing`. Finally, we define a `SomethingElse` class on lines 7-8 as a subclass of `AnotherThing`.

`Thing` is thus the immediate superclass of `AnotherThing`, and more loosely speaking, a superclass (or ancestor class) of `SomethingElse`. `AnotherThing` is a superclass of `SomethingElse`.

`Thing` implicitly subclasses `Object` which subclasses `BasicObject`. So implicitly, `BasicObject` and `Object` are (again, more loosely) superclasses, or ancestor classes, of all three of these custom classes.

3m23s

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

We initialize local variable `pingu` to a new `Penguin` object on line 24. On line 25, we call a `fly` method on `pingu`.

The lookup path Ruby uses to resolve this method call begins with the class of `pingu`, `Penguin`. Ruby searches this class and does not find a `fly` method. Ruby then searches the mixin modules mixed in to the class in the reverse order they have been mixed in via `Module#include`: `Migratory`, then `Aquatic`. Since there is no `fly` method in these, Ruby moves on to the superclass, `Bird`.

Ruby does not find a `fly` method defined in `Bird`, and so moves to the superclass `Animal`. There is no `fly` method here either.

A custom class that does not explicitly subclass another class will implicitly inherit from the `Object` class, so Ruby searches `Object` next. There is no `fly` method here, so Ruby searches the mixin module mixed in to `Object`, `Kernel`. Finally, Ruby searches `BasicObject`, and does not find the `fly` method here either, and so a `NoMethodError` exception is raised.

We can verify the lookup path that Ruby uses for the `pingu` object by calling the `ancestors` method on the class of `pingu`:

```ruby
pingu.class.ancestors # [Penguin, Migratory, Aquatic, Bird, Animal, Object, Kernel, BasicObject]
```

6m24s

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

We define an `Animal` class on lines 1-13. We define a `Cow` class on lines 15-19 as a subclass of `Animal`.

On line 21, we initialize local variable `daisy` to a new `Cow` object, passing the string `"Daisy"` to the constructor.

The `Cow` class inherits its `initialize` method from `Animal`. The `Animal#initialize` method is defined with one parameter `name` which it uses to initialize instance variable `@name`.

On line 22, we call the `speak` method on `daisy`. The `Cow` class inherits `Animal#speak` (defined on lines 6-7). This method calls the `sound` method and passes the return value to `Kernel#puts` to be output. Since we have called `speak` on a `Cow` object, `Cow#sound` is called.

`Cow#sound` is defined on lines 16-18. In the body, on line 17, the `super` keyword calls the method with the same name that is next in the inheritance chain, in this case `Animal#sound`. `Animal#sound` returns a string with the reference of `@name` interpolated into it: `"#{@name} says "`, which will be `"Daisy says "`. `Cow#sound` concatenates this return value to the string literal `"moooooooooooo!"` and returns this string to the `Animal#speak` method to be passed to `puts` for output.

Therefore this code outputs `Daisy says moooooooooooo!`

6m49s

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

On lines 1-14, we define a `Cat` class. On line 16, we initialize local variable `max` to a new `Cat` object, passing the strings `"Max"` and `"tabby"` through to the `Cat#initialize` constructor.

The `Cat#initialize` method is defined on lines 2-5 with two parameters `name` and `coloring`, which are used to initialize the instance variables `@name` and `@coloring` respectively.

Our `max` object thus has its `@name` instance variable set to `"Max"` and its `@coloring` variable set to `"tabby"`.

On line 17, we initialize local variable `molly` to a new `Cat` object with `"Molly"` and `"gray"` passed through to the constructor. The `molly` object thus has its `@name` instance variable set to `"Molly"` and its `@coloring` variable set to `"gray"`.

`max` and `molly` are both `Cat` objects and all the same `Cat` class behaviors, or instance methods, are available to both objects. Thus they have the same behaviors.

However, objects encapsulate state, and every object has its own unique state tracked by its own distinct set of instance variables. The `@name` instance variable in the `max` object is a different variable to the `@name` instance variable in the `molly` object and they track different String objects. Thus `molly` and `max` have different and distinct states.

5m55s





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

We define a `Student` class on lines 1-12. The `Student#initialize` constructor is defined with one parameter `name`, which is used to initialize instance variable `@name`. The body of the method definition also initializes instance variable `@grade` to `nil`. We generate getter and setter methods for these instance variables on line 2 with a call to `Module#attr_accessor`.

On line 14, we initialize local variable `priya` to a new `Student` object, passing the string `"Priya"` through to the constructor.

On line 15, we call the `Student#change_grade` method on `priya` with the string `"A"` passed as argument.

On line 16, calling the getter method `grade` on `priya` returns `nil`.

The reason the `change_grade` method has not done what it seems to be intended to do has to do with the syntax for invoking setter methods within the class.

The `Student#change_grade` method is defined on lines 9-11 with one parameter `new_grade`. The intent of line 10 seems to be to call the `grade=` setter method on the calling object, passing `new_grade` as argument.

Within an instance method definition, we can usually call any instance method available on objects of the class on the calling object implicitly by invoking the method without an explicit caller or the dot operator. However, the names of setter methods ending in `=` cannot be disambiguated from the initialization of a new local variable without an explicit caller. Thus line 10 initializes a new local variable `grade` rather than calling the setter method `grade=`.

In order to call a setter method on the calling object, we need to explicitly call the method on the keyword `self`, which within an instance method definition references the calling object, using the dot operator:

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
priya.grade 
```

This code now returns `"A"`.

10m04s

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

On lines 1-11, we define a `MeMyselfAndI` class.
On line 2, the keyword `self` references the class `MeMyselfAndI` since this line is within the class but outside any method definition.

On lines 4-6 we define the class method `MeMyselfAndI::me`. On line 4, we use the `self` keyword to reference the class on which we are defining the class method. Within the body of the class method definition, on line 5, `self` refers to the class on which the method is called, since we are within a class method definition. For the `MeMyselfAndI` class, both these uses of `self` reference `MeMyselfAndI`, but class methods can be inherited by subclasses.

On lines 8-10, we define the instance method `MeMyselfAndI`. Within the body of the instance method definition, on line 9, `self` references the calling object, the instance on which the instance method has been called.

6m13s

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

We define a `Student` class on lines 1-7. The `Student#initialize` constructor is defined with two parameters, `name` and `grade`. `grade` has a default value of `nil`. Within the body of the method definition, instance variable `@name` is initialized to `name`. However, nothing is done with parameter `grade`. We generate getter and setter methods for a `@grade` instance variable with a call to `Module#attr_accessor` on line 2. It is important to note that this call to `attr_accessor` does not actually initialize the `@grade` instance variable. We would need to actually call setter method `grade=` in order to initialize the `@grade` instance variable in a `Student` object.

On line 9 we initialize local variable `ade` to a new `Student` object with the string `"Adewale"` passed through to the constructor to be used to initialize the `@name` instance variable in the new object.

On line 10, we pass `ade` to the `Kernel#p` method which implicitly calls `Object#inspect` on the `Student` object to obtain a detailed string representation for output to screen. The output shows that there is no `@grade` instance variable initialized in `ade`. 

This is because in Ruby an instance variable is only initialized in an object when the instance method that initializes it is actually called on the object. The only `Student` instance method that can initialize the `@grade` variable is currently `Student#grade=` and we have not called it on `ade`.

To achieve the expected output, we could simply initialize `@grade` in the constructor to the `grade` parameter:

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
    @grade = grade
  end 
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

This now produces the expected output.

8m46s

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



On lines 1-11 we define a `Character` class. The `Character#initialze` constructor is defined with one parameter `name` which is used to initialize instance variable `@name`. We generate setter and getter methods for `@name` on line 2 with a call to `Module#attr_accessor`. We define a `Character#speak` instance method on lines 8-10, which returns a string with `@name` interpolated into it: `"#{@name} is speaking."`.

On lines 13-17, we define a `Knight` class as a subclass of `Character`. We define a `Knight#name` method that overrides the `Character#name` getter method. The method definition body calls the superclass method `Character#name` however using the `super` keyword. `Knight#name` then prepends the string `"Sir "` to the return value of the superclass method and returns the concatenated string.

On line 19, we initialize local variable `sir_gallant` to a new `Knight` object with `"Gallant"` passed through to the constructor.

On line 20, we call `Knight#name` on `sir_gallant` and pass the return value to `Kernel#p`, which outputs `"Sir Gallant"` as expected.

On line 21, we call `Character#speak` on `sir_gallant` and pass the return value to `p` to be output. The output is `"Gallant is speaking"` rather than `"Sir Gallant is speaking"`.

The reason for this output is that the `Character#speak` method is defined to reference the `@name` variable directly instead of the `name` getter method (line 9). If we change this so that we interpolate the return value of `name` into the string, we will receive the desired output:

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

8m09s



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

We define a `FarmAnimal` class on lines 1-5. We define a `FarmAnimal#speak` instance method that returns a string with keyword `self` interpolated into it `"#{self} says "`. `self` within an instance method references the calling object and string interpolation will implicitly call `to_s` on this object. Since we have not overridden the default `Object#to_s` method, the string representation of a `FarmAnimal` object will take the form `<ClassName:0x...>`, where `ClassName` is the calling object's class, and `0x...` is an encoding of the calling object's object id.

On lines 7-11, we define a `Sheep` class as a subclass of `FarmAnimal`. We override the `speak` method with `Sheep#speak`. The body of this method calls the superclass `FarmAnimal#speak` method using the `super` keyword before concatenating the return value to the string `"baa!"` and returning the concatenated string.

On lines 13-17 we define the `Lamb` class as a subclass of `Sheep`. We override `Sheep#speak` with `Lamb#speak`. The body of the definition calls the superclass method `Sheep#speak` (which involves a further call to `FarmAnimal#speak`) and concatenates the return value to the string `"baaaaaaa!"` before returning the concatenated string.

We define a `Cow` class as a subclass of `FarmAnimal`. We override `FarmAnimal#speak` with `Cow#speak`. The body of the method definition calls the superclass method `FarmAnimal#speak` before concatenating the return value to the string `"mooooooo!"`, and returns the concatenated string.

On lines 25-27, we instantiate new `Sheep`, `Lamb`, and `Cow`, objects and immediately call `speak` on each, passing the return values to `Kernel#p` to be output. The output will be:

```
"#<Sheep:0x00007f851e069e38> says baa!"
"#<Lamb:0x00007f851e069a50> says baa!baaaaaaa!"
"#<Cow:0x00007f851e0697f8> says mooooooo!"
```

10m10s

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

Collaborator objects are objects that become part of the state of a containing object. Such objects are called collaborators because they collaborate with the containing object in the fulfillment of its responsibilities. Collaborations between objects represent the network of connections between the actors in our programs, and collaborations between classes of object are therefore vital to consider from the design stage onward.

On lines 1-5, we define a `Person` class. The `Person#initialize` constructor is defined with one parameter `name` which is used to initialize instance variable `@name`.
On line 14, we initialize local variable `sara` to a new `Person` object, passing the string `"Sara"` through to the constructor to be used to initialize the `@name` instance variable in `sara`. Since the String object `"Sara"` has now become part of the state of `sara` by being assigned to its instance variable, the String object is a collaborator of the `sara` object. Given the name of the variable `@name` seems to expect to track a string of text, we can assume that class String is a collaborator of the `Person` class.

On lines 7-12, we define a `Cat` class. The `Cat#initialize` constructor takes two parameters `name` and `owner`, which are used to initialize instance variables `@name` and `@owner` respectively.

On line 15, we initialize local variable `fluffy` to a new `Cat` object passing the String `"Fluffy"` and the `Person` object `sara` through to the constructor to be assigned to the instance variables of `fluffy`. At this point the String object `"Fluffy"` and the `sara` object are collaborators of `fluffy`, and we can assume from the names of the instance variables that the String and `Person` classes are collaborator classes of the `Cat` class.

7m17s.

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

On line 3, we begin a `case` statement comparing `number` to the conditional expressions of the `when` clauses. The `case` statement will implicitly call the `===` method on the result of the expression following each `when` keyword with `number` passed as argument. The `===` method conventionally checks whether the argument can be considered part of the group represented by the calling object, returning `true` if so, `false` if not.

The first `when` clause on line 4 compares `number` to the integer `1`. This is done by implicitly calling `Integer#===` on `1` with `number` passed as argument. Since `1 === 42` returns `false`, we move to the next `when` clause.

On line 5, the expression following the `when` keyword is a comma-separated list of integers. This means that the `Integer#===` method is called for each individual integer with `number` passed as argument with an OR logic, so that `when 10, 20, 30` is here equivalent to

```ruby
10 === number || 20 === number || 30 === number
```

Since this comparison expression returns `false`, we move to the next `when` clause.

On line 6, the object following the `when` keyword is a Range object, so `Range#===` is called on `40..49` with `number` passed as argument. Since `42` is contained in the Range `40..49`, this method call returns `true` and the `case` statement returns `'third'`.

6m48s.

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

On lines 1-13, we define the `Person` class. On line 2, we initialize (or define) the constant variable `TITLES`. Since constant variables should not change their reference once defined, they are usually called simply constants.

Constants have lexical scope, meaning that a reference to a constant that is not qualified with a namespace will be resolved first with a search lexically of the reference, then with search of the inheritance chain beginning with the lexical structure surrounding the reference in the source code. The lexical search begins with the lexically enclosing structure, then widens to the next lexically enclosing structure, and so on up to but not including top-level. If no constant of that name is found, the inheritance hierarchy of the structure lexically enclosing the reference is searched, and finally top-level. Constants can also be referenced directly from anywhere in the program using the namespace the constant is defined in followed by the namespace operator `::` and the name of the constant.

The lexical scope of the `TITLES` constant is the `Person` class only, since there are no nested modules or classes within `Person`.

On line 4, the class variable `@@total_people` is initialized. Class variables are scoped at the level of the class, its descendant classes, and all instances of all these classes. This greatly expanded scope is why Rubyists typically advise against using class variables with inheritance. The scope of `@@total_people` is therefore the `Person` class and its instances. Class variables are not inherited but actually shared between the class, its descendant classes, and all of their instances.

The instance method `Person#initialize` (lines 6-8) initializes a `@name` instance variable on line 7. Instance variables are scoped at the object level. When the constructor is called during the instantiation of a new object, a `@name` instance variable will be initialized in this calling object. The scope of the instance variable will be the calling object. An instance variable is accessible by all of the instance methods available to be called on the object, regardless of which method initialized it. Instance variables cannot be accessed from outside the object except indirectly via the object's public instance methods. An object's instance variables are particular to that object and are not shared by any other object, even objects of the same class.

On lines 10-12, we define a `Person#age` instance method. Within the instance method body, on line 11, we initialize an `@age` instance variable. Instance variables are scoped at the object level. The scope of this variable will therefore be the calling object, an instance of `Person`. However there is currently no way to initialize this variable, and so this method will always return `nil`. This is because a reference to an uninitialized instance variable always returns `nil`.

??? at least 15 minutes

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

In the `Cat#make_one_year_older` method definition body, on line 10, we call `Cat#name=` explicitly on the calling object, referenced by the keyword `self`.

Normally, from within an instance method definition within the class, we can implicitly call another instance method of the class on the calling object simply by invoking the method without an explicit receiver (or the dot operator). However, for setter methods ending in `=`, this is not the case, since the syntax cannot be disambiguated from the syntax for initializing a local variable.

Since we cannot call `age=` on the calling object without using the keyword `self`, our only alternative is to set the instance variable `@age` directly: `@age += 1`.

However, it is generally preferred to use a setter method if one exists rather than referencing an instance variable directly. This has to do with the DRY principle, "don't repeat yourself", as well as code dependencies. If we use a setter method, and decide later that we wish to add a check or manipulation on the argument before assigning it to the instance variable, we can write this logic in one place instead of everywhere that the instance variable is set throughout the instance methods of the class. This reduces the chance of error, and helps us isolate problems during debugging. It also prevents our other instance methods from becoming dependent on the the existence of a particular variable, since they are only dependent on the interface of the setter method. This reduces code dependencies and makes our class easier to maintain and change.

9m15s

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

We define a `Driveble` module on lines 1-4. On lines 2-3, we define a method `drive` on the module itself (since `self` in this context references the module `Drivable`). Modules can be used to group methods defined on the module, and these are sometimes called 'module methods'. Module methods are not inherited when we mix a module into a class.

On lines 6-8, we define a `Car` class that mixes in `Drivable` with a call to `Module#include` on line 7.

On line 10, we initialize local variable `bobs_car` to a new `Car` object.

On line 11, we call `drive` on `bobs_car`, raising a `NoMethodError` exception. This is because mixing `Drivable` into the `Car` class did not cause `Car` to inherit the module method `drive`.

In order for this code not to raise an exception, we could change the `drive` module method to an instance method by removing the `self.` prefix:

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

This works because instance methods are inherited by a class from a mixin module that has been mixed into the class.

5m53s

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

The `>` and `<` methods may appear as operators due to the syntactic sugar around their invocation, but they are methods like any other. The conventional meaning of `>` is to check the caller's principal object value against that of an argument, usually an object of the same class, returning `true` if the caller's object value is greater, `false` otherwise. The meaning of `<` is similar but the logic is reversed.

We can define `>` and `<` methods in our `House` class ourselves, but we could also define a `<=>` method and include the `Comparable` module. The `<=>` method is conventionally defined to return `-1` if the caller is considered lesser than the argument, `0` if they are considered equal, and `1` if the caller is considered greater, based on the principal object value. The `Comparable` module depends on a `<=>` method being defined in the class it is mixed into. It then uses the `<=>` method to implement many comparison methods, including `>` and `<`.

We can use the object tracked by `@price` in our `House` class as the principal object value, which will be an Integer value. We can then use `Integer#<=>` as the basis of our `House#<=>` method, and include `Comparable` into `House`. This will give the desired result.

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

7m01s

