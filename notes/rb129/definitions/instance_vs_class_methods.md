Instance methods vs. class methods

### Ruby OOP book ###

"We use classes to create objects. When defining a class, we typically focus on two things: *state* and *behaviors*... Behaviors are what objects are capable of doing"

An object acquires its instance methods from the definition of the class of which it is an instance as well as from inheritance.

"Even though they're tow different objects, both are still objects (or instances) of class `GoodDog` and contain identical behaviors... We define these behaviors as instance methods in a class. Instance methods defined in a class are available to objects (or instances) of that class"

You could say that the class from which an object is instantiated predetermines the behaviors it can perform. More specifically, the class predetermines the instance methods the object has access to. (This predetermination is partly due to the ancestors of the class, whether superclass relations or mixins)

* Instance methods are the behaviors an object is capable of doing
* The instance methods an object has access to are predetermined by the definition of its class. 
* Every object (instance) of a class will be able to call the instance methods defined in the class.

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#{@name} says meow!"
  end
end

tom = Cat.new("Tom")
tom.speak # Tom says meow!
```

* We define an instance method within a class definition by using the `def` keyword followed by the name of the method and ending with the `end` keyword

"In our instance methods, which is what all the methods are so far, we have access to instance variables"

* Instance methods can access instance variables
* An instance method has access to the instance variables of the object on which the method is called

Since we are not thinking about class instance variables yet, the simpler 'instance methods can access instance variables' is probably best

"We can expose information about the state of the object using instance methods"

* Since instance methods can access instance variables, they can be used to expose and change the state of an object to client code. Instance methods that reference or set a single instance variable are called getter and setter methods

"Thus far, all the methods we've created are instance methods. That is, they are **methods that pertain to an instance or object of the class**. There are also class level methods, called **class methods**. Class methods are methods we can call directly on the class itself, without having to instantiate any objects."

* Instance methods pertain to an instance (or object) of a class. They are called on an instance of the class (either explicitly from client code, or implicitly (or on `self`) within another instance method definition of the class



* Class methods are methods we can call directly on the class itself

```ruby
class GoodDog
  def self.what_am_i # class method definition
    "I'm a GoodDog class!"
  end
end

puts GoodDog.what_am_i # "I'm a GoodDog class!"
```

"When defining a class method, we prepend the method name with the reserved word `self.`... Then when we call the class method, we use the class name `GoodDog` followed by the method name, without even having to instantiate any objects"

"Within a class... `self`, outside of an instance method, references the class and can be used to define class methods. Therefore, if we were to define a `name` class method, `def self.name=(n)` is the same as `def GoodDog.name=(n)`, in our example"



* To define a class method, we use the `def...end` keyword pair within a class definition but we prepend `self.` (the keyword `self` followed by the dot operator) to the name of the method (this is because `self`, within a class definition and outside an instance method definition, references the class)
* When calling a class method we call it on the class name using the dot operator
* We do not need to instantiate any objects to call class methods
* We cannot call a class method on an instance of that class

"Class methods are where we put functionality that does not pertain to individual objects."

"Objects contain state, and if we have a method that does not need to deal with states,  then we can just use a class method"

* Class methods contain functionality that does not pertain to individual objects
* Objects contain state, so class methods are often used where we do not need to deal with states

So, if a class method were to be primarily concerned with mutating the state of an object passed in as argument, it might make sense for that functionality to be an instance method of that object

On the other hand, if a method simply needs to manipulate and return a value, for instance, like a mathematical function, or a unit conversion, it might make sense for that to be a class method

However, there may be state which it is appropriate to keep track of at the class level using a class variable, and since this state tracks a class level detail it makes sense to reference it using a class method.

"This is an example of using a class variable and a class method to keep track of a class level detail that pertains only to the class, and not to individual objects"

```ruby
class Cat
  @@number_of_cats = 0
  
  def initialize
    @@number_of_cats += 1
  end
  
  def self.total_number_of_cats
    @@number_of_cats
  end
end

puts Cat.total_number_of_cats # => 0

tom = Cat.new
salem = Cat.new
felix = Cat.new

puts Cat.total_number_of_cats # => 3
```

* Class methods can also be used in conjunction with class variables in order to keep track of information about the class that does not pertain to any particular object

"**Inheritance** is when a class **inherits** behavior from another class. The class that is inheriting behavior is called the subclass and the class it inherits from is called the superclass"

"We use inheritance as a way to extract common behaviors from classes that share that behavior, and move it to a superclass"

* Class inheritance means that a subclass inherits behavior from a superclass

* Instance method and class method definitions are inherited by subclasses.
* Instance methods defined in the superclass can be called on an instance of the subclass. Class methods defined on the superclass can be called on the subclass
* Instance methods defined in a mixin module can be mixed in to a class with the `include` method. Class methods defined on the module will not be mixed in

Instance methods can be mixed in from a module. The way to do this for class methods is much more complicated and I shouldn't get into it at this level. But you can mix in class methods defined in a module (though they have to be defined in a nested module as though they were instance methods)





**Definition**

* The instance methods an object has access to are predetermined by the definition of its class. Every object (instance) of a class will be able to call the instance methods defined in the class.
* Class methods are methods defined on the class that we call directly on the class itself
* We do not need to instantiate any objects to call class methods
* We cannot call a class method on an instance of that class
* We cannot call an instance method directly on a class
* Only instance methods can access instance variables
* Instance methods are used to reference and manipulate the state of an individual object (instance)
* Instance method and class method definitions are inherited by subclasses.

**Implementation**

* We define an instance method within a class definition by using the `def` keyword followed by the name of the method and ending with the `end` keyword
* To define a class method, we use the `def...end` keyword pair within a class definition but we prepend `self.` (the keyword `self` followed by the dot operator) to the name of the method (this is because `self`, within a class definition and outside an instance method definition, references the class)
* When calling an instance method we call it on an instance (object) using the dot operator
* When calling a class method we call it on the class name using the dot operator
* Instance methods defined in the superclass can be called on an instance of the subclass.
* Class methods defined on the superclass can be called on the subclass
* Instance methods defined in a mixin module can be mixed in to a class with the `Module#include` method. Class methods defined on the module will not be mixed in by `include`

**Benefits**

* Since instance methods can access instance variables, they can be used to reference or change the state of an object

* Class methods are often used where we do not need to deal with states

* However, class methods can be used in conjunction with class variables in order to keep track of information about the class that does not pertain to the state of any particular instance (object).

  











