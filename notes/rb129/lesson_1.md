



Lesson 1: Readings

Discussions

If you write a custom `to_s` method that does not return a String object then when `to_s` is called (explicitly or implicitly) the code in the custom `to_s` will be executed but the String return value will be that of the default Object class implementation of `to_s`.

Polymorphism

In Ruby, the main ways to achieve polymorphism are through:

1) Class inheritance
2) Modules/mixins
3) Duck typing (e.g. adding `[]` and `[]=` methods to a class so that a piece of code doesn't need to know if it is accessing a member of an Array or some custom collection class)

## OOP Ruby book ##

### The Object Model ###

**OOP** - a programming paradigm that attempts to organize large-scale projects to enhance maintainability and reduce fragility. OOP attempts to mitigate the complex dependencies between parts of a program by organizing code into separate containers that interact with each other through interfaces, allowing parts of the program to be changed and new features to be added without problematic ramifications throughout the codebase.

key points

- maintainability through organizing programs as the interaction of many discrete small parts
- objects act as containers for data and functionality; their implementations can be changed without affecting the entire program



**Encapsulation** - encapsulation is an aspect of OOP concerned with cordoning off organizationally separate groupings of data with the functionality that operates on that data. Functionality is concealed from the rest of the program, as in a capsule, and an interface to the functionality is exposed that can remain consistent even if the implementation is changed. The data or state of the object is thus protected from modification by the rest of the program without deliberate intent.

key points

* defines boundaries within a program
* can discretely group data with functionality to expose and operate on that data
* allows hiding internal functionality and data, allows the implementation of functionality to be separated from the interface exposed to the rest of the program
* prevents data from being modified without deliberate intent
* classes encapsulate state and behaviors
* mixin modules encapsulate behaviors only



"Another benefit of creating objects is that they allow the programmer to think on a new level of **abstraction**. Objects are represented as real-world nouns and can be given methods that describe the behavior the programmer is trying to represent."



**Polymorphism** - the ability of objects of different types to respond to a common interface. In Ruby, the main ways to achieve polymorphism are through:

1) Class inheritance - methods can be inherited from a superclass, and can be overridden if a different implementation is needed.
2) Modules/mixins - mixin modules can make groupings of functionality available to various classes that are not in a subclass and superclass relation
3) Duck typing - in Ruby, unlike in statically-typed languages, as long as an object exposes the interface and behavior that a piece of code needs, the type of the object does not matter. If it walks like a duck, quacks like a duck, it's a duck. A method can accept as arguments objects of unrelated  classes so long as the objects passed in provide methods with the right name and the expected behavior.

key points

* the ability of objects of different types to respond to a common interface/method call
* as long as an object passed to a method behaves as expected, the class or type of the object is not important (duck typing)
* one way of achieving a shared behavior/interface between objects of different types is through inheritance
* "poly" means "many" and "morph" means "form"



**Inheritance** - one way that polymorphism is made possible in Ruby. A class can inherit the behaviors of a another class designated to be its superclass. This facilitates code reuse by making it possible to use a superclass to share common behaviors among multiple classes of object while additionally defining more specific behaviors for each subclass. A subclass may override a behavior inherited from a superclass with a different implementation that exposes the same interface. A class may only have one superclass but a single class may have multiple subclasses.

key points

* inheritance lets multiple (sub)classes of object share behaviors defined in a common superclass
* facilitates code reuse
* models hierarchical relationships or classifications; models an 'is-a' relationship between subclass and superclass
* unwanted individual behaviors inherited from a superclass may be overridden with a different implementation by a subclass



**Modules** - a module groups reusable code. Similarly to classes, modules can contain behaviors to be shared among multiple classes. However, unlike a class, one cannot instantiate an object from a module. A module can be "mixed in" to a class using the `Module#include` method so that the class and its objects can share the behaviors defined in a module. A module used in this way is called a "mixin". Whereas a class may only have one superclass, a class may `include` an arbitrary number of mixin modules.  Modules can also be used for namespacing purposes.



state - the attributes of an object, the data that is encapsulated by an object. In Ruby, an object's instance variables track the state of the object.

behaviors - the actions an object is capable of; an object's methods



**Objects** - in Ruby, anything that can be said to have a value is an object. Some things are not objects: methods, blocks, and variables, for instance. Objects are created from classes. A class is like a blueprint or mold for a type of object. Individual objects may contain different specific data but share common behaviors and attributes defined in their class.



**Classes** - define the common behaviors and attributes of a type of object. A class defines what state an object is able to track and what behavior an object is capable of. The creation of an object from a class is called instantiation, and the object created from the class can be referred to as an instance of that class. This is achieved by using the class method `::new`.



**Method Lookup** - method lookup path, method lookup chain. When a method is called, Ruby first searches the class of that object, then any mixin modules (in reverse order to their inclusion), then the superclass, then any modules mixed in to the superclass, and so on. Every Ruby object's lookup path ultimately moves upwards through class `Object`, then the `Kernel` module, then finally to `BasicObject`. If the method is still not found after `BasicObject` has been checked, a `NoMethodError` exception will be raised.



An object can be instantiated from a class by calling a the class method `::new` on the class. For instance,

```ruby
class Dog
end

spot = Dog.new
```



A mixin module is a collection of behaviors that can be shared among multiple classes. In order for a class to take on the behaviors contained in a module, the module must be mixed into the class using the `Module#include` method.

```ruby
module Run
  def run
    puts "I'm running"
  end
end

class Dog
  include Run
end

spot = Dog.new
spot.run # "I'm running"
```



## Classes and Objects - Part 1 ##

### States and Behaviors ##

"When designing a class, we typically focus on two things: *state* and *behaviors*"

