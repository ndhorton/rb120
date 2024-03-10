**What is OOP and why is it important?**

 Object Oriented Programming is a programming paradigm intended to solve the problems of building and maintaining large, complex software projects. OOP provides facilities such as encapsulation, inheritance, and polymorphism in order to reduce code dependencies and improve the scalability and maintainability of code

As non-OOP programs grow in scale and complexity, there can be a tendency for a program to become a mass of dependencies, with every part of the code base dependent on many other parts. This can make programs difficult to maintain, since any change or addition to one part could cause a ripple of adverse effects throughout

OOP attempts to solve these problems by providing ways to section off areas of code, creating containers for data and functionality that can be changed without affecting every other part of the code base. A program becomes the orchestrated interaction of small parts rather than a mass of dependency.

By abstracting away implementation details behind interfaces, OOP allows the programmer to think at a higher level of abstraction in terms of the 'nouns' of the problem domain, in terms of real world objects. OOP designs can thus help conceptually to break down and solve complex problems

OOP features such as encapsulation, polymorphism, and inheritance, can also facilitate code reuse in a greater variety of contexts.

****

**What is encapsulation?**

Encapsulation means to contain as though within a capsule. Encapsulation means sectioning of areas of code and data into units that define the boundaries within an application. The surface area of the boundary can be restricted to a deliberately defined interface, and the rest of the application can interact with the data and functionality within the unit only through this interface. The implementation information and data can thus be protected within the boundary, behind the unchanging interface, so that the rest of the application does not form dependencies on details that are liable to change. Additionally, the data contained in the unit can be protected from accidental modification by the rest of the application, especially in ways that might impair the unit's functionality.

In Ruby, this encapsulation is achieved by the creation of objects from classes. Objects encapsulate state, tracked by their instance variables. Ruby restricts access to an object's instance variables to its instance methods. If we want to make the reference or setting of an instance variable part of the public interface of the object, we must define instance methods in the class granting access (getter or setter methods). Ruby provides further granularity in defining the interface (and concealing the implementation) of an object through method access control, allowing us to designate certain methods as internal implementation 'helper' methods that should not be depended on by client code. This means that users of the class need only know (and their code only become dependent on) the interface: the public method names and their parameter lists, and what return values or publicly significant side-effects to expect from the public methods.

[This last sentence could be abstracted a bit more. The public interface consists of predictable behavior and attributes?]



By sectioning off code and data in this way, encapsulation facilitates abstraction in thinking and in the design of programs. Breaking down the problem domain into classes helps us reduce the overall problem into smaller problems during the design phase. A class of object can model 'real-world objects', domain-level entities or 'nouns', which allows us to think and solve problems at the problem domain level.

By permitting us to hide the internal representation of objects, encapsulation reduces code dependencies, making our programs more robust and maintainable. And by allowing us to logically group related functionality into reusable units, encapsulation also facilitates code reuse, which reduces opportunities for programmer error and further improves maintainability.

--

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

Objects are instantiated from a class using the class method `new`, which in turn calls the constructor instance method `initialize` which sets the initial state of the new individual object. 

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

Duck typing is the ability for unrelated types to be used polymorphically so long as they expose the right interface for the task at hand. It is a form of polymorphism where unrelated types can respond to the same interface.

To implement polymorphism through duck typing, we could define two unrelated classes each with a method with the same name and the same number of required parameters. Despite not being related through inheritance (either class inheritance or mixins), objects of these classes can be used interchangeably by client code that only needs to call the shared method on them.



Of course, when designing classes to implement polymorphism through duck typing, it is important that however different the implementations of the common interface might be, the objects still behave appropriately to the intended polymorphic use-case.

--

Duck typing means that a given piece of code is not concerned with the class of an object passed to it, only with whether that object has the right behavior. If an object quacks like a duck, it can be treated as a duck. Which is to say, if an object has an appropriate public method with the right name, taking the right number of arguments, for the task at hand, duck typing considers it to be in the right category of object. There is no check made on the class of the object before the method is called at runtime.

Duck typing is a form of polymorphism in which objects of completely unrelated types can be used polymorphically by client code. To implement polymorphic structure through duck typing, we can simply define in two or more unrelated classes the public methods with the names and parameter lists that are required by the polymorphic client code. Of course, in addition to having the right name and parameters, the method needs to behave appropriately to the polymorphic context for there there to be meaningful polymorphic behavior.

