Encapsulation

Definition

1. Encapsulation means bundling data (state) with the operations (methods) that are valid on that type of data to form an object.
2. Encapsulation means sectioning off functionality and protecting data behind a consistent public interface, which consists of a class's public methods.

Implementation

1. In Ruby, encapsulation is achieved by defining classes and instantiating objects
2. Objects encapsulate state, tracked by instance variables. In Ruby, an object's instance variables can only be accessed from outside, if at all, through deliberately exposed public methods such as getters and setters
3. In Ruby, we can have fine-grained control of which methods form the consistent public interface and which methods are part of the implementation via method access control
4. Our public interface should be as simple as possible and should remain consistent.

Benefits

1. Data protection: 
   1. Bundling data and operations means that a given type of data can only have an operation performed on it if that operation is valid for that type of data.
   2. An object's instance variables can only be accessed from outside the object, if at all, through the public interface, preventing accidental or invalidating modification of an object's state. 
2. Maintainability, reducing code dependencies: Client code can only become dependent on the public interface of a class, not on the implementation or representation. This leaves us free to change the implementation of the class, and, as long as the interface remains consistent, we won't break existing code. So this reduction of code dependencies makes our programs more maintainable.
3. Abstraction:
   1. Bundling state and behavior into an object means that we can treat our objects as modeling real-world objects: the 'nouns', or entities, of the problem domain. This allows us to think at a greater level of abstraction, and to solve complex problems without worrying about implementation details.
   2.  Exposing a restricted public interface simplifies the use of our class. Users do not need to understand the implementation, only the public interface. This allows us to think at a greater level of abstraction, the level of the problem domain itself, rather than at the level of implementation details, helping us to solve more complex problems.









Polymorphism



Definition

* 'Poly' means 'many' and 'morph' means 'forms'

* Polymorphism is the ability of different types of data to respond to a common interface, often, though not always, in different ways. That is to say, polymorphism is the ability of different classes of object to respond to the same method invocation.

* Polymorphism means that we can pass an object to a method and as long as that object responds appropriately to the method invocations that the method makes on its arguments, we don't have to worry about the exact type of the object.

* Polymorphism can be seen in action when a piece of client code makes use of objects of different types using the same interface without concern for the type of the objects.

* However, polymorphism is made possible by designing our data types, or classes of object, so that a selection of different types can be treated as though they were the same type.

Implementation

* In Ruby, polymorphism can be implemented in three main ways: through class inheritance, through mixin modules, or through duck typing.
  1. * We can implement polymorphism through class inheritance. Through class inheritance, subclasses inherit methods from a superclass, meaning that the classes in the inheritance hierarchy expose a common interface, even if the implementations of the inherited methods in the superclass are sometimes overridden with more specialized implementations in the subclass.
     * Class inheritance lets us work with the objects of the various different classes in the inheritance hierarchy in the same way, using a common interface, even though the implementations may be very different.
  2. We can also implement polymorphism through mixin modules, sometimes called 'interface inheritance'. By mixing in a module to multiple different classes, objects of multiple different types can respond to the common interface provided by the module.
  3. * Duck typing is a form of polymorphism where objects of completely unrelated classes can respond to a common interface.
     * In Ruby, we can implement polymorphism through duck typing simply by defining a method of a given name with a given number of required parameters in multiple classes, with a method implementation that is compatible for our intended purpose.
     * These classes can then be used polymorphically despite not being related by any kind of inheritance. So if two objects of unrelated types expose a method called `quack`, they can be passed to a piece of client code, a method or a block, that calls `quack` on its arguments, without the client code needing to check the type of its arguments. If an object quacks like a duck, it can be treated like a duck. Which is to say, that as long as the object exposes the interface required for the task at hand, it can be considered as belonging to the right category of object.

Benefits

* Polymorphism makes programs less fragile and more flexible by loosening the coupling between a given piece of code and the details of the data type it expects to operate with. Client code does not need to have knowledge of the type of object it is operating on or its implementation, only of a particular interface. 
* Polymorphism thus reduces code dependencies and makes programs more maintainable