"State refers to the data associated to an individual object (which are tracked by instance variables)"

"Behaviors are what objects are capable of doing"

"instance variables keep track of state, and instance methods expose behavior for objects"

**State** - when an object is instantiated from a class it will have its own instance variables, which are defined by the class and scoped at the object level. Instance variables track the state of that particular instance. State is the data associated to that particular object's instance variables and that data may be different for every instance of the class.

**Behavior** - the actions an object is capable of performing. Specifically, the behaviors of an object are the instance methods defined in that object's class.

The `#initialize` private instance method is a constructor. When the class method `::new` is called on a class, the `::new` method allocates space for a new object of that class in memory before calling the `initialize`  method with any arguments to `::new` passed through in order to construct the initial state of that instance.

Every object has its own distinct state, which is tracked by instance variables. Every instance of a class therefore has its own set of instance variables which are particular to that individual object. 

 Accessor methods. Setter and getter methods.

"Setter methods always return the value that is passed in as an argument, regardless of what happens inside the method. If the setter tries to return something other than the argument's value, it just ignores that attempt."

The `attr_*` methods take symbols as arguments and creates the appropriate getters and/or setters using the symbol to name them and the instance variable they permit access to. Thus,

```ruby
class Person
  attr_accessor :name, :age
  # code ommitted for brevity
end
```

line 2 in this example creates getter methods called `Person#name` and `Person#age`, setter methods called `Person#name=` and `Person#age=`, which access instance variables `@name` and `@age`.

(Probably want to use just one symbol for example)

"With getter and setter methods, we have a way to expose and change an object's state"

Getter and setter methods can be called from within the class as well as from without (assuming they are not private or protected). Using a getter method instead of directly referencing the instance variable permits processing the data in some way before it reaches the context in which it is referenced, allowing for greater flexibility and maintainability. If we decide we want to format or partially hide some of the information referenced by the instance variable without mutating the object the variable references, we can now easily change the getter without changing other methods that make use of the object referenced by the instance variable. This way the raw data, the object referenced by the instance variable, is decoupled from the points where it is referenced in our instance methods, allowing us to change only the getter method in order to process that data when referencing it, without mutating it where it is stored in memory. Similarly, a setter method permits us to run checks on values before assigning them to an instance variable.

When calling a setter method from inside the class, it is necessary to call it using the `self` keyword to reference the current object explicitly as caller in order to disambiguate the method call from initializations of local variables, e.g.

```ruby
class Car
  attr_writer :speed
  
  # code omitted for brevity
  
  def change_speed(new_speed)
    self.speed = new_speed # calls the setter method
    speed = new_speed # initializes a new local variable `speed`
  end
end
```



Class methods are methods called on a class itself, not on the instances of that class. The simplest way to define a class method is to prepend the keyword `self` to the method name when defining the method in the class, like so

```ruby
class Car
  def self.kph_to_mph(kph)
    (kph * 0.6213712).round(2)
  end
end    
```

By default, in a user-defined class, the `Object#to_s` method is called when an object of that class is passed to `puts` or interpolated into a string. This `Object#to_s` method returns a string representation with the name of the object's class and an encoding of its object id. `to_s` can be overridden in custom classes to provide a more suitable string representation. If the custom `to_s` method is defined in such a way that it does not return a String object, however, then Ruby will search up the inheritance chain to find a `to_s` method that does return a String, usually `Object#to_s`, and will call this method to return a String object. This ensures that any `to_s` method must return a String object.

**Self** - use `self`

1. when calling setter methods from within the class (to disambiguate calling the setter method from initializing a local variable)
2. when defining a class method within a class definition

`self` refers to the current object. Within an instance method, this means the object that called the instance method. Within a class definition (but outside of instance method definitions) the current object is the class itself (since a class is itself an object in Ruby).

so from within a class,

1. `self` inside of an instance method references the instance that called the method
2. `self` outside of an instance method references the class and can be used to define class methods



### Inheritance ###



"We use inheritance as a way to extract common behaviors from classes that share that behavior, and move it to a superclass."



**Class Inheritance** 

- each subclass can only have one superclass, but that superclass can have a superclass, and so on in a chain of class inheritance
- a single superclass can have multiple subclasses, which may in turn have subclasses, so that tree-like hierarchical structures of relation can be modeled with class inheritance
- the `<` symbol is used to express that a subclass inherits from the named superclass.
- we can override an inherited method by defining a method with the same name in the subclass.
- the ability to override inherited methods is an aspect of the way Ruby searches for methods via the method lookup path when a method is called
- inheritance can facilitate DRY - Don't Repeat Yourself
- class inheritance is best suited to modeling hierarchical concepts



**super** - `super` is a keyword that can be used within an instance method to call a method of the same name earlier in the method lookup path. This is very commonly done within the `initialize` method of a class.

When there are parameters involved,

* `super` with no arguments passed will pass through all arguments that were passed to the subclass method to the method that `super` references.
* `super()` with empty parentheses will call the method that is earlier in the lookup path without passing any arguments through to it
* `super(a, b)` with arguments will pass those particular objects through to the method that is further up the lookup path



**Mixin Modules** - mixing in modules is another way to facilitate code reuse. The example given by LS focuses on a class hierarchy in which a method is needed by individual subclasses in different branches of an inheritance tree, where no common superclass can define the method without granting it to other subclasses that should not have it.

* sometimes called 'interface inheritance'
* useful for situations where there are exceptions to a hierarchical relationship between classes, situations where only certain subclasses have a group of behaviors in common but not all subclasses, so that extracting the behaviors into the superclass is not a good design option

* conventionally, Ruby mixin modules tend to have the suffix "-able" attached to a verb describing the behavior modeled by the methods in the module. This convention is not always observed, it is merely common.