While polymorphic behavior can be implemented through class inheritance hierarchies, or through interface inheritance via mixin modules, duck typing offers a greater flexibility and maintainability. A new class can be created and have its objects be used by existing code simply by exposing the right public method, without the class needing to be slotted into an inheritance hierarchy. Duck typing can also reduce code dependencies; client code needs to know less about the objects it manipulates.

[example like that in the LS text, then one of adding a new class which exposes a method needed to be used in a client method] 

The problems solved by duck typing relate to code dependencies. Without duck typing, a piece of client code needs to know more about an object's representation in order to use it. And to implement polymorphic structure without duck typing, classes that might have stood on their own with duck typing would instead have to be inserted into some kind of inheritance relationship.

----

**What is inheritance?**

Inheritance usually refers to class inheritance, whereby a class can subclass another class, which becomes its superclass, and thereby inherit the behaviors of the superclass. This means that instance methods from the superclass can be called on an instance of the subclass, and class methods of the superclass can be called on the subclass. The subclass can optionally override methods from the superclass, providing its own implementation. It still has access to the superclass method from within the overriding method definition via the `super` keyword. A class can only have one superclass in Ruby, though a class may have many subclasses. A superclass can in turn subclass another class, and so on in a chain of inheritance. The subclass is a specialized type with respect to the superclass; class inheritance represents an 'is-a' relationship.

In Ruby, mixin modules used to distribute behaviors to one or more classes can be thought of as another form of inheritance; when the methods in the module include public methods, this is sometimes called 'interface inheritance'. When mixed in via the `Module#include` method, a mixin module is placed between the class and its superclass in the inheritance hierarchy. Instance methods defined in the mixin module can then be called on objects of the class. The class is not a specialized type with respect to the module. The inclusion of a module represents a 'has-a' relationship; the class has an ability provided by the module. A class can mix in as many modules as desired. Unlike superclasses, modules cannot themselves be instantiated.

**What is the difference between a subclass and a superclass?**

In relation to the subclass, a superclass represents a basic class with broad reusability. The subclass represents a specialized type with respect to the superclass, with more fine-grained, detailed behaviors, appropriate to more specific or concrete contexts.

**What is a module?**

A module is a collection of methods and constants. Like a class, a module contains shared behaviors, but, unlike a class, a module cannot be instantiated. A module containing instance methods can be mixed in to a class using the `Module#include` method, which makes those methods available to instances of the class. This is called a mixin. Whereas a class can only have one superclass, it can mix in as many modules as necessary.

In addition to their use as mixins, modules also have uses for namespacing and as stand-alone containers for methods. A module can be used to group related classes (or other modules) under a namespace. This is done to organize code conceptually, and to prevent name collisions with classes of the same name in other parts of the codebase. In order to reference a class within a module, we use the `::` operator, e.g. `NamespaceModule::ClassName`.

Modules can also be used as stand-alone containers for methods that are sometimes called 'module methods'. This can be done to group related methods that do not logically belong to any particular class within the program. Module methods are called directly on the module using the dot operator, similarly to class methods.

**What is a mixin?**

A mixin is a particular use of a Ruby module, often to implement polymorphism. A module that is a collection of instance methods can be mixed in to a class using the `Module#include` method, after which the class has access to the module's instance methods. This is sometimes called 'interface inheritance'. The mixin module will be inserted into the method lookup path between the class and its superclass. Ruby only allows single inheritance. Yet though a class can only have one superclass, it can have multiple mixin modules. Multiple mixed in modules appear in the method lookup path in reverse order of their inclusion into the class. Mixin modules can therefore be used to solve the problems that other languages use multiple inheritance to address, such as the need to give shared functionality to two classes in an inheritance hierarchy whose existing where the shared functionality cannot be extracted to an existing superclass without providing it to classes that should not share it.

Whereas a subclass is a specialized type with respect to its superclass, modeling an 'is-a' relationship, the relationship between a class and a mixin module it includes represents a 'has-a' relationship. The class 'has-an' ability provided by the module. Thus an including class is not a specialized type with respect to the module.

**When is is good to use inheritance?**

[assuming they mean class inheritance from the context given by the link]

Class inheritance is very useful for modeling hierarchical relationships in the problem domain. If there is a natural hierarchical relation between two problem domain entities, modeling the entities as superclass and subclass expresses this relationship well.

