



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



**Encapsulation** - encapsulation is an aspect of OOP concerned with cordoning off organizationally separate groupings of data with the functionality that operates on or exposes that data. Functionality is concealed from the rest of the program, as in a capsule, and an interface to the functionality is exposed that can remain consistent even if the implementation is changed. The data or state of the object is thus protected from modification by the rest of the program without deliberate intent.

key points

* defines boundaries within a program
* can discretely group data with functionality to expose, operate on, and deliberately modify that data
* allows hiding internal functionality and data, allows the implementation of functionality to be separated from the interface exposed to the rest of the program
* prevents data from being modified without deliberate intent
* classes encapsulate state and behaviors (a class can be instantiated as an object)
* mixin modules encapsulate behaviors only (a module cannot be instantiated as an object)



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



**Inheritance** - one way that polymorphism is made possible in Ruby. Inheritance lets us define a class (a subclass) in terms of another class (a superclass). A class can inherit the behaviors of a another class designated to be its superclass. This facilitates code reuse by making it possible to use a superclass to share common behaviors among multiple classes of object while additionally defining more specific behaviors for each subclass. A subclass may override a behavior inherited from a superclass with a different implementation that exposes the same interface. A class may only have one superclass but a single class may have multiple subclasses.

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
- a single superclass can have multiple subclasses, which may in turn have multiple subclasses, so that tree-like hierarchical structures of relation can be modeled with class inheritance
- class inheritance typically models an 'is-a' relationship between subclass and superclass
- the `<` symbol is used to express that a subclass inherits from a named superclass.
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
* whereas a class can only subclass from one superclass, it can include an arbitrary number of mixin modules
* modules cannot be instantiated
* useful for situations where there are exceptions to a hierarchical relationship between classes, situations where only certain subclasses have a group of behaviors in common but not all subclasses, so that extracting the behaviors into the superclass is not a good design option
* models a 'has-a' relationship between the class and the behavior defined in the mixin module, i.e. has an ability to...

* conventionally, Ruby mixin modules tend to have the suffix "-able" attached to a verb describing the behavior modeled by the methods in the module. This convention is often but not always followed.



Method lookup path - the lookup path checks

1. The class of the object on which the method is called
2. Any mixin modules included in the class in the reverse order in which they are included
3. The superclass

This pattern repeats, often ending with class `Object`, the `Kernel` module, and finally class `BasicObject`



**Other uses of modules**

1. Namespacing - grouping related classes and preventing name pollution
2. Container for methods that are not to be mixed in to any class (defined on the module with similar syntax to class methods)

**Namespacing** - grouping conceptually-related classes under a module name. This increases code readability by highlighting conceptual relationships and decreases the chances of naming conflicts.

* classes in a namespacing module are accessed via the  `::` operator, e.g. `MyModule::MyClass.new`

**Method container modules** - using the module to collect related methods defined on the module itself

```ruby
module Power
  def self.square(x)
    x * x
  end
  
  def self.cube(x)
    x * x * x
  end
end

puts Power.square(5) # 25  # the dot operator is preferred over :: for this
puts Power::square(5) # 25 # though :: will also work
```



**Method access control**

(Access control exists in other languages, often as a way to restrict the accessibility of object state as well as well as the object's methods. However, in Ruby, the only way to make an object's state accessible from outside the object is to expose it through methods. Hence, in Ruby, this concept is generally referred to as Method Access Control; it is concerned with restricting the accessibility of methods)

`public`, `private` and `protected` are access modifier methods. If, for instance, `private` is called within a class, the instance methods defined after it will be considered private methods (unless a different access modifier is called after it).

* **public** - public instance methods can be called from outside the object and outside the class (as well as within). An object's public instance methods comprise its public interface.
* **private** - private instance methods can only be called from within instance methods within the class and can only be called on the current instance. Private methods are generally implementation details that perform necessary work but that we do not need to expose to the rest of the program
* **protected** - protected instance methods cannot be called from outside the class but unlike private methods they can be called on another instance of the same class that has been passed into an instance method as argument as well as on the current instance

Before Ruby 2.7 it was not possible to call a private method using an explicit `self` keyword, though that is now possible. Even though it was not possible to syntactically use `self` as explicit caller of a private method before Ruby 2.7, semantically the current object -- the referent of `self` -- has always been the only valid caller of private methods; private methods cannot be called on any other object than the current object (unlike for public and protected methods).



