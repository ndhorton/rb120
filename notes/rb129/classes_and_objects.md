**Definition**



**Implementation**



**Benefits**



questions:

* What relationship does a class definition have to the state of an object?
* Does a class definition define the "attributes" of an object (meaning both instance variables and means of accessing those variables)? Yes
* Do the instance variables track those attributes? They keep track of the state of those attributes?
* 

## OOP Ruby book ##

### The Object Model ###

'"In Ruby, everything is an object!"... not everything in Ruby is an object. However, anything that can be said to have a value **is** an object: that includes numbers, strings, arrays, and even classes and modules. However, there are a few things that are **not objects**: **methods, blocks, and variables** are three that stand out'

"Another benefit of creating objects is that they allow the programmer to think on a new level of abstraction. Objects are represented as real-world nouns and can be given methods that describe the behavior the programmer is trying to represent."

* Objects provide a further layer of abstraction, allowing us to model real-world objects or concepts from the problem domain

"Ruby, like many other OO languages, accomplishes [encapsulation] by creating objects, and exposing interfaces (i.e., methods) to interact with those objects"

* Ruby uses objects to achieve encapsulation

**Relationship between classes and objects**

"Objects are created from classes. Thing of **classes as molds** and **objects as the things you produce out of those molds**. Individual objects will contain different information from other objects, yet they are instances of the same class."

* Classes are like molds and objects are the things produced from these molds
* Individual objects of the same class will have their own state - information that is unique to the instance

""**Classes define objects**"

"Ruby **defines the attributes and behaviors of its objects in classes**."

* Classes define the attributes and behaviors of its instances (objects).

"You can think of classes as basic outlines of what an object should be made of and what it should be able to do."



**Naming conventions and syntax**

* `class Name; end` - definition begins with `class` keyword followed by the name of the class and end with `end`
* the name is PascalCase (upper CamelCase)
* the name is a constant (starts with an uppercase letter)

"To define a class, we use syntax similar to defining a method. We replace the `def` with `class` and use the PascalCase naming convention to create the name. We then use the reserved word `end` to finish the definition. Ruby file names should be in `snake_case`, and reflect the class name."

The "entire workflow of creating a new object or instance from a class is called **instantiation**"

An object is instantiated by calling the method `new` on the class that you wish to instantiate. The `new` method calls the `allocate` method to allocate space in memory for the instance and then the private `initialize` constructor method to set the initial state for the instance, with any arguments to `new` passed through to `initialize`.



### Classes and Objects I ###

from above:

* Classes are like molds and objects are the things produced from these molds

* Ruby uses objects to achieve encapsulation
* Objects provide a further layer of abstraction, allowing us to model real-world objects or concepts from the problem domain. An object's public interface can describe its available actions in terms of the behavior of these problem-domain entities that we would expect from them

* Classes define the attributes and behaviors of its instances (objects).

* Individual objects (instances) of the same class will each have their own state - information that is unique to the instance.

"When defining a class we typically focus on two things: *state* and *behaviors*"

"State refers to the data associated to an individual object (which are tracked by instance variables)"

* The state of an object is the data or information associated to the object by means of its instance variables.

"we may want to create two `GoodDog` objects: one name "Fido" and one named "Sparky". They are both `GoodDog` objects, but may contain different information, such as name, weight, and height. We would use **instance variables to track this information**. This should tell you that **instance variables are scoped at the object (or instance) level**, and are **how objects keep track of their states**."

"Behaviors are what objects are capable of doing"

"Event though they're different objects, both are still objects (or instances of class `GoodDog` and contain identical behaviors. For example, both `GoodDog` objects should be able to bark, run, fetch, and perform other common behaviors of good dogs. We define these behaviors as instance methods in a class. Instance methods defined in a class are available to objects (or instances) of that class."

"In summary, instance variables keep track of state, and instance methods expose behavior for objects."

"Calling the `new` class method eventually leads to the `initialize` instance method"

'The `@name` variable looks different because it has the `@` symbol in front of it. This is called an **instance variable**. It is a variable that exists as long as the object instance exists and it is one of the ways we tie data to objects. It does not "die" after the `initialize` method is run. It "lives on", to be referenced, until the object instance is destroyed.'