[in case they also mean inheritance via mixin modules]

By contrast, if the two entities in the problem domain do not have a hierarchical relationship but do share the same ability or trait, then a shared mixin module expresses this more clearly.

**In inheritance, when would it be good to override a method?**

A subclass is a specialized type with respect to its superclass. This means that a method inherited from the superclass might in some cases need to be overridden with a more fine-grained, detailed implementation that provides the more specific functionality needed by the subclass.

---

**What is the method lookup path?**

The method lookup path is the order of classes and modules that Ruby will search for a method definition when a method is invoked. After searching the class of the object on which the method is called, Ruby will search any mixed in modules in reverse order of their inclusion. After this, Ruby begins this process again with the superclass and its modules. Ruby then moves on to the superclass of the superclass, and so on. Since most Ruby objects inherit from class `Object`, the final three terms of the method lookup chain are usually the `Object` class, the `Kernel` module, and lastly the `BasicObject` class. If the method is still not found, a `NoMethodError` is raised. The method lookup path for a class of objects can be discovered by calling the `Module#ancestors` class method on the class. This returns an array of classes and modules in the order of the method lookup path.

----

**When defining a class, we usually focus on state and behaviors. What is the difference between these two concepts?**

An object's state refers to the values associated to an individual object, which are tracked by its instance variables. The behaviors of an object are its available actions, defined in its class (or in its inheritance hierarchy) as instance methods. Objects encapsulate their own, unique state. Objects share behaviors with the other objects of its class. Instance variables track an individual object's state, and instance methods expose an object's behaviors. A class predetermines its objects behaviors. A class also predetermines the attributes its objects might have, meaning the names of instance variables initialized by an object's instance methods and any public access to these instance variables via instance methods. However, the state of an object refers to the values referenced by a particular object's particular instance variables, and so each object of a class has its own particular state.

----

**How do you initialize a new object?**

Objects are usually initialized by a call to the class method `new`. After allocating memory for the new object, `new` calls the constructor, the private instance method `initialize`, passing through its arguments; the `initialize` constructor uses the arguments to set the initial state of the object. The call to `new` on the class returns a new instance of that class.

```ruby
class Cat
  def initialize(n)
    puts "Initializing a new #{self.class}"
    @name = n # setting initial state of object
  end
end

felix = Cat.new("Felix") # "Initializing a new Cat"
puts felix.inspect       # "<Cat:0x... @name="Felix">"
```

**What is a constructor method?**

A constructor method sets the initial state of an object when the object is instantiated. In Ruby, the constructor is a private instance method called `initialize`. When the `new` class method is called on a class, `new` allocates memory for the object and then passes any arguments through to the `initialize` method to set the initialize state of the newly-instantiated instance. 

```ruby
class Cat
  def initialize(n)
    puts "Constructing a new #{self.class} object with argument '#{n}'..."
    @name = n
  end
end

felix = Cat.new("Felix") # Constructing a new Cat object with argument 'Felix'
puts felix.inspect # <Cat:0x... @name="Felix">
```

---

**What is an instance variable, and how is it related to an object?**

An instance variable is a variable that tracks an object's state. An instance variable name begins with an `@`. Instance variables are scoped at the object level. Once initialized, an instance variable can exist for the lifetime of the object and can be directly accessed from within any instance method of the class. An attempt to reference an uninitialized instance variable will evaluate to `nil` without the variable being initialized.

Instance variables can only be directly initialized and accessed from within instance method definitions in an object's class. In order for client code to interact with an object's instance variables, public instance methods must be exposed to set or retrieve the reference of the instance variable; these are called setter and getter methods.

Instance variables are not directly inherited; rather, a class inherits instance methods and, once called, these may initialize instance variables in the object. 

Instance methods associate data to a particular object, separate from the state of all other objects, facilitating encapsulation at the object level. Unlike local variables, an instance variable can persist for as long as its object exists, but since instance variables preserve encapsulation, they obviate the problems of global variables. Every object's state is distinct, and an object's instance variables track its unique state.

----

**What is an instance method?**

An instance method is a method that is available to instances of a class. The behaviors an object can perform are defined by its instance methods. The public instance methods available to an object comprise the interface of the object, through which client code can interact with the object.

