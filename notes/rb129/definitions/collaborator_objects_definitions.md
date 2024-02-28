**<u>Working with collaborator objects</u>**

**Definitions**

* A collaborator object is an object of another class, usually stored as state within the object with which it is collaborating, whose functionality contributes toward the performance of some action by the object with which it is collaborating
* A collaboration represents a relationship of association between objects
* From the point of view of a given object, its collaborator objects are objects that will send or be sent messages in the course of the object carrying out its responsibilities
* Collaborations represent the connections between the actors (objects) in a program

**Implementation**

* A collaborator object can be of any type
* A collaborator object is part of another object's state
* When designing an object oriented program, it is important to consider what collaborators a class will have and whether these association relationships logically model the problem domain
* Collaboration is a relationship that exists from the design phase onward. It is as much a way of modeling and understanding the relationships between entities in the problem domain as it is the relationship between objects in memory at runtime
* If an object uses an intermediate container object, such as an Array, to store custom objects, the significant collaborator is the custom object, not the Array, since the array is a more an implementation detail while the custom class is part of the design of our program

**Benefits**

* Collaborator objects permit us to modularize the problem domain into separate but connected pieces. This facilitates abstraction and separation of concerns, modeling the problem domain as the network of relationships between smaller problems. This kind of design also facilitates the sectioning off of the code itself into small, interactive units, with fewer and more deliberated code dependencies, improving maintainability
* Thinking in terms of collaboration between objects is an integral part of thinking in terms of objects; it is fundamental to good object-oriented design