Class inheritance example:

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
vehicles.each { |vehicle| vehicle.start }
```

Mixin module example:

```ruby
module Climbable
  def climb
    puts "I'm climbing..."
  end
end

class Mountaineer
  include Climbable
end

class Cat
  include Climbable
end

climbers = [Cat.new, Mountaineer.new]
climbers.each { |climber| climber.climb }
```

Duck typing example:

```ruby
class Duck
  def fly
    flap_wings
  end
  
  def flap_wings
    # ...
  end
  #...
end

class Airplane
  def fly
    start_engines
  end
  
  def start_engines
    # ...
  end
end

class Rocket
  def fly
    ignite_fuel
  end
  
  def ignite_fuel
    # ...
  end
  #...
end

flyers = [Duck.new, Airplane.new]
flyers.each { |flyer| flyer.fly }
```



What is OOP?

* OOP is a **programming paradigm** created to deal with the problems of large, complex software systems. OOP offers powerful tools for **dealing with complexity**.
* Before OOP, as programs grew in scale and complexity, the codebase tended to become a mass of dependencies. Code could not be changed, or features added, without a ripple of adverse effects throughout the program.
* OOP aims to **reduce code dependencies**, providing **containers for data** that can be changed without affecting the rest of the code base, allowing us to **section off functionality and data behind public interfaces**, so that a program becomes the interaction of small parts rather than a mass of dependency. This **makes programs more maintainable**.
*  By abstracting away implementation details, OOP allows us to think in terms of the problem domain. OOP objects can represent real-world objects as 'nouns', allowing as to **think at a higher level of abstraction**. This provides **a high-level way to break down and solve complex problems**.
* By allowing us to modularize code, OOP permits **code reuse** in a greater variety of contexts.



Exam question topics

1. Encapsulation
2. Classes as templates for objects. Instantiation. Objects encapsulate state, classes group behaviors. Classes predetermine behavior and attributes.
3. Class inheritance and mixin modules
4. Accessor method debug, code only
5. Setter methods ending in `=`, local variables, `self`, and expressions like `accidental_var = accidental_var.upcase`, where the uninitialized local var shadows the getter method
6. The `==` fake operator method, `BasicObject#==`
7. Setter methods vs setting variable directly. Reduce repetition of logic, reduce dependencies on the representation of the object
8. Class variables and class methods debug, code only
9. Method access control, `private` and `protected`
10. Method lookup path
11. Modules as namespaces, why are they useful? Contextualizes the names of the grouped classes and reduces potential for name collisions with other classes in the codebase. Conveniently modularizes groups of related classes for code reuse/library purposes.
12. Modules as mixins, plus example. Modules as containers for methods (module methods), plus example.
13. Polymorphism, brief description of polymorphism through class inheritance, mixin modules, and duck typing
14. Debugging question on class variables and class vs instance methods
15. Different OOP relationships between classes
16. Spike



Class with `private` and `protected` methods

```ruby
class CustomerRecord
  attr_reader :name

  def initialize(name, card_number, total_spent)
    @name = name
    @card_number = card_number
    @total_spent = total_spent
  end
  
  def card_details
    "xxxx-xxxx-xxxx-#{card_number[-4..-1]}"
  end
  
  def more_valued_than?(other)
    total_spent > other.total_spent
  end
  
  protected
  
  attr_reader :total_spent
  
  private
  
  attr_reader :card_number
end

alice = CustomerRecord.new("Alice", "4321-1234-3231-9873", 1245)
bob = CustomerRecord.new("Bob", "4829-2341-8392-9182", 1200)

puts alice.name
puts bob.name

puts alice.card_details
puts bob.card_details

puts bob.more_valued_than?(alice) # false
puts alice.more_valued_than?(bob) # true

bob.total_spent # raises NoMethodError
alice.card_number # raises NoMethodError
```