Private and protected instance methods can only be called from within another instance method within the class, and represent encapsulated internal functionality that should not be publicly available. Public instance methods, representing the object's public interface, can be called from outside the class by using the dot operator on the calling object. 

Instance methods are defined within a class or module definition using the `def...end` keyword pair. Instance methods defined within a class are available to instances of that class. Additionally, a subclass inherits instance methods from its superclass. If a module containing instance method definitions is mixed in to a class, then those instance methods are available to objects of that class. The total set of methods available to an object include those defined in every class and module in the method lookup path of the object's class.

----

**How do objects encapsulate state?**

Objects encapsulate state via their instance variables. An object's instance variables are particular to that object and track the individual state of that object. The state tracked by an object's instance variables consists of other objects, sometimes called 'collaborator objects'.

In Ruby, instance variables can only be directly set or referenced from within instance methods within the class. Client code can only access an object's instance variables indirectly via `public` getter or setter methods. If no such methods are defined for an instance variable, or the methods are `private` or `protected`, the variable cannot be referenced or set from outside the object.

----

**What is the difference between classes and objects?**

A class acts as a blueprint or template for objects, which are instances of that class. A class predetermines what an object is made of (its attributes, tracked by instance variables) and how it should behave (its instance methods). The particular state tracked by an object's instance variables is unique to that object. A class groups common behaviors; an object encapsulates state. An object is thus a concrete, individual instantiation of an abstract, general class definition.

----

**How can we expose information about the state of the object using instance methods?**

Instance methods can expose information about the state of an object by returning or outputting references to the object's instance variables.

```ruby
class Cat
  def initialize(name, color)
    @name = name
    @color = color
  end
  
  def to_s
    "#{@name} is a #{@color} #{self.class.to_s.downcase}"
  end
end

felix = Cat.new("Felix", "black and white")
puts felix # "Felix is a black and white cat"
```

Here, the `Cat#to_s` instance method uses string interpolation to construct a string containing information about the `Cat` object's state -- specifically, the values of instance variables `@name` and `@color`.

Instance methods that allow public retrieval of the reference of a single instance variable are called getter methods. They are usually defined with the name of the instance variable:

```ruby
class Cat
  def initialize(n)
    @name = n
  end
  
  def name
    @name
  end
end

felix = Cat.new("Felix")
puts felix.name # "Felix"
```

A more concise syntax to define the same method exists, courtesy of the `Module#attr_reader` method:

```ruby
class Cat
  attr_reader :name

  def initialize(n)
    @name = n
  end
end
```

---

**What is a collaborator object, and what is the purpose of using collaborator objects in OOP?**

A collaborator object is an object, generally stored as part of another object's state, whose functionality contributes towards the fulfillment of responsibilities by the other object. The behavior of the collaborator contributes to the behavior expected of the object. Since the collaborator is stored as part of the object's state, this is a relationship of association, a 'has-a' relationship. Collaborators are associated to an object via its instance variables. Since an object holds a reference to its collaborator, it can invoke methods on the collaborator from within its own methods. Collaboration thus represents the connections between the actors (objects) in the program.

Collaboration relationships exist from the design phase onward. When designing classes, it is important to consider collaboration relationships with other classes. The significant collaborators of a class are the custom classes whose objects will become part of the class's objects' states, and whose objects' behavior will help the class's objects carry out their responsibilities.

The purpose of using collaborator objects is to model the connections between entities in the problem domain as the message-passing connections between actors (objects) in our program. This kind of design helps modularize the problem into separate, connected, pieces, facilitating code reuse and improving maintainability

---

**What is an accessor method?**

