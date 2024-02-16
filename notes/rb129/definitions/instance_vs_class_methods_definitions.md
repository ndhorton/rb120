**<u>Instance methods vs class methods</u>**

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

  