One reason for using getters/setters within the class is that a typo in an instance variable will quietly initialize a new instance variable with the misspelled name and initialize it to `nil`, which can make debugging difficult.



## TutorialsPoint ##

Creating an object using `allocate`

If you want to create a new object without calling its `initialize` constructor method, you can call `allocate` instead of `new` on the class to return a new instance of that class without the `initialize` method being called. The `new` method itself calls `allocate` before calling `initialize` with the arguments given to `new`, if any, passed through to `initialize`.

## ZetCode ##

abstraction - "simplifying complex reality by modeling classes appropriate to the problem"

encapsulation - "hides the implementation details of a class from other objects"

inheritance - "a way to form new classes using classes that have already been defined"

polymorphism - "the process of using an operator or function in different ways for different data input"



"Objects are basic building blocks of a Ruby OOP program. An object is a combination of data and methods. Ina OOP program, we create objects. These objects communicate together through methods. Each object can receive messages, send messages and process data."

"A class is a template for an object. It is a blueprint that describes the state and behavior that the objects of the class all share. A class can be used to create many objects. Objects created at runtime from a class are called *instances* of that particular class"

"every object created inherits from the base Object"

"An object's attributes are the data items that are bundled inside that object. These items are also called *instance variables*. An instance variable is a variable defined in a class, for which each object in the class has a separate copy"

"the `allocate` method allocates space for a new object of a class and does not call `initialize` on the new instance"

"Methods are functions defined in the body of a class. They are used to perform operations with the attributes of our objects. Methods are essential in the *encapsulation* concept of the OOP paradigm."

In Ruby, there is no way to access an object's instance variables from outside the object other than through instance methods; an object's state is thus encapsulated and hidden from outside the object by default. However, he accessibility of an object's instance methods can be controlled using access modifiers. Ruby has three levels of accessibility for instance methods: public, private and protected. Methods are public by default (though the `Module#public` access modifier method can be used to make methods public explicitly, for instance after defining some private methods). The `Module#private` method can be used to make the methods defined following it private.

```ruby
class UserRecord
  def initialize(username, user_password)
    @username = username
    @password = user_password
  end
  
  def correct_password?(password_attempt)
    password_attempt == password
  end
  
  private
  
  def password
    @password
  end
end

user = UserRecord.new('josh', 'abc123')
user.correct_password?('abc123') # true
user.password # raises NoMethodError
```

Here, all the instance methods defined below the call to `private` on line 11 will be private methods.

Private instance methods can be called from within the class inside other instance methods and can only be called on the current object, as on line 8. Here, the public `correct_password?` method calls the private `password` method.  However, when we try to call a private method from outside the class, as on line 20, a `NoMethodError` will be raised with a message telling us we have attempted to call a private method.

Protected methods are defined with similar syntax with the `Module#protected` method.

```ruby
class Person
  attr_reader :name
  
  def initialize(name, height_in_cm)
    @name = name
    @height = height_in_cm
  end
  
  def taller_than?(other_person)
    height > other_person.height
  end
  
  protected
  
  def height
    @height
  end
end

bill = Person.new('Bill', 183)
george = Person.new('George', 175)
bill.name # "Bill"
bill.taller_than?(george) # true
bill.height # NoMethodError raised
```

In this example, the `@name` attribute is publically accessible using the public getter method `name`, as defined on line 2 and called on line 22. The value of the `@height` instance variable can only be accessed via the protected method `height`. Protected methods can only be called from within the class and within an instance method. The attempt to call protected method `height` from outside the class, on line 25, raises a `NoMethodError` with a message telling us we have attempted to call a protected method. So, like a private method, a protect method can only be called from within the class. Unlike a private method, however, a protected method can be called not only on the current object but on any object of the same class. So in the public `taller_than?` method defined on line 10, we call protected method `height` and then compare the return value to the return value of calling the same protected method on the `other_person` object that has been passed into the method. So when we pass the `george` Person object as argument on line 23, the method successfully calls the protected method `Person#height` on an object other than the current object `bill`, and the `taller_than?` method successfully returns `true`.

The access modifier method `Module#public` can be called after another modifier to revert to defining public methods:

