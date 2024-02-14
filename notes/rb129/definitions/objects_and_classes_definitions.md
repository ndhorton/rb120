**<u>Classes</u>**

**Definition**

* Classes define objects
*  A class outlines what an object should be made of and what it should be able to do
* Classes are like molds and objects are the things produced from these molds
* A class can be thought of as the blueprint for its objects
* The production of a new object from a class is called instantiation; any given object is an instance of its class
* Classes define the attributes and behaviors of its instances
* Behaviors defined in the class predetermine the instance methods available to instances that class
* Attributes defined in the class predetermine the potential instance variables available to instances of that class

**Implementation**

* A class is defined with the keyword pair `class...end` and is named using PascalCase
* Calling the class method `new` on a class instantiates a new object of that class (calling the instance method `initialize` on the new instance, forwarding any arguments passed to `new`)
* Classes can inherit from a single superclass and include as many mixin modules as you wish. Objects instantiated from the class will have access to behaviors and constants defined in the superclass and any mixin modules
* A class can have its own behaviors (class methods)
* A class can share some state with its objects through class variables
* We can find the class of an object by calling the `Kernel#class` method on the object

**Benefits**

* Classes permit modeling relationships between types of objects in a hierarchical inheritance structure, facilitating polymorphism
* Classes allow us to create many objects with shared behaviors but their own unique states from a single class definition, making it easier to organize code clearly and facilitating code reuse (DRY)



**<u>Objects</u>**

**Definition**

* Objects consist of state and behaviors
* Everything in Ruby that can be said to contain a value is an object (this does not include variables, since variables simply point to objects)
* Ruby uses objects to achieve encapsulation
* every object has its own distinct state, tracked by its distinct instance variables
* all objects instantiated from the same class have the same behaviors, appropriate to the kinds of data associated to the object
* All Ruby objects are instances of a class

**Implementation**

* Objects are commonly instantiated by calling the `new` method on the appropriate class (and, for some core classes, through literal notation)
* Client code can call a method on an object using the dot operator `.`
* Attributes can be thought of as the various characteristics that an object is made of
* An object's state tracks the attributes defined in its class, and an object's instance variables keep track of its state

**Benefits**

* Objects facilitate  encapsulation, serving as containers for data that can be manipulated and changed through a public interface without affecting the entire program
* Objects allow a program to become the interaction of and communication between many small parts
* Objects thus allow us to model entities ('nouns') from the problem domain. An object's public interface can describe its available actions in terms of the behavior of entities in the problem domain. This facilitates greater levels of abstraction, allowing us to create more complex programs that are easier to maintain and scale
