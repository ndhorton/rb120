## **Encapsulation, Polymorphism, Inheritance** ##

<u>**Encapsulation**</u>

**Definition**

* Encapsulation is hiding pieces of functionality from the rest of the code base. Encapsulation separates interface from implementation
* Encapsulation is hiding the internal representation of an object from client code. Encapsulation lets us only expose the methods and properties that users of the object need to access.

**Implementation**

* In Ruby, encapsulation is achieved by the creation of objects. 
* Objects can encapsulate state via their instance variables
* Objects expose interfaces through which the rest of the program (including other objects) can interact with them. An object's interface is its public instance methods
* Method access control encapsulates implementation details, a class's private and protected methods, and only exposes attributes and methods through a public interface: the class's public methods

**Benefits**

* Encapsulation is a way to protect persistent data from being manipulated or changed without deliberate intent. This protects against the problems associated with global program state
* Encapsulation sections off data and functionality, allowing the program to become the interaction of small, discrete parts. This permits the programmer to think at a higher level of abstraction, making it easier to develop larger and more complex programs
* Encapsulation reduces code dependency. Client code only needs to know about the public interface of an object. As long as the interface stays consistent, the implementation of a class can change significantly without affecting client code.



<u>**Polymorphism**</u>

**Definition**

* Polymorphism is the ability for different types of data to respond to a common interface
* 'Poly' means 'many' and 'morph' means 'form'
* Polymorphism refers to the ability of different types of object to respond to the same method invocation, often with a different method implementation
* Polymorphism means that we can call a method on two or more objects and, as long as those objects expose a method with that name, we don't have to worry about what type of object is calling the method.
* Polymorphism is made possible by designing data types so that a selection of different types can be treated as though they were the same type.
* Polymorphism is when objects of different classes respond to a method invocation of the same name. In Ruby, this can happen through class inheritance, mixin modules, and duck-typing

**Implementation**

* One way that polymorphism is achieved in Ruby is through class inheritance. A subclass inherits the behavior of a superclass and exposes the same interface, even if the interface is extended, and even if the implementation is overridden
* The sharing of behaviors among classes via the inclusion of mixin modules is another form of polymorphism through inheritance. This form of polymorphism is sometimes called interface inheritance. Through inheriting the interface provided to their classes by a shared mixin module, objects of different types can respond to a common interface.
* Duck typing is a form of polymorphism in which objects of unrelated types can be used polymorphically.
* Duck typing is not concerned with the class or type of an object, but only if it behaves appropriately for the task at hand. If an object quacks like a duck, we can treat it like a duck
* Duck typing can be seen to occur when objects of unrelated classes respond to the same method name. Similarly, one can implement a method with the same name for the same purpose in two or more unrelated classes in order to facilitate polymorphism through duck typing
* Duck typing is an agnosticism towards the type of an object passed to a piece of client code. 
* So long as the objects respond to the same method name given with the same number of arguments, they belong to the appropriate category of object

**Benefits**

* Polymorphism makes programs less fragile and more flexible by loosening the coupling between a piece of code and the specific details of the type of data it expects. Client code does not need to have knowledge of the representation of the object it is operating on or, in Ruby, even of the type. This reduces code dependencies 
* The ability of different types of object to respond to a common interface can reduce dependencies and improve the maintainability and extensibility of programs



<u>**Class Inheritance**</u>

**Definition**

* Class inheritance is when a class inherits behavior from another class
* A class can only have one superclass but can have many subclasses, forming a tree-like class hierarchy
* A class inheritance subclass-superclass relationship represents an "is-a" relationship. The subclass is a specialization of the type of the superclass.

**Implementation**

* We use the `<` symbol to signify that the class we are defining subclasses an existing class

* Subclasses can override a method defined inherited from a superclass with a new definition
* Inside the overriding subclass method definition, the reserved word `super` can be used to call the method with the same name in the superclass (or the nearest class or module in the method lookup path). Used without parentheses, `super` passes all arguments passed to the overriding method through to the superclass method. Used with empty parentheses `super()` passes no arguments. You can also explicitly pass arguments through to the superclass method in the parentheses `super(arg1, arg2)` like a regular method call.
* `super` is often used with `initialize` methods, since subclasses often specialize their superclass in a way that requires more attributes

**Benefits**

* Class inheritance allows us to model hierarchical relationships, allowing the programmer to work at the problem domain level of abstraction if the entities in the problem domain already have a hierarchical relationship
* Class inheritance allows us to extract common behavior from classes and move it to a superclass. This facilitates code reuse and means changes can be made in one place rather than many
* Class inheritance facilitates polymorphism



----

**What is OOP and why is it important?**

* OOP is a programming paradigm that aims to solve the difficulties of building and maintaining large and complex software systems
* As procedural programs grew in scale and complexity, a program could become a web of closely-knotted dependencies, making it difficult to change one part of the codebase without adverse effects rippling out to many other parts
* OOP attempts to obviate this problem by providing a way to create containers for data that can be changed or manipulated without affecting other parts of the program, and a way to section off areas of code from the rest of the program so that the program becomes the orchestrated interaction of small, discrete parts, rather than a mass of dependency
* OOP thus attempts to reduce dependencies and avoid the problems of shared state in large, complex software projects
* OOP also allows the programmer to think on a higher level of abstraction. Objects can represent domain-level 'nouns' or entities, and objects can act in ways that correspond to the domain-level behaviors the programmer wishes to model
* In Ruby, this is achieved through a combination of encapsulation and polymorphism, facilitated by inheritance.

-----

**Duck Typing**

* Duck typing is a form of polymorphism in which objects of unrelated types can be used polymorphically.
* Duck typing is not concerned with the class or type of an object, but only if it behaves appropriately for the task at hand
* If an object quacks like a duck, we can treat it like a duck
* Duck typing can be seen to occur when objects of unrelated classes respond to the same method name
* Duck typing is a form of polymorphism. So long as the objects respond to the same method name given with the same number of arguments, they belong to the appropriate category of object.
* With duck typing, there is no check as to what type of object the client code is dealing with; rather, the object must only have the behavior necessary for the task at hand.  The object needs only have a public method of the appropriate name that performs an action compatible with the purposes of the client code in order to be the right category of object. This is polymorphism through duck typing.

* In Ruby, as long as an object exposes the right public methods and behaves appropriately in response to those methods being invoked, the client code does not need to concern itself with he type of the object. This agnosticism towards the type of an object passed to a piece of client code is known as duck typing. If an object walks like a duck and quacks like a duck, it can be treated as a duck.
* While polymorphic behavior can be achieved in Ruby through class inheritance, and through the inclusion of mixin modules, duck typing means that objects that do not share any significant ancestors can still be treated polymorphically if they expose the appropriately named method (and as long as the return value or side effects of that method fit the purposes of the client code).
* Duck typing can reduce dependencies in a piece of code. Client code does not need to have knowledge of the type of the object it is operating on or of the implementation details of the type. This can reduce code fragility and makes it easier to introduce new types of objects into an existing program without changing every method it might be passed to.