An accessor method is a method whose role is to provide mediated access to an instance variable. A method that retrieves the reference of an instance variable is called a getter method, and is conventionally named with the same name as the variable (without the `@`). A method that sets the instance variable is called a setter method, and conventionally shares the name of the variable but with an `=` appended (to take advantage of Ruby's assignment-style syntactic sugar for setter methods).

In Ruby, access to instance variables is restricted to the class. Public accessor methods thus provide a way for client code to set or retrieve the reference of an object's instance variables.

```ruby
class Cat
  def name
    @name
  end
  
  def name=(n)
    @name = n
  end
end

felix = Cat.new
felix.name = "Felix"
puts felix.name # "Felix"
```

Setter and getter methods can also be used within the class, even though instance variables can here be accessed directly. Using setters and getters in this context rather than variable references can enhance maintainability. For instance, if a check always needs to be performed on an object before it can be considered safe to reassign the instance variable to it, a setter method allows us to extract this check to a single place from the many places where reassignment might occur. Likewise, if we need to format or manipulate the state tracked by an instance variable every time it is referenced, a getter method allows that to be performed in a single place.

```ruby
class Bookshelf
  # rest of class omitted...
  
  def books       # a getter method
    @books ||= [] # allows the initialization of the @books variable if necessary
  end
  
  def add(book)
    books << book # if this is the first `add` call, @books will be initialized to
  end             # an array when `books` is called
end

class Book
  def initialize(title, author)
    @title = title
    @author = author
  end
  
  def to_s
    "'#@title', by #@author"
  end
  
  # rest of class omitted...
end

shelf = Bookshelf.new
shelf.add(Book.new("The Trial", "Franz Kafka")) # @books array initialized here
shelf.add(Book.new("Swann's Way", "Marcel Proust")) # simple append to array
puts shelf.books 
# => 'The Trial', by Franz Kafka
# => 'Swann's Way', by Marcel Proust
```

This example demonstrates using a getter method within the class on line 7 to make sure the instance variable `@books` always references an array. If we referenced `@books` directly and it had not been initialized then the `<<` method would be called on `nil` and a `NoMethodError` raised.

Accessor methods can be generated by calling `Module#attr_accessor`, `Module#attr_reader`, or `Module#attr_writer`. Passing a symbol to `attr_accessor` will create a getter method and setter method for an instance variable with the name given by the symbol. The `attr_reader` method only creates the getter; the `attr_writer` method only creates the setter.

So:

```ruby
class Cat
  attr_accessor :name
end
```

is equivalent to:

```ruby
class Cat
  def name
    @name
  end
  
  def name=(n)
    @name = n
  end
end
```

**What is a getter method?**

A getter method is an instance method that returns the reference of a single instance variable. Getter methods are conventionally named after the variable they set.

```ruby
class Cat
  def initialize(n)
    @name = n
  end
  
  def name # a getter method
    @name
  end
end

felix = Cat.new("Felix")
puts felix.name # "Felix"
```

Since they are so common, there is a shorthand way to create getter methods: using the `Module#attr_reader` method.

```ruby
class Cat
  attr_reader :name

  def initialize(n)
    @name = n
  end
end

felix = Cat.new("Felix")
puts felix.name # "Felix"
```

Since instance variables can only be directly referenced within instance methods within the class, public getter methods are the only way to reference an instance variable from outside the class. If there is no getter method, the variable remains hidden from client code.

A getter method might also be used within the class, especially if the value of the variable needs to be manipulated when being retrieved.

```ruby
class CustomerRecord
  def initialize(name, card_number)
    @name = name
    @bank_number = card_number
  end
  
  def show_details
    puts "Customer name: #{name}"
    puts "Payment method: #{card_number}"
  end
  
  def card_number
    "xxxx-xxxx-xxxx-#{@card_number[-4..-1]}"
  end
  
  # rest of class omitted
end

customer = CustomerRecord("Michael Smith", "4321-1234-3241-8762")
customer.show_details
# Customer name: Michael Smith
# Payment method: xxxx-xxxx-xxxx-8762
```

Here, we extract the logic of obscuring the customer's credit card number to the getter method, meaning that we do not need to repeat this code whenever the obscured card number needs to be referenced. This reuse of code improves maintainability, since if we need to change the logic it only needs to be changed in one place.

**What is a setter method?**

A setter method is an instance method that sets a single instance variable. Setter methods are conventionally named after the variable they set, but with an `=` appended. The `=` at the end of the name allows us to use Ruby's assignment-style syntactic sugar when invoking setter methods.

Since instance variables can only be directly set within the class, a public setter method is necessary if we want client code to be able to set an instance variable.

```ruby
class Cat
  def initialize(n)
    @name = n
  end
  
  def speak
    "#@name says meow!"
  end
  
  def name=(new_name) # getter method
    @name = new_name
  end
end

kitty = Cat.new("Tom")
kitty.speak # "Tom says meow!"
kitty.name = "Felix"             # assignment-style syntactic sugar
kitty.speak # "Felix says meow!"
```

Here we have a `Cat` class which, on lines 10-13, defines a setter method called `name=` for the instance variable `@name`. Since we used the `=` naming convention, we can use assignment-style syntactic sugar on line 17 where we invoke the setter to change the cat's name. This syntax is semantically equivalent to `kitty.name=("Felix")`.

Setter methods might also be used within the class instead of directly setting the instance variable. When this is done, we must call the setter method explicitly on `self` in order to disambiguate the setter invocation from the initialization of a local variable.

```ruby
class RationalNumber
  def initialize(numerator, denominator)
    @numerator = numerator
    self.denominator = denominator # getter methods must be called on `self`
  end
  
  def denominator=(denominator) # getter method
    if denominator.zero?
  	  raise ZeroDivisionError, "#{self.class}: denominator cannot be 0"
    end
    @denominator = denominator
  end
  
  # rest of class omitted...
end

rat1 = RationalNumber.new(1, 2) # fine
rat2 = RationalNumber.new(3, 0) # "RationalNumber: denominator cannot be 0"
```

Here, our `RationalNumber` class uses the setter method `denominator=` within the class in order to raise an exception if client code attempts to create a mathematically-undefined rational number object. Extracting the logic that performs a check to a setter method means that any changes to the implementation of the check only have to be made in one place. The potential for code reuse in using setter methods to set instance variables within the class thus improves code maintainability.

**What is `attr_accessor`?**

The `Module#attr_accessor` method is used at the class level to generate setter and getter methods for instance variables. The `attr_accessor` method takes symbols as arguments and uses them as the template for the names of the getter, setter, and the instance variable they provide access to.

So that:

```ruby
class Cat
  attr_accessor :name
end
```

is equivalent to:

```ruby
class Cat
  def name=(n)
    @name = n
  end
  
  def name
    @name
  end
end
```

**How do you decide whether to reference an instance variable or a getter method?**

In general, using a getter method is preferable to referencing an instance variable directly. This is because a getter method gives us a single place in which to manipulate the value the variable references before returning it. If we need to partially hide, format or otherwise manipulate the data referenced by the variable, we can implement this logic in one place rather than in every place the variable is referenced, making code more maintainable and less likely to contain bugs.

For instance,

```ruby
class CustomerRecord
  attr_reader :name

  def initialize(name, card_number)
    @name = name
    @card_number = card_number
  end
  
  def show_details
    puts "Customer name: #{name}"
    puts "Payment details: #{card_number}"
  end
  
  def card_number
    "xxxx-xxxx-xxxx-#{@card_number[-4..-1]}"
  end
  
  # rest of class omitted...
end

customer = Customer.new("Michael Smith", "4321-1234-2315-9823")
customer.show_details
# => Customer name: Michael Smith
# => Payment details: xxxx-xxxx-xxxx-9823
```

In this example `CustomerRecord` class, any time throughout our class that the obscured version of the customer's `@card_number` string needs to be used, we can simply call the `card_number` getter method rather than repeatedly formatting the string to hide the information.

---

```ruby
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def speak
    "#{name} says arf!"
  end

  def change_info(n, h, w)
    name = n
    height = h
    weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end
end

sparky = GoodDog.new("Sparky", "12 inches", "24 lbs")

sparky.change_info('Spartacus', '24 inches', '45 lbs')

puts sparky.info      
# => Sparky weighs 10 lbs and is 12 inches tall.

# Why does the .change_info method not work as expected here?
```

The problem with the `change_info` instance method in our `GoodDog` class
is that rather than calling the setter methods (generated by the call
to `Module#attr_accessor` on line 2)) `name=`, `height=` and `weight=`,
`change_info` currently initializes three new
local variables on lines 15-17, called `name`, `height` and `weight`.

