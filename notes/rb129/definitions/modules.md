## Modules and their uses ##

"Another way to apply polymorphic structure to Ruby programs is to use a `Module`"

"Modules are similar to classes in that they contain shared behavior. However, you cannot create an object with a module. A module must be mixed in with a class using the `include` method invocation. This is called a **mixin**. After mixing in a module, the behaviors declared in that module are available to the class and its objects

"Modules are another way to achieve polymorphism in Ruby. A **module** is a collection of behaviors this is usable in other classes via **mixins**. A module is "mixed in" to a class using the `include` method invocation. Let's say we wanted our `GoodDog` class to have a `speak` method but we have other classes that we want to use a `speak` method with too. Here's how we'd do it"

```ruby
# demonstrating mixin module way to achieve polymorphism
module Speak
  def speak(sound)
    puts sound
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!") # "Arf!"
bob = HumanBeing.new
bob.speak("Hello!")  # "Hello!"
```

"Note that in the above example, both the `GoodDog` object, which we're calling `sparky`, as well as the `HumanBeing` object, which we're calling `bob`, have access to the `speak` instance method. This is possible through "mixing in" the module `Speak`."



* Modules containing behaviors can be mixed in to one or more classes. This use of a module is known as a **mixin**. Once mixed in to a class, the behaviors contained in the module are available to the class (and its descendants)
* Mixin modules can be used to apply polymorphic structure to programs.
* Mixin modules are mixed in to a class using the `Module#include` method invocation at the class level

"Another way to DRY up your code in Ruby is to use **modules**. We've already seen a little bit of how to use modules, but we'll give a few more examples here."

"Extracting common methods to a superclass, like we did in the previous section, is a great way to model concepts that are naturally hierarchical. We gave the example of animals. We have a generic superclass called `Animal` that can keep all basic behavior of all animals. We can then expand on the model a little and have, perhaps, a `Mammal` subclass of `Animal`. We can imagine the entire class hierarchy to look something like the figure below."

```ruby
class Animal
  # behavior for all animals
end

class Fish < Animal
  # specialized Fish behaviors
end

class Mammal < Animal
  # specialized behaviors for all mammals
  def warm_blooded?
    true
  end
end

class Cat < Mammal
  # specialized Cat behaviors
end

class Dog < Mammal
  # specialized Dog behaviors
end
```

"This type of hierarchical modeling works, to some extent, but there are always exceptions. For example, we put the `swim` method in the `Fish` class, but some mammals can swim as well. We don't want to move the `swim` method into `Animal` because not all animals swim, and we don't want to create another `swim` method in `Dog` because that violates the DRY principle. For concerns such as these, we'd like to group them into a module and then *mix in* that module to the classes that require those behaviors."

```ruby
module Swimmable
  def swim
    "I'm swimming!"
  end
end

class Animal
  # behavior for all animals
end

class Fish < Animal
  include Swimmable

  # specialized Fish behaviors
end

class Mammal < Animal
  # specialized behaviors for all mammals
  def warm_blooded?
    true
  end
end

class Cat < Mammal
  # specialized Cat behaviors
end

class Dog < Mammal
  include Swimmable
 
  # specialized Dog behaviors
end

sparky = Dog.new
neemo = Fish.new
paws = Cat.new

sparky.swim # "I'm swimming!"
neemo.swim # "I'm swimming!"
paws.swim # raises NoMethodError
```

* Class inheritance is good for modeling naturally hierarchical class relationships; each subclass is a specialized type with respect to its superclass. Mixin modules can be used for polymorphic structure when there are behaviors that need to be shared among classes that cannot be related in this way
* Even when classes can be related in terms of a hierarchy, there may be some behavior that needs to be shared by classes that already subclass as part of the hierarchy but whose superclasses have descendants that should not share that behavior. In this situation, a mixin module can be used to distribute shared behavior, since Ruby does not permit multiple inheritance

"Now you know the two primary ways that Ruby implements inheritance. Class inheritance is the traditional way to think about inheritance: one type inherits the behaviors of another type. The result is a new type that specializes the type of the superclass. The other form is somethimes called **interface inheritance**: this is where mixin modules come into play. The class doesn't inherit from another type, but instead inherits the interface provided by the mixin module. In this case, the result type is not a specialized type with respect to the module"

So it's easy to get confused into thinking that **interface inheritance** is used here to refer to all the various ways mixin modules can be used. But inheriting an interface (i.e. public methods) is specifically relevant to polymorphism: the ability of objects of different types to respond to a common interface. Once way of sharing an interface is to inherit it via mixin modules. Thus interface inheritance. This is particularly relevant to the way mixin modules are often used in Ruby to encapsulate public-facing abilities like `Comparable`, `Enumerable` etc. As an aside, these modules both require that the including class implement a method with a certain name (`<=>`,`each`) with corresponding behaviors. That would be an example of duck-typing.

* Mixin modules can be used for interface inheritance. Here, a class inherits an interface from a module, but the class is not a specialized type with respect to the module