```ruby
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  private
  
  def age
    @age
  end
  
  public
  
  def name
    @name
  end
end
```

The only time a method is private by default is a class's `initialize` contructor method.

"Access modifiers protect data against accidental modifications. They make programs more robust. The implementation of some methods is subject to change. These methods are good candidates for being private. The interface that is made public to users should only change when really necessary. Over the years users are accustomed to using specific methods and breaking backward compatibility is generally frowned upon."

Inheritance

"a way to form new classes using classes that have already been defined. Important benefits of inheritance are code reuse and reduction of complexity of a program. The derived classes (descendants) override or extend the functionality of base classes (ancestors)"

"In Ruby, we use the `<` operator to create inheritance relations."

## Interlude on Constants and Constant Scope ##

In Ruby, constants defined in a class do not belong to an instance, they belong to the class. So,

```ruby
class SineWave
  PI = 3.14159
  # code omitted...
end

puts SineWave::PI # prints 3.14159
wave = SineWave.new
puts wave.PI # raises NoMethodError
puts wave::PI # raises TypeError (the wave object is not a class or module)
```

The instance methods of an instance of a class have access to a class constant but to access the constant from outside of the class one must use the `::` operator on the class itself. 

Class constants are generally accessible from outside the class using the `::` operator, e.g. `Math::PI`.

However, as of Ruby 1.9.3, you can make constants private by passing a symbol or string representation of the name of a constant to the `Module#private_constant` method (at the class level), like so,

```ruby
class SineWave
  PI = 3.14159
  private_constant :PI # could also be "PI"
  # some code omitted...
end

puts SineWave::PI # NameError raised
```

This prevents a constant being referenced from outside the class.



from Wikipedia: "In languages with **lexical scope** (also called **static scope**), name resolution depends on the **location in the source code** and the *lexical context*... which is defined by where the namedd variable or function is defined... With lexical scope, a name always refers to its lexical context. This is a property of the program text and is made independent of the runtime call stack by the language implementation. Because this matching only requires analysis of the static program text, this type of scope is also called **static scope**." 

Wikipedia citing the ALGOL 60 spec: the lexical scope of a name is "the **portion of source code** in which a binding of a name with an entity applies"

It's important to understand that this is a description of lexical scope (vs dynamic scope) at the more general level of programming-language design, a paradigm for resolving names. The LS material should be understood therefore as talking specifically about the specific lexical scoping rules for *class constants in Ruby*. It's not that Ruby constants *have* lexical scope and Ruby variable *don't*. Rather it's that Ruby constants have a lexical scope that involves searching a surrounding lexical context (of nested chunks of source code out to but not including toplevel) before the inheritance hierarchy is searched (and then finally toplevel).

In Matz's *The Ruby Programming Language*, he states that the "important difference between constants and methods is that constants are looked up in the lexical scope of the place they are used before they are looked up in the inheritance hierarchy. This means that if [subclass] `Point3D` inherits methods that use the constant `ORIGIN`, the behavior of those inherited methods will not change when `Point3D` defines its own version of `ORIGIN`"

To illustrate:

```ruby
class Box
  CAPACITY = 6000
  
  def show_capacity
    puts "This box has a capacity of #{CAPACITY} cubic centimeters"
  end
end

class LargeBox < Box
  CAPACITY = 10_000
end

large = LargeBox.new
large.show_capacity # This box has a capacity of 6000 cubic centimeters
```

In order to reference the correct constant without duplicating the `show_capacity` method definition from the Box class in LargeBox, we need alter the `show_capacity` method to dynamically reference the calling object's class, like so

```ruby
class Box
  # code omitted for brevity
  def show_capacity
    puts "This box has a capacity of #{self.class::CAPACITY} cubic centimeters"
  end
end
```

The call to `show_capacity` on a LargeBox object will now reference the constant defined in the LargeBox class, since `self.class::CAPACITY` evaluates to `LargeBox::CAPACITY`, and the output will be `This box has a capacity of 10000 cubic centimeters`.

From Matz, **The Ruby Programming Language**: 

