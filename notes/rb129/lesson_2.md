## 2.6: Polymorphism

"Polymorphism refers to the ability of different object types to respond to the same method invocation, often, but not always, in different ways. In other words, data of different types can respond to a common interface. It's a crucial concept in OO programming that can lead to more maintainable code.

When two or more object types have a method with the same name, we can invoke that method with any of those objects. When we don't care what type of object is calling the method, we're using polymorphism. Often, polymorphism involves inheritance from a common superclass. However, inheritance isn't necessary."

* ability of different object types to respond to the same method invocation (ability of different types to respond to a common interface)
* often a result of class inheritance but not necessarily
* inheritance facilitates polymorphism by allowing us to inherit methods from a superclass, making it easy for logical hierarchies of types of object to respond to a common interface
* conversely we can override methods inherited from the superclass with methods of the same name, providing a different or more specific implementation for a common interface
* inheritance facilitates polymorphism by allowing the client code to work with various subclass objects while treating them all as objects of a more generic superclass by virtue of a shared, inherited public interface
* in addition to class inheritance, multiple classes can inherit a common interface through mixing in the same mixin module, even if the classes are not related through class inheritance
* can lead to more maintainable code

**client code** - the code that makes use of objects (as opposed to the class definition code for those objects)



Two main ways to achieve polymorphism in Ruby:

### **Polymorphism through Inheritance** ###

The interface for a class hierarchy permits the client code to send the same message to a range of subclass objects without having to know about or make allowances for the potentially very different implementations of their methods.

Polymorphism through inheritance allows us to either make use of a method further up the class inheritance hierarchy, or override that method in the subclass with a different or more specific implementation.

"In addition to using class inheritance to implement polymorphism, we can also use mixin modules to implement polymorphism via classes that are not related."



### **Polymorphism through duck typing**

"**Duck typing** occurs when objects of different *unrelated* types both respond to the same method name. With duck typing, we aren't concerned with the class or type of an object, but we do care whether an object has a particular behavior. *If an object quacks like a duck, then we can treat it as a duck.* Specifically, duck typing is a form of polymorphism. As long as the objects involved use the same method name and take the same number of arguments, we can treat the object as belonging to a specific category of objects."

"Duck typing is an informal way to classify or ascribe a type to objects. Classes provide a more formal way to do that."

Instead of requiring that an object be of a named type or class (or related to that named type by inheritance), duck typing means that an object can be considered of the right type so long as it responds to a given message and provides appropriate behavior for the context in which it is to be used. If an object quacks like a duck then it can be considered a duck. An object can be considered of the right type if it provides the right behavior for a given situation. This means that completely unrelated classes can be used to implement polymorphism. An advantage of duck typing would be that objects of a new class can be added to an existing polymorphic context without the need to restructure a class hierarchy to accommodate the new class, increasing maintainability by making it easier to add new features without breaking existing dependencies.

This would solve the problem of adding objects of a new class to an existing polymorphic context; duck typing means there is no need to restructure an existing class hierarchy to accommodate the new class, increasing maintainability by making it easier to add new features without breaking existing dependencies. The only firm requirement in this situation is that the new class expose the behaviors appropriate to the client code.

"Note that merely having two different objects that have a method with the same name and compatible arguments doesn't mean that you have polymorphism. In theory, those methods might be used polymorphically, but that doesn't always make sense... Unless you're actually calling the method in a polymorphic manner, you don't have polymorphism. In practice, polymorphic methods are intentionally designed to be polymorphic; if there's no intention, you probably shouldn't use them polymorphically"



## 2:6 Encapsulation ##

"Encapsulation lets us hide the internal representation of an object from the outside and only expose the methods and properties that users of the object need."

**internal representation** - state

"We can use **method access control** to expose these properties and methods through the public (or external) interface of a class; its public methods"

So encapsulation means to hide an object's state from client code and control access to the object's state and pieces of functionality by exposing a limited public interface -- the object's public methods. In Ruby, an object's instance variables -- which track an object's state -- are hidden from client code unless intentionally exposed by a public method. Methods concerned with implementation of behavior can themselves also be hidden from client code through the use of method access control, specifically access modifier methods `Module#private` and `Module#protected`. This way, we have fine-grained control over how client code can access the internal representation of an object and the object's functionality.

The public interface of an object should be as simple as possible and so there should be as few public methods as possible; this simplifies use of the class and minimizes the likelihood of accidentally modifying the object's state.

* encapsulation permits the state of an object to be hidden from direct manipulation by client code
* encapsulation facilitates the separation of an object's interface from its implementation by permitting control over which pieces of functionality are publicly exposed
* encapsulation promotes safety from accidental data modification
* encapsulation helps minimize dependencies in large codebases, reducing implementation complexity while also facilitating more ambitious, complex projects

## 2:8 Optional Reading: A Conceptual Model ##

"By state, we mean the collection of all the instance variables belonging to the object"