* the lifetime of an instance variable is the lifetime of the object whose state it tracks

"we can see that instance variables are responsible for keeping track of information about the *state* of an object... Every object's state is distinct, and instance variables are how we keep track"

* every object has its own distinct state, tracked by its instance variables

"Again, all objects of the same class have the same behaviors, though they contain different states"

* all objects of the same class have the same behaviors

* an object's instance variables can only be set or read by clients through public methods; getter and setter methods are the most common way this happens
* an `=` symbol at the end of an instance method permits assignment-style syntactic sugar to be used when calling the method

## Classes and Objects - Part II

from above:

* Classes are like molds and objects are the things produced from these molds

* Ruby uses objects to achieve encapsulation
* Objects provide a further layer of abstraction, allowing us to model real-world objects or concepts from the problem domain. An object's public interface can describe its available actions in terms of the behavior of these problem-domain entities that we would expect from them

* Classes define the attributes and behaviors of its instances (objects).

* Individual objects (instances) of the same class will each have their own state - information that is unique to the instance.

* The state of an object is the data or information associated to the object by means of its instance variables.

* the lifetime of an instance variable is the lifetime of the object whose state it tracks
* every object has its own distinct state, tracked by its instance variables

* all objects of the same class have the same behaviors

* an object's instance variables can only be set or read by clients through public methods; getter and setter methods are the most common way this happens
* an `=` symbol at the end of an instance method permits assignment-style syntactic sugar to be used when calling the method

"instance methods... are methods that pertain to an instance or object of the class. There are also class level methods, called **class methods**. Class methods are methods we can call directly on the class itself, without having to instantiate any objects."

* class methods are methods defined at the class level that we can call directly on the class itself without having to instantiate any objects

"When defining a class method, we prepend the method name with the reserved word `self.`"

"Why do we need a class method... class methods are where we put functionality that does not pertain to individual objects. Objects contain state, and if we have a method that does not need to deal with states, then we can just use a class method"

* Class methods contain functionality that does not pertain to individual object instances. An instance encapsulates state, so if a piece of functionality does not require persistent state then we can place it in a class method

"Just as instance variables capture information related to specific instances of classes (i.e. objects), we can create variables for an entire class that are appropriately named **class variables**"

* Whereas instance variables retain information related to the individual instance, class variables retain information about the entire class

## 2:4: Attributes ##

from above:

* Classes are like molds and objects are the things produced from these molds

* Ruby uses objects to achieve encapsulation
* Objects are abstractions that allow us to model real-world objects or concepts from the problem domain. An object's public interface can describe its available actions in terms of the behavior of entities in the problem domain

* Classes define the attributes and behaviors of its instances (objects).

* Individual objects (instances) of the same class will each have their own state - information that is unique to the instance.

* The state of an object is the data or information associated to the object by means of its instance variables.

* the lifetime of an instance variable is the lifetime of the object whose state it tracks

* every object has its own distinct state, tracked by its instance variables

* all objects of the same class have the same behaviors

* an object's instance variables can only be set or read by clients through public methods; getter and setter methods are the most common way this happens
* an `=` symbol at the end of an instance method permits assignment-style syntactic sugar to be used when calling the method
* class methods are methods defined at the class level that we can call directly on the class itself without having to instantiate any objects
* Class methods contain functionality that does not pertain to individual object instances. An instance encapsulates state, so if a piece of functionality does not require persistent state then we can place it in a class method
* Whereas instance variables retain information related to the individual instance, class variables retain information about the entire class

"As a general programming concept, we can think of attributes as the different characteristics that make up an object. For example, the attributes of a `Laptop` object might include: make, color, dimensions, display, processor, memory, storage, battery life, etc. Generally, these attributes can be accessed and manipulated from outside the object. Also, when we talk about attributes, we might be referring to just the characteristic names, or the names *and* the variables attributed to the object -- the meaning is typically clear from context"

* attributes can be thought of as the various characteristics that an object is made of
* attributes can generally be accessed from outside the object
* attributes may refer to the name of the abstract characteristic of the object, or more specifically to the instance variable that tracks the attribute