"When a constant is referenced without any qualifying namespace... Ruby first attempts to resolve a constant reference in the lexical scope of the reference. This means that it first checks the class or module that encloses the constant reference to see if that class or module defines the constant. If not, it checks the next enclosing class or module. This continues until there are no more enclosing classes or modules. Note that top-level or "global" constants are not considered part of the lexical scope and are not considered during this part of constant lookup. The class method `Module.nesting` returns the list of classes and modules that are searched in this step, in the order they are searched.

If no constant definition is found in the **lexically enclosing scope**, Ruby next tries to resolve the constant in the inheritance hierarchy by checking the ancestors of the class or module that referred to the constant. The `ancestors` method of the containing class or module returns the list of classes and modules searched in this step. If no constant definition is found in the inheritance hierarchy, then top-level constant definitions are checked.

If no definition can be found for the desired constant, then the `const_missing` method -- if there is one -- of the containing class or module is called and given the opportunity to provide a value for the constant."

The following code illustrates this:
```ruby
# If the enclosing lexical scope and the inheritance hierarchy are searched
# and the constant is not found, the top-level will finally be searched
# for constants
TAU = 'a Greek letter'

class Outer
  TAU = Math::PI * 2
  class Inner
    class ClassA
      def show_tau
        # a call to Module::nesting shows the enclosing lexical scope
        puts "The enclosing lexical scope of the following reference is #{Module.nesting}"
        puts "Tau is #{TAU}"
      end
    end
  end
end

# ClassB is namespaced at the same depth as ClassA, but in the source code itself
# at the point of definition, ClassB is not lexically nested/enclosed by its
# namespacing classes
class Outer::Inner::ClassB
  # The following class method definition would provide functionality
  # in the event that a constant could not be found, even after looking at
  # top-level:
  def self.const_missing(constant_symbol)
    constant_symbol
  end

  def show_tau
    puts "The enclosing lexical scope of the following reference is #{Module.nesting}"
    puts "Tau is #{TAU}"
  end
end

object_a = Outer::Inner::ClassA.new
object_a.show_tau

object_b = Outer::Inner::ClassB.new
object_b.show_tau

# remember neither namespacing nor nesting is the same as inheritance
puts "ClassA inheritance hierarchy: #{Outer::Inner::ClassA.ancestors}"
puts "ClassB inheritance hiararchy: #{Outer::Inner::ClassB.ancestors}"
```

This code outputs

```ruby
The enclosing lexical scope of the following reference is [Outer::Inner::ClassA, Outer::Inner, Outer]
Tau is 6.283185307179586
The enclosing lexical scope of the following reference is [Outer::Inner::ClassB]
Tau is a Greek letter
ClassA inheritance hierarchy: [Outer::Inner::ClassA, Object, Kernel, BasicObject]
ClassB inheritance hiararchy: [Outer::Inner::ClassB, Object, Kernel, BasicObject]
```

If a constant is defined at top-level you may prepend a `::` to reference it:

```ruby
PI = 3.14159

class Thing
  PI = 'pie'
  
  def test_method
    ::PI
  end

  def another_method
    PI
  end
end

thing = Thing.new
puts thing.test_method # 3.14159
puts thing.another_method # pie
```

## Back to Zetcode ##

`puts` calls `to_s` on objects passed to it as arguments

string interpolation of an object calls `to_s` on the object

`p` calls `inspect` instead

Class methods can only be called on the class, not on the instances of the class

Class methods cannot access instance variables

To define a class method at the class level, we can prepend `self.` to the name of the method. Within the class definition but outside any instance method definitions, the `self` keyword references the class. E.g.,

```ruby
class SomeClass
  def self.some_class_method
    puts "This is a class method"
  end
end

SomeClass.some_class_method # outputs 'This is a class method'
an_instance = SomeClass.new
an_instance.some_class_method # raises NoMethodError
```

There are multiple syntactic ways to define a class method in Ruby

```ruby
class Wood
  def self.info
    "This is the Wood class"
  end
end

class Brick
  class << self
    def info
      "This is the Brick class"
    end
  end
end

class Rock; end
def Rock.info
  "This is the Rock class"
end
```

These three syntactic options are equivalent.

### Polymorphism ###

* "the process of using an operator or function in different ways for different data input"
* class B can inherit methods from class A but can also override them
* the ability to appear in different forms
* the ability to redefine methods for derived classes
* the application of specific implementations to an interface defined in a more generic base class

"In dynamically typed languages we concentrate on the fact that methods with the same name do different things"