When an instance method is called without an explicit caller within an instance method definition within the class, the implicit caller is the current object, the caller of the instance method whose definition we are currently in. However, since a call to a setter method ending in `=` cannot be syntactically disambiguated from a local variable initialization statement, it is necessary to make the current object caller explicit. The current object can be referenced by the keyword `self`.

In order to disambiguate calls to the setter methods from local
variable initializations, we need to explicitly call the setter methods on the
current object `self`.

```ruby
class GoodDog
  # code omitted ...
  
  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end
  
  # ...
end
```

---

**When would you call a method with `self`?**

Perhaps the most common reason to call a method explicitly on `self` is to disambiguate a call to a setter method whose name ends with `=` from the initialization of a new local variable.

```ruby
class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    @first_name = name.split.first
    @last_name = name.split.last
  end
  
  def full_name
    first_name + ' ' + last_name
  end
  
  def change_name(new_name)
    first_name = new_name.split.first # initializes local variable `first_name`
    last_name = new_name.split.last		# initializes local variable `last_name`
  end
end

mike = Person.new("Mike Smith")
puts mike.full_name # Mike Smith
mike.change_name("Michael Smith")
puts mike.full_name # Mike Smith
```

The reason the above code fails to change the name on line 21 is that the `change_name` method defined in the `Person` class initializes new local variables `first_name` and `last_name` on lines 14-15, rather than calling the setter methods `first_name=` and `last_name=`. In order to disambiguate the calls to the setter methods, we need to explicitly call setter methods on `self`, the current object.