"Instance variables keep track of an object's state. More precisely, instance variables keep track of information about an object's state. For example, the `@name` instance variable belonging to our `r2d2` Robot object references the value `"R2D2"`. This piece of data or information is what comprises the state of an object, and is what the `@name` instance variable is tracking. It is unique from the values associated with the `@name` instance variable belonging to our other Robot object, `c3p0`."

state - collection of instance variables

instance variables - track state

state that is tracked - the references to objects containing values

attributes - the instance variables (and possibly accessor methods)

classes define the potential state of instances

state is individual to each instance

So at the class level, the naming of instance variables within instance methods defines the possible state an instance can have.

At the object level, instance variables track the actual and individual state of a particular instance.

Mechanically, an object has an instance variable once that instance variable is set. (This may happen when an object is created (in the `initialize` constructor method) or it may happen later and only if a particular instance method that sets that instance variable is called). Uninitialized instance variables are not technically part of an object yet (unlike in languages where data members are defined separately from instance methods)

"We can say that objects encapsulate state"

"An object's state must, and indeed does, track the attributes defined in the object's class and class inheritance hierarchy"

But in a sense, you could say that the state of an object where none of its possible (as defined by the class) instance variable have been initialized is different to the state of the object once initialized. After a method call has initialized an instance variable, it is now in a different state, possessing one instance variable with some sort of reference in it (even if that is now explicitly a reference to `nil`, since now the state is tracking that instance variable, which in turn is tracking `nil` (or any other object reference assigned to it)).

Major points (best part of article)

* Classes define an essence for objects, consisting of attributes and behaviors
* Objects are instantiated from classes and are predetermined by the class definition
* An object's state tracks the attributes of the class, and an object's instance variables keep track of its state
* Class behaviors predetermine the instance methods accessible to every particular object of the class
* Class attributes predetermine the instance variables pertaining to every particular object of the class
* Attributes may posses two contingent behavioral properties, and the contingency of these two properties is a precondition for encapsulation.

from Wikipedia: "In information technology and computer science, a system is described as **stateful** if it is designed to remember preceding events or user interactions; the remembered information is called the **state** of the system"

So an object has **state** because it has the capacity to remember the instantiation of instance variables and instance variables track the **state** of the object, the information it remembers and keeps track of. 

From Well-Grounded Rubyist: 

"Information and data associated with a particular object embodies the *state* of the object."

"We need to be able to do the following:

* Set, or reset, the state of an object (say to a Ticket, "you cost $11.99.")
* Read back the state (ask a ticket, "How much do you cost?")"

"The instance variable enables individual objects to remember state."

"Instance variables are only visible to the object to which they belong"

So the lifetime of an instance variable is the time between when an object initializes it and the end of the object's lifetime. It will remember state during that period.

"This property of instance variables -- their survival across method calls -- makes them suitable for maintaining state in an object"

So the relationship between class and object is that of a blueprint or definition of properties. An object instantiated from a class will have the behaviors (specifically instance methods) and capacity for state (specifically instance variables used in those methods) that are specified by that class's definition. An object's instance methods constitute the behavior it is capable of and an object's instance variables keep track of its state.

I keep getting confused about the terms 'state' and 'attributes' with respect to the relationship between classes and objects.

1. Is it accurate to say that a class defines the attributes of an object instantiated from that class?
2. Is it accurate to say that a class defines the behaviors an instance is capable of and the attributes it is capable of tracking?

(2) is particularly confusing. I understand that an object's state generally means the collection of values (or object references) referenced by an object's instance variables, but does it also refer to those variables themselves? The difficulty I'm having

From wikipedia entry for Class: "Object-oriented design uses the access specifiers in conjunction with careful design of public method implementations to enforce class invariants -- constraints on the state of the objects."

**class invariants** - constraints on the state of the instances of a class

## 2:9: Lecture: Collaborator Objects

"Classes group common behaviors and objects encapsulate state. The object's state is saved in an object's instance variables. Instance methods can operate on the instance variables. Usually, the state is a string or number. For example, a `Person` object's `name` attribute can be save into a @name instance variable as a string."

"Objects that are stored as state within another object are also called "**collaborator objects**". We call such objects collaborators because **they work in conjunction (or in collaboration) with the class they are associated with**."

"For instance, `bob` has a collaborator object stored in the `@pet` instance variable. When we need that `Bulldog` object to **perform some action** (i.e. we want to access some **behavior** of `@pet`), then we can go through `bob` and call the method on the object stored in `@pet`, such as `speak` or `fetch`."

So collaboration seems partly about access to behaviors, rather than just the types of data stored in the object. A CRC card has Class Responsibilities and Collaborators. Collaborators help the Class carry out its responsibilities.

"When we work with collaborator objects, they are usually custom objects (e.g. defined by the programmer and not inherited from the Ruby core library); `@pet` is an example of a custom object. Yet, collaborator objects aren't strictly custom objects. Even the string object sored in `@name` within `bob` in the code above is technically a collaborator object"