So the way I see it, this can be the result of class inheritance (and overriding), mixin modules/interface inheritance, and duck-typing

Interlude from Matz on Mixins: "The normal way to mix in a module is with the `Module#include` method. Another way is with `Object#extend`. This method makes the instance methods of the specified module or modules into singleton methods of the receiver object. (And if the receiver object is a `Class` instance, then the methods of the receiver become class methods of that class.)"

## Modules ##

principal differences of modules to classes

* modules cannot be instantiated
* modules cannot have superclasses or subclasses
* modules can be mixed in to classes and other modules

## Interlude on Interface Inheritance and what LS means by it ##

It seems to me that class inheritance and mixin modules both lead to a class inheriting behaviors rather than instance variables/attributes, in the sense that instance variables can only come into being through the runtime calling of methods/behaviors on the object (unlike in a language where the variables are declared as fields of a class/struct/etc where those variables are inherited whether they are ever used or not at runtime).

Furthermore, in Ruby, both private and public methods are inherited via both types of inheritance, meaning that unless one overrides these methods, one inherits both implementation and interface.

I think the reason LS uses the term 'interface inheritance' to describe mixin modules is that class inheritance should express an is-a relationship, whereas including a mixin modules expresses what messages an object can respond to (whether externally to the class and its instances or internally), which is to say a has-a relationship. The conventional names of classes are nouns; the conventional names of Ruby mixin modules are adverbs that express ability to act on messages, capabilities from the point of view of an object's necessary activities: Enumerable, Comparable, and so on. An instance of a class *has* the ability to compare another object to itself, it *has* the ability to enumerate, and so on, and whether the mixin contains private methods to implement parts of this ability is not necessarily relevant.

Perhaps there is also the consideration that implementation inheritance is generally stigmatized and so the number of possible superclasses of an object is restricted to one. Interface inheritance is generally favored by comparison, so you can mix in as many mixin modules as you like. 

Actually, it's worth noting that Brandi Seeley (TA) does state that interface inheritance is only one *use* of mixin modules, so maybe mixin modules where, say, all the methods are private could be said to be implementation inheritance. I think the more general concept might simply be that mixins facilitate multiple inheritance, and supplement the behaviors of classes where those behaviors cannot neatly be extracted to a superclass. Further, as the GoF book points out, class inheritance in Smalltalk and C++ generally makes no distinction between implementation and interface inheritance (for very different reasons) and Ruby is similar to Smalltalk in this respect. So it is not true that Ruby class inheritance is synonymous with implementation inheritance either.

So an example of implementation inheritance might exist in a class inheritance tree like,

```ruby
module Anchorable
  def cast_anchor
    puts "Casting anchor..."
  end
end

class Vehicle
end

class Aircraft < Vehicle
end

class Plane < Aircraft
end

class HotAirBalloon < Aircraft
  include Anchorable
end

class Boat < Vehicle
  include Anchorable
end
```

Here, the `cast_anchor` method cannot simply be extracted to a superclass, since `Boat` inherits from `Vehicle` and not all vehicles have anchors, while `HotAirBalloon` inherits from `Aircraft` and yet may be the only example of an aircraft with an ability to cast an anchor.

"Now you know the two primary ways that Ruby implements inheritance.  Class inheritance is the traditional way to think about inheritance: one type inherits the behaviors of another type. The result is a new type  that specializes the type of the superclass. The other form is sometimes called **interface inheritance**: this is where mixin  modules come into play. The class doesn't inherit from another type, but instead inherits the interface provided by the mixin module. **In this  case, the result type is not a specialized type with respect to the** **module**."

This makes it seem that class inheritance is in contradistinction to interface inheritance, and can even suggest that mixin modules are always a form of interface inheritance, but that is not really the case. The last sentence is key, at least in relation to how 'interface' tends to be used in other programming languages, as well with respect to how modules actually behave (i.e. without class inheritance, without instantiation, not expressing an is-a relationship).

From GoF, Design Patterns, 'Class versus Interface Inheritance':