```ruby
class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    @first_name = name.split.first
    @last_name = name.split.last
  end
  
  def full_name
    first_name + ' ' + last_name
  end
  
  def change_name(new_name)
    self.first_name = new_name.split.first # calls setter method `first_name=`
    self.last_name = new_name.split.last	 # calls setter method `last_name=`
  end
end

mike = Person.new("Mike Smith")
puts mike.full_name # Mike Smith
mike.change_name("Michael Smith")
puts mike.full_name # Michael Smith
```

[leave out the `self.class` section, it is not being tested for]

Another reason to call a method on `self` is for constant resolution.

```ruby
class Guitar
  STRINGS = 6
  
  def strings
    STRINGS
  end
end

class BassGuitar < Guitar
  STRINGS = 4
end

bass = BassGuitar.new
p bass.strings # 6
```

Since the method `strings` is defined in the `Guitar` superclass and constants have lexical scope, the reference to constant `STRINGS` on line 5 will resolve to the `STRINGS` defined in the `Guitar` class, even though the `strings` method has been called on an instance of subclass `BassGuitar`. In order to make the `strings` method reference the constant defined in the class of the caller, we need to call the `class` instance method and use the namespace resolution operator

 ```ruby
 class Guitar
   STRINGS = 6
   
   def strings
     class::STRINGS
   end
 end
 ```

However, this will not work, since the `Kernel#class` method called with an implicit caller cannot be disambiguated from the `class` keyword. In order to disambiguate the two, we need to call the `class` method on the explicit `self`.

```ruby
class Guitar
  STRINGS = 6
  
  def strings
    self.class::STRINGS
  end
end

class BassGuitar < Guitar
  STRINGS = 4
end

bass = BassGuitar.new
p bass.strings # 4
```

Although any public instance method within a class within an instance method definition can be called on `self` (since `self` is the implicit caller when a method is called without a caller) it is considered good style not to use `self` when unnecessary. Prior to Ruby 2.7, private methods could not be called on explicit `self`, except for private setter methods. In more recent Ruby versions, private methods can all be called with `self`.

---

**What are class methods?**

Class methods are methods defined on a class and invoked on the class using the dot operator, without having to instantiate any objects of the class. Class methods are most commonly defined within the class using the `self` keyword as follows:

```ruby
class MyClass
  def self.my_class_method
    # body
  end
end
```

Using `self` instead of the name of the class means that if the name of the class changes, the class method definitions do not also need to be changed.

Class methods contain functionality that does not relate to any specific instance of the class. Since objects encapsulate state, a class method can be used for methods that do not deal with states. However, class methods can also be used in conjunction with class variables to keep track of information about the class as a whole:

```ruby
class Cat
  @@total_number_of_cats = 0

  def initialize
    @@total_number_of_cats += 1
  end
  
  def self.total_number_of_cats
    @@total_number_of_cats
  end
end

puts Cat.total_number_of_cats # 0
10.times { Cat.new }
puts Cat.total_number_of_cats # 10
```

---

**What is the purpose of a class variable?**

The purpose of a class variable is to track information about the class as a whole, rather than about any one individual instance.

Since a class variable, once initialized, is accessible throughout the class (including within class methods and instance methods), this means that class variables are the only variables (discounting globals) that can share state between objects. This makes class variables potentially useful to track class-level details, such as how many instances of a class have been instantiated since the program began running. 

