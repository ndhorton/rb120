**<u>Method Lookup Path</u>**

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

