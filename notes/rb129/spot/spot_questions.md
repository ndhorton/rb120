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

So to take this as an example: it is necessary to read the questions ahead to understand the scope of this question in the exam. The following questions include:

**Explain two different ways to implement polymorphism**

So here, I think it is asking about inheritance and mixin modules

**How does polymorphism work in relation to the public interface?**

Here, I think, it's ambiguous, since the next question is on duck typing. So you could end this question pointing in that direction. There probably will be overlap if you have several questions on a single topic. It's just not going to be possible to judiciously avoid repetition. Also use the SPOT links as clues



**What is duck typing? How does it relate to polymorphism - what problem does it solve?**

Duck typing applies the 'duck test' -- "if it quacks like a duck, it's a duck" -- to the type of objects. What this means is that Ruby code can take a behavioral approach to whether an object is of the right type for the task at hand. So if an object is passed to a method, that method can can





Polymorphism is the ability of objects of different types to respond to a common interface,

 even if the implementation is different. 'Poly' means 'many' and 'morph' means 'forms', and this refers to the fact that many types of data can be used interchangeably by a given piece of client code. This means that a method or block that invokes a method with a certain name on its arguments will work with any objects that expose a method with that name.





In Ruby, there are three main ways that polymorphic structure can be applied to classes: class inheritance, mixin modules, and duck typing. A class can share methods with other classes through inheriting them by subclassing a superclass. A class can share methods with other classes by mixing in a mixin module shared by other classes. These inherited or mixed in methods can be overridden with a specialized implementation, but, as long as it behaves appropriately, the method can still be used polymorphically.

Ruby's duck typing means that completely unrelated classes (which share neither a superclass nor a mixin module) can expose a public method of a certain name with a certain number of parameters and be used polymorphically. A piece of polymorphic client code does not need to check the type of the objects passed to it at all, but can call a method with a certain number of arguments and so long as the object responds appropriately then the object is of the right category. Simply exposing the necessary interface for a given situation places the object in the right category with respect to duck typing. If an object quacks like a duck, we can treat it like a duck. 

Polymorphism permits a reduction of code dependencies since client code can remain agnostic about the type of an object so long as it exposes a certain interface. This shift