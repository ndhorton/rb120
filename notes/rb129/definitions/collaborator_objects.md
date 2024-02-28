## Collaborator Objects ##

"Classes group common behaviors and objects encapsulate state. The object's state is saved in an object's instance variables. Instance methods can operate on the instance variables."

"Usually, the state is a string or number" - No idea what this means even after several re-reads in wider context.

"For example, a `Person` object's `name` attribute can be saved into a `@name` instance variable as a string"

```ruby
class Person
  def initialize(name)
    @name = name
  end
  
  def name
    @name
  end
end

joe = Person.new("Joe")
joe.name # Joe
```

"Notice that `@name` holds a string object. that is, `"Joe"` is an object of the `String` class. There's nothing special about the `String` class. Instance variables can hold any object, not only strings and integers. It can hold data structures, like arrays or hashes."

```ruby
class Person
  def initialize
    @heroes = ['Superman', 'Spiderman', 'Batman']
    @cash = {'ones' => 12, 'fives' => 2, 'tens' => 0, 'twenties' => 2, 'hundreds'}
  end
  
  def cash_on_hand
    # this method will use @cash to calculate total cash value
    # we'll skip the implementation
  end
  
  def heroes
    @heroes.join(', ')
  end
end

joe = Person.new
joe.cash_on_hand # => "$62.00"
joe.heroes       # => "Superman, Spiderman, Batman"
```

"From the above code example, you can see that we can use any object to represent an object's state. Instance variables can be set to any object, even an object of a custom class we've created. Suppose we have a `Person` that has a `Pet`. We could have a class like this:

```ruby
class Person
  attr_accessor :name, :pet
  
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Robert")
bud = Bulldog.new						# assume Bulldog class from previous assignment

bob.pet = bud
```

"This last line is something new and we haven't seen that yet, but it's perfectly valid OO code. We've essentially set `bob`'s `@pet` instance variable to `bud`, which is a `Bulldog` object. This means that when we call `bob.pet`, it is returning a `Bulldog` object"



So all the above is really a long, language-specific code-embodied preamble to

----

'Objects' that are stored as state within another object are also called "collaborator objects".'

I'm not sure if this is saying that an object *must* be stored as state to be a collaborator. It could be that a collaborator is not always stored as state, but any object stored as state by another object is definitely a collaborator.

' We call such objects collaborators because they work in conjunction (or in collaboration) with the class they are associated with. For instance, `bob` has a collaborator object stored in the `@pet` variable. When we need that `Bulldog` object to perform some action (i.e. we want to access some behavior of `@pet`), then we can go through `bob` and call the method on the object stored in `@pet`, such as `speak` or `fetch`.

So this is the supposed meaning of

```ruby
bob.pet # <Bulldog:0x...>
bob.pet.class # Bulldog
bob.pet.speak # "bark!"
bob.pet.fetch # "fetching!"
```

What is again not clear, is whether the collaborator must be publicly exposed like this. It says 'we can go through `bob`'. I suppose this might be opaque to client code however. So you could have something like.

```ruby
class Owner
  def initialize(name, pet)
    @name = name
    @pet = pet
  end
  
  def info
    "#{name} is the owner of a #{pet.class.downcase} called #{pet.name}"
  end
  
  private
  
  attr_reader :name, :pet
end

class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

felix = Cat.new("Felix")
bob = Owner.new("Bob", felix)
puts bob.info # "Bob is the owner of a cat called Felix"
```

So to repeat,

'Objects that are stored as state within another object are also called "collaborator objects". We call such objects collaborators because they work in conjunction (or in collaboration) with the class they are **associated** with.'

So this tells us that 

1. any object of any given class stored as state within objects of a different class is a collaborator object (though with the possibility that a collaborator does not *need* to be stored as state to be a collaborator)
2. This relationship between objects of two classes is an **association** relationship (at least)
3. The term 'collaborator' signifies that the work of one object is partly delegated to the work of a collaborator in performing a certain task

When we need object `a` of class A to perform some action, that object can send a message to (call a method on) its collaborator object (of class B) and the result (return value or side effect) of that method call will contribute to the overall action required of object `a`. 

