**What is OOP and why is it important?**

 Object Oriented Programming is a programming paradigm intended to solve the problems of building and maintaining large, complex software projects. OOP provides facilities such as encapsulation, inheritance, and polymorphism in order to reduce code dependencies, avoid the problems of global state, and improve the scalability and maintainability of code

As non-OOP programs grow in scale and complexity, there can be a tendency for a program to become a mass of dependencies, with every part of the code base dependent on many other parts. This can make programs difficult to maintain, since any change or addition to one part could cause a ripple of adverse effects throughout

OOP attempts to solve these problems by providing ways to section off areas of code, creating containers for data and functionality that can be changed without affecting every other part of the code base. A program becomes the orchestrated interaction of small parts rather than a mass of dependency.

By abstracting away implementation details behind interfaces, OOP allows the programmer to think at a higher level of abstraction in terms of the 'nouns' of the problem domain, in terms of real world objects. OOP designs can thus help conceptually to break down and solve complex problems

OOP features such as encapsulation, polymorphism, and inheritance, can also facilitate code reuse in a greater variety of contexts



* Reduces code dependencies

* Avoids problems of global state

* Allows programmer to think at a higher level of abstraction, in terms of nouns modeling entities at the problem domain level, to think in terms of real world objects. This helps break down complex problems

* Allows for flexible extension of existing code and the reuse of code in different contexts



****

**What is encapsulation?**

Encapsulation is hiding functionality from the rest of the code base behind a publicly exposed interface, and protecting data from being changed without deliberate intent.

In Ruby, encapsulation is achieved by the creation of objects which client code can only interact with via their public interfaces. Objects encapsulate state, tracked by their instance variables, as well as concealing parts of their internal functionality, and selectively expose public methods through which client code can interact with them.

Method access control allows us to encapsulates certain methods as private or protected, and expose other methods publicly, in order to conceal internal functionality and prevent problematic manipulation of an object's state.

Hiding functionality in this way reduces code dependencies. Client code only needs to know how to use an object's public interface, and is therefore not dependent on the implementation, which can be changed so long as the existing interface remains constant.

Encapsulation of persistent state in objects obviates the problems of shared or global state.

This sectioning off of data and functionality into objects permits a greater level of abstraction, allowing the programmer to think at the problem domain level.

* hiding pieces of functionality and the internal representation of an object from the rest of the code base
* a form of data protection, prevent unintentional or problematic changes to state
* In Ruby, encapsulation is achieved by creating objects that expose interfaces
* Method access control offers us a way to limit what internal functionality is available as part of an object's interface, preventing client code from changing the state of an object in problematic ways
* Reduces code dependency, since client code only needs to know about the public interface of an object. This leaves us free to alter the implementation without breaking existing code
* The encapsulation of persistent state in objects avoids the problems of global state



-----

**How does encapsulation relate to the public interface of a class?**

Encapsulation lets us conceal the internal representation and implementation of an object while exposing a public interface through which client code can interact with objects of the class. In Ruby, all instance variables are hidden within the object and can only be accessed from the outside via the public interface. Method access control is what lets us determine which of a class's methods remain hidden (`private` or `protected`) and which are exposed as `public` to form the interface to the class.

This means that we can simplify usage of the class, and protect data from accidental manipulation, by making public only those methods that are strictly necessary and concealing as many as possible, especially setter methods for instance variables.

----

**What is an object?**

An object is an instance of a class. An object encapsulates its own unique state and exposes the interface determined by the class. While the attributes and behavior of an object are predetermined by the class, the state of an object, the set of values tracked by its instance variables, is unique to the object. Objects can model 'nouns' or entities from the problem domain with the behaviors expected of those entities, and thus allow the programmer to think on a higher level of abstraction, in terms of the problem domain rather than in terms of implementation details.

----

**What is a class?**

A class acts as a blueprint or template for objects of the class. The class predetermines the attributes and behavior of its instances.

Classes are defined using the keyword pair `class...end` and are named in PascalCase. 

Objects are instantiated from the class using the class method `new`, which in turn calls the constructor instance method `initialize` which sets the initial state of the new individual object. 

----

**What is polymorphism?**

'Poly' means 'many' and 'morph' means 'forms'. Polymorphism is the ability for objects of different types to respond to a common interface, often, though not always, with different implementations. So if a method invokes a method with a particular name on the objects passed to it as arguments, the argument objects can be of any type so long as they expose a public method of that name with the correct number of parameters.

Polymorphism allows for flexibility, facilitates code reuse in new contexts, and increases the maintainability of code.

**Explain two different ways to implement polymorphism**

There are two main ways to implement polymorphic structure in Ruby: through inheritance and through duck typing.

Both class inheritance and interface inheritance via mixin modules allow us to share method definitions between classes. A subclass inherits method definitions from its superclass, and classes that mix in the same mixin module share the methods defined in that module. Subclasses and classes that mix in modules can override the inherited methods, providing a new implementation for the same interface.

To implement polymorphism through duck typing, we can simply define methods of the same name (and with the same number of parameters) in two or more completely unrelated classes, which share neither a common superclass nor any mixin modules. Ruby allows these objects of totally different types to be passed to a piece of client code and to respond to the same method invocation. As long as the objects respond appropriately to the same method invocation to accomplish the task at hand, Ruby considers them of the correct category. The only type check is behavioral: whether they respond to the method call. If an object quacks like a duck, it can be treated as a duck.

**How does polymorphism work in relation to the public interface?**

Since polymorphism is the ability of objects of different types to respond to a common interface, the design of the public interface of a class is key to the overall polymorphic structure of a program. In order to be used polymorphically, objects of different classes need to expose public methods of the same name and with the same number of parameters.

Classes may inherit part of their public interface through class inheritance, or through interface inheritance via mixin modules. They may take advantage of duck typing to implement public methods with the same name and number of parameters as other classes that are not related to them via inheritance. For their objects to be used polymorphically, it is only necessary that classes share a common subset of their public interfaces, i.e. the public methods necessary for the method invocations made by the polymorphic client code.

**What is duck typing? How does it relate to polymorphism - what problem does it solve?**

Duck typing means that a given piece of code is not concerned with the class of an object passed to it, only with whether that object has the right behavior. If an object quacks like a duck, it can be treated as a duck. Which is to say, if an object has an appropriate public method with the right name, taking the right number of arguments, for the task at hand, duck typing considers it to be in the right category of object. There is no check made on the class of the object before the method is called at runtime.

Duck typing is a form of polymorphism in which objects of completely unrelated types can be used polymorphically by client code. To implement polymorphic structure through duck typing, we can simply define in two or more unrelated classes the public methods with the names and parameter lists that are required by the polymorphic client code. Of course, in addition to having the right name and parameters, the method needs to behave appropriately to the polymorphic situation for there there to be meaningful polymorphic behavior.

While polymorphic behavior can be implemented through class inheritance hierarchies, or through interface inheritance via mixin modules, duck typing offers a greater flexibility and maintainability. A new class can be created and have its objects be used by existing code simply by exposing the right public method, without the class needing to be slotted into an inheritance hierarchy. Duck typing can also reduce code dependencies. A piece of client code needs to know less about the objects it is passed in order to use them successfully.

[example like that in the LS text, then one of adding a new class which exposes a method needed to be used in a client method] 

