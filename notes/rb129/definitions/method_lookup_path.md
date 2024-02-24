## Method Lookup Path

"When you call a method... Ruby has a distinct lookup path that it follows each time a method is called... We can use the `ancestors` method on any class to find out the method lookup chain"

```ruby
module Speak
  def speak(sound)
    puts "#{sound}"
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

puts "---GoodDog ancestors---"
puts GoodDog.ancestors
puts "---HumanBeing ancestors---"
puts HumanBeing.ancestors
```

* When a method is called, Ruby has a distinct method lookup path it follows to resolve the invocation. This is an ordered list of classes and modules Ruby will search for a method call on an instance of a given class
* The `Module#ancestors` method returns an array containing the method lookup path

"he method lookup path is the order in which classes are inspected when you call a method"

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

class Animal
  include Walkable
  
  def speak
    "I'm an animal, and I speak!"
  end
end

class GoodDog < Animal
  include Swimmable
  include Climbable
end

puts "---Animal method lookup---"
p Animal.ancestors # [Animal, Walkable, Object, Kernel, BasicObject]

puts "---GoodDog method lookup---"
p GoodDog.ancestors # [GoodDog, Climbable, Swimmable, Animal, Walkable, Object, Kernel, BasicObject]
```

"This means that when we call a method of any `Animal` object, first Ruby looks in the `Animal` class, then the `Walkable` module, then the `Object` class, then the `Kernel` module, and finally the `BasicObject` class"

"This tells us that the order in which we include modules is important. Ruby actually looks at the last module we included *first*. This means that in the rare occurrence that the modules we mix in contain a method with the same name, the last module included will be consulted first. The second interesting thing is that the module included in the superclass made it on to the method lookup path. That means that all `GoodDog` objects will have access to not only `Animal` methods but also methods defined in the `Walkable` module, as well as all other modules mixed in to any of its superclasses."

* Ruby first checks the class of the object on which a method is called, then any included modules in reverse order of inclusion. Then Ruby checks the superclass. This repeats until the end of the method lookup chain
* A custom class defined without explicit inheritance from a superclass will subclass from the `Object` class. This means most lookup chains will end with searching `Object`, then the `Kernel` module, then finally `BasicObject`
* If Ruby cannot find a method definition for a method name after searching the method lookup path, a `NoMethodError` exception will be raised

* When there are multiple method definitions for a given method name in the lookup path, Ruby will execute the method definition in the class or module that is closest to the start of the lookup path. This is how a method defined in a superclass can be overridden in a subclass



**2:4: Method Lookup path**

"The method lookup path is the order in which Ruby will traverse the class hierarchy to look for methods to invoke."



**Definition**

* When an object receives a message, Ruby has a distinct method lookup path it follows to resolve the method invocation. The method lookup path is the order of the hierarchical chain of classes and modules Ruby will search for a definition of a method called on an object of a given class
* Ruby first looks for a method definition in the class of the object on which a method is called, then in any included modules in reverse order of inclusion. Then Ruby checks the superclass, then any modules included in the superclass, then the superclass of the superclass. This repeats until the end of the method lookup chain

**Implementation**

* When called on a class, the `Module#ancestors` method returns an array containing the classes and modules in the method lookup path for objects of that class in search order
* A custom class defined without explicit inheritance from a superclass will subclass from the `Object` class. This means most lookup chains will end with searching `Object`, then the `Kernel` module, then finally `BasicObject`

* If Ruby cannot find a method definition for a method name after searching the method lookup path, a `NoMethodError` exception will be raised

* When there are multiple method definitions for a given method name in the lookup path, Ruby will execute the method definition in the class or module that is closest to the start of the lookup path. This is how a method defined in a superclass can be overridden in a subclass
* A method definition can call the next method definition of the same name further up the inheritance hierarchy by calling the `super` method

**Benefits**

* Ruby's method lookup path is how Ruby implements dynamic dispatch, which facilitates polymorphism