Object `a` might be expected to store a reference to the object of class B in order to facilitate this action (though if the action is represented by a method call on object `a`, then the class B object might possibly be passed as argument to this method call. This might be an edge case rather than a useful consideration for the present purpose)

* A collaborator object is an object of another class, usually stored as state within the object with which it is collaborating, whose functionality contributes toward the performance of some action by the object with which it is collaborating
* A collaboration represents a relationship of association between objects



Aside: thinking about it, I'm not sure they have to be two distinct classes? A Node has a reference to another Node as a key part of its state. So maybe recursive relationships could be collaboration? Not sure. But would you really list Node as a collaborator of Node on a CRC card? Would you even bother writing a CRC card for something as fine-grained and generic as a Node?



"When we work with collaborator objects, they are usually custom objects (i.e. defined by the programmer and not inherited from the Ruby core library)... Yet, collaborator objects aren't strictly custom objects. Even [a String object] is technically a collaborator"

So, the meaningful context for the discussion is that of designing custom classes, not worrying about implementation details (such as how a text field of a class is stored in a Ruby implementation). Yet there is no implementation difference between an instance variables storing a reference to a custom object, and storing a reference to a string.

This also suggests that we're mainly considering collaborators as objects stored as part of the state of the principal object, not references passed in a method of the principal object

'Collaborator objects play an important role in object oriented design, since they also represent the connections between various actors in your program.'

I *think* what is meant here is that the relationships of collaboration represent the message-passing connections between the actors (objects) in your program. More explicitly, if an object needs to call a method on another object to perform some work, it makes sense to keep a reference to that secondary object. When designing classes, it makes sense to be aware of collaborative relationships because they express the dependency of one class on the interface of another (the collaborator).

The classes represent the objects. The collaborations represent connections between actors (objects) in your program. Thus when designing classes, we are thinking about the connection between objects

* At the object oriented design level, collaboration between classes represents the message-passing connections between objects. Class collaborations thus represent the connections between actors (objects) in a program

"When working on an object oriented program be sure to consider what collaborators your classes will have and if those associations make sense, both from a technical standpoint and in terms of modeling the problem your program aims to solve."

* When designing an object oriented program, it is important to consider what collaborators a class will have and whether these association relationships logically model the problem domain

"Collaborator objects allow you to chop up and modularize the problem domain into cohesive pieces; they are at the core of OO programming and play an important role in modeling complicated problem domains"

Benefits

* Collaborator objects permit us to modularize the problem domain into separate but connected pieces. This facilitates abstraction and separation of concerns, modeling the problem domain as the network of relationships between smaller problems. This kind of design also facilitates the sectioning off of the code itself into small, interactive units, with fewer and more deliberated code dependencies, improving maintainability



**Wendy Kuhn article**



**CRC Cards assignment**



**<u>Wendy Kuhn</u>**

first **<u>'A Laboratory For Teaching Object-Oriented Thinking' - Beck & Cunningham</u>**

"No object is an island" - Beck & Cunningham

"We name as collaborators objects which will send or be sent messages in the course of satisfying responsibilities" - Beck & Cunningham

'We call such objects collaborators because they work in conjunction (or in collaboration) with the class they are associated with... Collaborator objects play an important role in object oriented design, since they also represent the connections between various actors in your program.' - LS

connections between various actors - objects which will send or be sent messages

work in conjunction - satisfying responsibilities



Beck & Cunningham say: "We introduce CRC cards, which characterize **objects** *by class name*, responsibilities, and collaborators"

So that is why 'collaborator objects' not classes, I think, despite the use of CRC cards in design, rather than a descriptive model of actual runtime entities and events. Classes model objects, after all.

"Because learning about objects requires such a shift in overall approach, teaching objects reduces to teaching the design of objects." Beck &  Cunningham

"Procedural designs can be characterized at an abstract level as having processes, data flows and data stores... We wished to come up with a similar set of fundamental principles for object designs. We settled on three dimensions which identify the role of an object in a design: class name, responsibilities, and collaborators"

processes - functions, operations

data flows - arguments, return values

data stores - data structures

Thinking with objects clearly means a more abstract approach

Class name - "The class name of an object creates a vocabulary for discussing a design. [Class names should comprise] the right set of words to describe our objects, a set that is internally consistent and evocative in the context of the larger design environment"