* "You can only subclass (class inheritance) from one class. You can mix in as many modules (interface inheritance) as you'd like
* If there's an "is-a" relationship, class inheritance is usually the correct choice. If there's a "has-a" relationship, interface inheritance is generally a better choice. For example, a dog "is an" animal and "has an" ability to swim
* You cannot instantiate modules. In other words, objects cannot be created from modules"



* Whereas a class can only subclass from one superclass, you can mix in as many modules as you'd like
* Class inheritance models an "is a " relationship; the type of the subclass is specialized with respect to the type of the superclass. Interface inheritance through mixin modules models a "has a " relationship; the class has a behavior or ability provided by the module. The class is not a specialization of the module
* Modules cannot be instantiated



So when you mix in a module to provide publicly accessible abilities for a module we can call this interface inheritance (though the GoF mean something more specific by this - i.e., a class formally implementing a formally-specified interface, or what C++ does with virtual functions and abstract classes, at a stretch)

"We've already seen how modules can be used to mix-in common behavior into classes. Now we'll see two more uses for modules."

1. Interface inheritance
2. Namespacing
3. Container (for module methods)

"The first use case we'll discuss is using modules for **namespacing**. In this context, namespacing means organizing similar classes under a module. In other words, we'll use modules to group related classes. Therein lies the first advantage of using modules for namespacing. It becomes easy for us to recognize related classes in our code. The second advantage is it reduces the likelihood of our classes colliding with other similarly named classes in our codebase. Here's how we do it:"

```ruby
module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end
  
  class Cat
    def say_name(name)
      p "#{name}"
    end
  end
end

buddy = Mammal::Dog.new
kitty = Mammal::Cat.new
buddy.speak("Arf!") # Arf!
kitty.say_name("Kitty") # Kitty
```

"We call classes in a module by appending the class name to the module name with two colons"

* Modules can be used for namespacing to group similar classes under a namespace
* To instantiate a namespaced class, we use the `::` namespace resolution operator after the module name and append the name of the class: `ModuleName::ClassName.new`

"The second use case for modules we'll look at is using modules as a **container** for methods, called module methods. This involves using modules to house other methods. This is very useful for methods that seem out of place within your code."

```ruby
module Mammal
  # omitted for brevity
  def self.some_out_of_place_method(num)
    num ** 2
  end
end

# preferred way to call
Mammal.some_out_of_place_method(8) # => 64

# also possible but not preferred
Mammal::some_out_of_place_method(16) # => 256
```

"Defining methods this way within a module means we can call them directly from the module"

* Modules can be used as a container for methods defined on the module itself. Such methods are sometimes called **module methods** and are called directly on the module using the dot operator

**2:10: Lecture: Modules**

"One of the limitations of class inheritance in Ruby is that a class can only directly sub-class from one super class. We call this **single inheritance**. In some situations, this limitation makes it very difficult to accurately model the problem domain. For example... [gives Fish/Dog example]"

* Ruby only allows single inheritance; a class can only have one superclass. However, Ruby permits a class to mix in an arbitrary number of mixin modules, providing the benefits of multiple inheritance with less logical complexity





**Definition**

* Modules allow us to group together a logical set of behaviors, classes, or other modules, depending on how we intend to use the module
* Mixin modules can be used to apply polymorphic structure to programs by grouping behaviors that are then mixed in to multiple classes. This is sometimes called interface inheritance
* Modules can be used for namespacing to group similar classes or other modules under a namespace
* Modules can be used as a container for methods defined on the module itself. Such methods are sometimes called **module methods** and are called directly on the module using the dot operator
* Unlike classes, modules cannot be instantiated

**Implementation**

* Mixin modules can be used for interface inheritance. Class inheritance models an "is a " relationship; the type of the subclass is specialized with respect to the type of the superclass. Interface inheritance through mixin modules models a "has a " relationship; the class has a behavior or ability provided by the module. The class is not a specialization of the module
* Modules containing instance method definitions can be mixed in to one or more classes. This use of a module is known as a **mixin**. Once mixed in to a class, the behaviors contained in the module are available to the class and its descendants
* If there's an "is-a" relationship, class inheritance is usually the correct choice. If there's a "has-a" relationship, interface inheritance is generally a better choice. For example, a dog "is an" animal and "has an" ability to swim
* Mixin modules are mixed in to a class using the `Module#include` method invocation at the class level

* To instantiate a class that is in the namespace of a module, we use the `::` namespace resolution operator after the module name and append the name of the class: `ModuleName::ClassName.new`

**Benefits**

* While class inheritance is good for modeling naturally hierarchical relationships, mixin modules can provide polymorphic structure when there are behaviors that need to be shared among classes that cannot be related hierarchically
* Even when classes can be related in terms of a hierarchy, there may be some behavior that needs to be shared by classes that already subclass as part of the hierarchy but whose superclasses have descendants that should not share that behavior. In this situation, a mixin module can be used to distribute shared behavior on a class-by-class basis. Ruby only allows single inheritance; a class can only have one superclass. However, Ruby permits a class to mix in an arbitrary number of mixin modules, providing the benefits of multiple inheritance with less logical complexity
* Namespacing prevents name collisions in large software projects
* Container modules for module methods provide a way to group methods that do not logically belong in any particular class