However, a class variable will also be shared with any subclasses and their instances. Essentially, class variables are scoped at the level of the entire class and all of its subclasses. This means class variables are dangerous when used with inheritance. The fact that class variables break encapsulation this extensively leads some Rubyists to suggest not to use class variables at all.

----

**What is a constant variable?**

A constant variable in Ruby is a variable that we do not want to change, once defined. If a constant is reassigned outside of a method definition, Ruby will give a warning. If you attempt to initialize or reassign a constant within a method definition, Ruby will raise a `SyntaxError`.

Unlike other variables in Ruby, constants have lexical scope. This means that when Ruby encounters a reference to a constant, it will first search the lexically-enclosing structure (a module or class) and then search any lexically-enclosing structures that the first structure is nested within. (Lexical means expressed textually in the source code; e.g., one structure is lexically nested within another if it is textually contained within the `module...end` or `class...end` keywords of another.) If this lexical search does not find a definition to resolve the constant, Ruby searches the inheritance hierarchy starting with the lexically-enclosing structure, the class or module containing the reference to the constant.

Also unlike other variables, a constant can be referenced from outside the module or class in which it is defined by using the `::` operator, sometimes called the constant resolution operator.

```ruby
class Mathematics
  PI = 3.14159
end

puts Mathematics::PI # 3.14159
```

Constants are generally used to give a symbolic name to a fixed value. They can make code more readable and therefore more maintainable.

----

**What is the default `to_s` method that comes with Ruby, and how do you override this?**

The `to_s` method in Ruby that a custom class will inherit by default from the `Object` class returns a string of the form `"<ClassName:0x...>"`, where `ClassName` stands in for the name of the class and `0x...` stands in for an encoding of the object's unique object id.

```ruby
class Cat
  def initialize(name, coat)
    @name = name
    @coat = coat
  end
end

felix = Cat.new("Felix", "tabby")
puts felix.to_s # <Cat:0x...>
```

In order to override this behavior, it is only necessary to implement a method named `to_s` in our custom class.

```ruby
class Cat
  def initialize(name, coat)
    @name = name
    @coat = coat
  end
  
  def to_s
    "#@name is a #@coat cat"
  end
end

felix = Cat.new("Felix", "tabby")
puts felix.to_s # "Felix is a tabby cat"
```

`Kernel#puts` implicitly calls `to_s` on its arguments but an explicit call to `to_s` is made here for illustration purposes.

When overriding the `Object#to_s` method, it is important that our new implementation returns a string. Otherwise, when `to_s` is called implicitly, as when the object is passed to `puts`, Ruby resorts to calling the `Object#to_s` method and returning the default `<ClassName:0x...>` string representation.

----

**What are some important attributes of the `to_s` method?**

The `to_s` method is built in to every class in Ruby. It returns a string representation of the object. It is often called implicitly, as when an object is passed to the `Kernel#puts` method, or when an object is interpolated into a string.

 A custom class defined without an explicit superclass will inherit the `Object#to_s` method. This returns a string of the form `<ClassName:0x...>`, where `ClassName` is the name of the class of the calling object and `0x...` is an encoding of the object's object id.

When overriding the `to_s` method to return a more useful string representation for objects of a custom class, it is important to ensure that we return a String object. If our custom `to_s` does not return a string and `to_s` is called implicitly, as when the object is passed to `puts`, Ruby will resort to calling a `to_s` method higher up the inheritance hierarchy, usually `Object#to_s`, in order to obtain a String. 

---

**From within a class, when an instance method uses `self`, what does it reference?**

When `self` is used within an instance method definition within a class, it dynamically references the instance of the class that called the instance method.

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def output_self
    puts self.inspect
  end
end

felix = Cat.new("Felix")
felix.output_self # <Cat:0x... @name="Felix">
```

----

**What happens when you use `self` inside a class but outside of an instance method?**

When the `self` keyword is used within a class but outside of any instance method definition, `self` references the class itself.

```ruby
class Person
  puts self # "Person"
end
```

This allows us to use `self` to define class methods, since

```ruby
class Temperature
  def Temperature.celsius_to_fahrenheit(celsius)
    celsius * 9 / 5.0 + 32
  end
end
```

is equivalent to

```ruby
class Temperature
  def self.celsius_to_fahrenheit(celsius)
    celsius * 9 / 5.0 + 32
  end
end
```

The use of `self` at the class level is useful means that if the name of the class were to change, we would not need to change every reference to it within the class.