Responsibilities - "Responsibilities identify problems to be solved. The solutions will exist in many versions and refinements. A responsibility serves as a handle for discussing potential solutions. The responsibilities of an object are expressed by a handful of short verb phrases, each containing an active verb"

Collaborators - "One of the distinguishing features of object design is that no object is an island. All objects stand in relationship to others, on whom they rely for services and control. The last dimension we use in characterizing object designs is the collaborators of an object. We name as collaborators objects which will send or be sent messages in the course of satisfying responsibilities. Collaboration is not necessarily a symmetrical relation"

* From the point of view of a given object, its collaborator objects are objects that will send or be sent messages in the course of the object carrying out its responsibilities

services and control - access to method invocations and their return values or side effects, or having methods called on you and having control flow to you

"Throughout this paper we deliberately blur the distinction between classes and instances"

"Note that the cards are placed such that View and Controller are overlapping (implying close collaboration)..."

**<u>Wendy Kuhn article itself</u>**

'Collaboration is a way of modeling relationships between different objects'

'There are a number of different types of relationships discussed with regard to OOP, and the number varies depending on which source you consult. I will fust focus on two types of relationships for context in this discussion:'

* '**Inheritance** can be thought of as an *is-a* relationship. For example, a dictionary is a book'
* ''**Association** can be thought of as a *has-a* relationship. For example, a library has books, so there is an associative relationship between objects of class Library and objects of class Book'

'A collaborative relationship is a relationship of association -- not of inheritance'

"First, collaborator objects can be of any type"

"Second, a collaborator object is part of another object's state. For example, by assigning a collaborator object to an instance variable in another class' constructor method, you are associating the two objects with one another"

"However, it's not always the case that the instantiation of the collaborator object occurs in the definition itself. Sometimes, the class definition may just define a setter or other instance method, but the collaborator object does not become part of the primary object's state until the setter or instance method is invoked elsewhere, outside of the class definition"

'A collaborator object is part of another object's state and can be an object of any class'

* A collaborator object can be of any type
* A collaborator object is part of another object's state

'Collaboration doesn't just occur when code is executed and objects are occupying space in memory, but it exists from the design phase of your program'

* Collaboration is a relationship that exists from the design phase onward. It is as much an intentional design choice about the conceptual relationships between our objects as it is about the actual runtime relationships between objects in memory

'With regard to actual objects in memory, collaboration occurs when one object is added to the state of another object... However, a more helpful mental model is: *the collaborative relationship exists in the design (or intention) of our code*'

* At runtime, an object becomes a collaborator when a reference to it is added to another object's state. However, from the design of individual classes onward, the relationship has already existed conceptually

'It is the relationship between `Library` and `Books` that is meaningful in terms of the design of our program'

* If an object uses an intermediate container object, such as an Array, to store custom objects, the significant collaborators are the objects of the custom class, not Array, since Array is an implementation detail while the custom class is part of the design of our program



Definitions



* A collaborator object is an object of another class, usually stored as state within the object with which it is collaborating, whose functionality contributes toward the performance of some action by the object with which it is collaborating
* A collaboration represents a relationship of association between objects
* From the point of view of a given object, its collaborator objects are objects that will send or be sent messages in the course of the object carrying out its responsibilities
* Collaborations represent the connections between the actors (objects) in a program

Implementation

* If an object uses an intermediate container object, such as an Array, to store custom objects, the significant collaborator is the custom object, not the Array, since the array is an implementation detail while the custom class is part of the design of our program
* A collaborator object can be of any type
* A collaborator object is part of another object's state
* Collaboration is a relationship that exists from the design phase onward. It is as much a design choice expressing conceptual intent as it is the runtime relationship between objects in memory
* When designing an object oriented program, it is important to consider what collaborators a class will have and whether these association relationships logically model the problem domain

Benefits

* Collaborator objects permit us to modularize the problem domain into separate but connected pieces. This facilitates abstraction and separation of concerns, modeling the problem domain as the network of relationships between smaller problems. This kind of design also facilitates the sectioning off of the code itself into small, interactive units, with fewer and more deliberated code dependencies, improving maintainability
* Thinking in terms of collaboration between objects is an integral part of thinking in terms of objects; it is an essential part of object-oriented design and programming