So here, type means the set of operations that can be legally performed on the object, while class means the internal structure of the object (with respect to operation definition and state declaration, the variables it contains and its method definitions). Type is more relevant to polymorphism, class to encapsulation. In Ruby, similarly to Smalltalk, the notion of type as distinct to class largely disappears because a variable can reference any object and duck-typing is the ultimate test of type compatibility of a given variable (i.e. whether a message sent to the object referenced by the variable corresponds to a method in the object's interface).

"It's important to understand the difference between an object's class and its type.

An object's class defines how the object is implemented. The class defines the object's internal state and the implementation of its operations. In contrast, an object's type only refers to its interface -- the set of requests to which it can respond. An object can have many types, and objects of different classes can have the same type.

Of course, there's a close relationship between class and type. Because a class defines the operations an object can perform, it also defines the object's type. When we say an object is an instance of a class, we imply that the object supports the interface defined by the class.

Languages like C++ and Eiffel use classes to specify both an object's type and its implementation. Smalltalk programs do not declare the types of variables; consequently, the compiler does not check that the types of objects assigned to a variable are subtypes of the variable's type. Sending a message requires checking that the class of the receiver implements the message, but it doesn't require checking that the receiver is an instance of a particular class.

It's also important to understand the difference between class inheritance and interface inheritance (or subtyping). Class inheritance defines an object's implementation in terms of another object's implementation. In short, it's a mechanism for code and representation sharing. In contrast, interface inheritance (or subtyping) describes when an object can be used in place of another.

It's easy to confuse these two concepts, because many languages don't make the distinction explicit. In languages like C++ and Eiffel, inheritance means both interface and implementation inheritance... In Smalltalk, inheritance means just implementation inheritance. You can assign instances of any class to a variable as long as those instances support the operation performed on the value of the variable."

## return to ZetCode ##

**Exceptions** - "objects that signal deviations from the normal flow of program execution. Exceptions are raised"

So exceptions are objects that are **raised** and when an exception is raised we can **handle** it.

"Exceptions are objects. They are descendants of a built-in Exception class. Exception objects carry information about the exception. Its type (the exception's class name), an optional descriptive string, and optional traceback information. Programs may subclass Exception, or more often StandardError, to obtain custom Exception objects that provide additional information about operational anomalies."

If we pass an Exception object to `puts`, the implicit `to_s` call will return the message.

If `raise` is only passed a string, the default exception type will be RuntimeError with the string as its message.

The `ensure` clause creates a block of code that always executes whether there is an exception or not.

Custom exceptions should inherit from `StandardError`.

## Lesson 1.4: Attributes ##

At a general, abstract level, the attributes of an object are its characteristics. So for a laptop object they might include: make, model, memory, cpu, etc.

In JavaScript, the attributes of an object are defined in a definitive way as its properties:

```javascript
let laptop = {
  memory: '8GB',
}

laptop.memory; // '8GB'
laptop.memory = '16GB';
laptop.memory; // '16GB'
```

However, implementing the same in Ruby is more involved, requiring us to initialize instance variables and create getter and setter methods to reference and set that instance variable:

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
laptop.memory # '8GB'
```

Yet to *define* attributes in this way in Ruby raises troubling questions. Does an attribute need to have both getter *and* setter? Do both methods have to be public? What if an instance variable has no `attr_*` methods at all?

Therefore, in general, "the term 'attributes' is used quite loosely and is generally approximated as *instance variables*. Most of the time, these instance variables have accessor methods... however, it's not a must for the purposes of this definition."

"So, when we say that **classes define the attributes of [their] objects**, we're referring to how classes specify the names of instance variables each object should have. The classes also define the accessor methods (and level of method access control); however, we're generally just pointing to the instance variables. Similarly, when we say **state tracks attributes for individual objects**, our purpose is to say that **an object's state is composed of instance variables and their values**; here, we're not referring to the getters and setters."

## Summary ##

* the relationship between a class and an object (defines state (attributes) and behaviors for instances (objects))

- a class groups behaviors (ie, methods)

Object level

* objects do not share state between other objects, but do share behaviors
* put another way, the values in the objects' instance variables (states) are different, but they can call the same instance methods (behaviors) defined in the class

Class level

* classes also have behavors not for objects (class methods)

Inheritance

* sub-classing from parent class. Can only sub-class from 1 parent; used to model hierarchical relationships
* mixing in modules. Can mix in as many modules as needed; **Ruby's way of implementing multiple inheritance**
* understand how sub-classing or mixing in modules affects the method lookup path