"Howe attributes are implemented depends on the programming language. In some languages, there is a clear and definitive way to define attributes... Achieving the same effect in Ruby [as is default in JavaScript] is a much more involved process. It involves initializing instance variables and defining setter and getter methods that 'wrap' the instance variable"

* In Ruby, the accessibility of the attribute from outside the object is largely contingent on whether the class author provides setter and/or getter methods for the instance variable tracking that attribute

"the term 'attributes' in Ruby is used quite loosely and is generally approximated as *instance variables*."

* In Ruby, at the most specific level, an attribute corresponds to an instance variable



So I think what they are saying is that an object is *made of* attributes (instance variables and whatever methods are available to set and retrieve their values) in the same way an object *has* behaviors. A class defines the attributes and behaviors of an object. An individual object's state tracks the attributes of an object of that class, and the instance variables of that individual object track the state of that object. In a sense, the class defines *in potentia* the purview of the object's state, since all instance variables must be created through the instance methods available to that object (assuming those methods are defined in the class rather than as singleton methods) and instance variables track the object's state.

So the object has state in the sense that it can remember whether zero or more instance variables have been set (so far), and once created, instance variables track the specifics of that object's state. State here could mean both the capacity of an object to remember  

This is probably why it is good to set all instance variables in the `initialize` method of a class definition, even if at the initialization stage a variable must be explicitly set to `nil`. Although it is true that an uninitialized instance variable will return `nil`, an instance variable that is not initialized will not show up in any introspection of the object. Also it makes it easier for other programmers to see at a glance what attributes make up an instance of that class.

* An object's state tracks the attributes as defined in the class, and an object's instance variables keep track of its state
* Behaviors defined in the class predetermine the instance methods available to every particular object of that class
* Attributes defined in the class predetermine the instance variables pertaining to every particular object of that class
* Setter and getter methods are contingent on an instance variable and can be thought of as contingent properties of an attribute



## End of lesson 1 (plus philosophy article) ##

* Classes are like molds and objects are the things produced from these molds
* Classes define the attributes and behaviors of its instances (objects).
* class methods are methods defined at the class level that we can call directly on the class itself without having to instantiate any objects
* Class methods contain functionality that does not pertain to individual object instances. An instance encapsulates state, so if a piece of functionality does not require persistent state then we can place it in a class method
* Ruby uses objects to achieve encapsulation
* Objects are abstractions that allow us to model real-world objects or concepts from the problem domain. An object's public interface can describe its available actions in terms of the behavior of entities in the problem domain
* Individual objects (instances) of the same class will each have their own state - information that is unique to the instance.

* The state of an object is the data or information associated to the object by means of its instance variables.

* the lifetime of an instance variable is the lifetime of the object whose state it tracks

* every object has its own distinct state, tracked by its instance variables

* all objects of the same class have the same behaviors
* an object's instance variables can only be set or read by clients through public methods; getter and setter methods are the most common way this happens
* an `=` symbol at the end of an instance method permits assignment-style syntactic sugar to be used when calling the method
* Whereas instance variables retain information related to the individual instance, class variables retain information about the entire class

* attributes can be thought of as the various characteristics that an object is made of
* attributes can generally be accessed from outside the object
* attributes may refer to the name of the abstract characteristic of the object, or more specifically to the instance variable that tracks the attribute
* In Ruby, the accessibility of the attribute from outside the object is largely contingent on whether the class author provides setter and/or getter methods for the instance variable tracking that attribute
* In Ruby, at the most specific level, an attribute corresponds to an instance variable
* An object's state tracks the attributes as defined in the class, and an object's instance variables keep track of its state
* Behaviors defined in the class predetermine the instance methods available to every particular object of that class
* Attributes defined in the class predetermine the instance variables pertaining to every particular object of that class
* Setter and getter methods are contingent on an instance variable and can be thought of as contingent properties of an attribute



## 2:6: Lecture: Classes and Objects ##

"classes are the blueprints for objects"

* A class can be thought of as the blueprint for the objects that are instances of that class





























