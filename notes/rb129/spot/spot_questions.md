

****

**What is encapsulation?**

Encapsulation means to contain as though within a capsule. Encapsulation means sectioning of areas of functionality and data into units that define the boundaries within an application. Data and functionality within this boundary can be protected and only exposed selectively to the rest of the application through a simplified interface. The rest of the application should interact with the data and functionality within the unit only through this interface. The implementation details can thus be protected behind an unchanging interface, so that the rest of the application does not form dependencies on details that are liable to change. Additionally, the data contained in the unit can be protected from accidental modification by the rest of the application.

In Ruby, encapsulation is achieved by the creation of objects from classes. Objects encapsulate state, tracked by their instance variables. Ruby restricts access to an object's instance variables to the object's instance methods. If we want to make access to an instance variable part of the public interface of the object, we must define instance methods in the class granting access to the variable (getter or setter methods). Ruby provides further granularity in defining the interface (and concealing the implementation) of an object through method access control, allowing us to designate certain methods (`private`, `protected`) as internal implementation details that should not be depended on by client code. This means that users of the class need only know -- and their code need only become dependent on -- the interface: the public methods.

* classes and objects, instance variables (encapsulation of state)
* method access control

[This last sentence could be abstracted a bit more. The public interface consists of predictable behavior and attributes?]

Encapsulation involves setting boundaries around data and functionality, and using information hiding to conceal implementation behind interface, in order to facilitate abstraction and the separation of concerns, reducing code dependencies.

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

'Poly' means 'many' and 'morph' means 'forms'. Polymorphism is the ability for different types of data to respond to a common interface, often with different implementations. Different types of object, with different representations, can be used by the same piece of client code so long as they provide the expected interface.

Polymorphism means that if we have several types of argument that expose a method with the same name, we can invoke that method interchangeably on any of those objects, without needing to know the type of object. For example, if we have a method that calls `send_to_printer` on its argument, we can pass it any type of of object as argument so long as the object exposes a `send_to_printer` method. When we do not need to care about the specific type of object on which a method is called, we are using polymorphism.

In Ruby, there are three main ways to implement polymorphic structure: through class inheritance, through mixin modules, and through duck typing. Through class inheritance, various subclasses can inherit a common set of methods from a superclass. Alternatively, a mixin module can be mixed in to various classes to share a set of methods between them (sometimes called interface inheritance). Duck typing means that unrelated classes can simply define one or more compatible methods, with the same name and number of required parameters, and objects of those classes can then be used interchangeably by polymorphic client code.

Polymorphism is something we use in an intentional way from the design phase onward. The implementations of methods behind the common interface may be very different for different classes or types. But as long as there is an intentional compatibility of behavior, the different types can be used polymorphically. On the other hand, it is possible to imagine two classes that simply happen to expose an identically-named method, as a mere coincidence. It is unlikely that this would be a good basis for using objects of those classes polymorphically.

Polymorphism allows for flexibility, facilitates code reuse in new contexts, and increases the maintainability of code.



**Explain two different ways to implement polymorphism**

There are two main ways to implement polymorphic structure in Ruby: through inheritance and through duck typing.

Both class inheritance and interface inheritance via mixin modules allow us to share method definitions between classes. A subclass inherits method definitions from its superclass, and classes that mix in the same mixin module share the methods defined in that module. Subclasses and classes that mix in modules can override the inherited methods, providing a new implementation for the same interface.

To implement polymorphism through duck typing, we can simply define methods of the same name (and with the same number of parameters) in two or more completely unrelated classes, which share neither a common superclass nor any mixin modules. Ruby allows these objects of totally different types to be passed to a piece of client code and to respond to the same method invocation. As long as the objects respond appropriately to the same method invocation to accomplish the task at hand, Ruby considers them of the correct category. The only type check is behavioral: whether they respond to the method call. If an object quacks like a duck, it can be treated as a duck.

**How does polymorphism work in relation to the public interface?**

Since polymorphism is the ability of objects of different types to respond to a common interface, the design of the public interface of a class is key to the overall polymorphic structure of a program. In order to be used polymorphically, objects of different classes need to expose public methods of the same name and with the same number of parameters.

Classes may inherit part of their public interface through class inheritance, or through interface inheritance via mixin modules. They may take advantage of duck typing to implement public methods with the same name and number of parameters as other classes that are not related to them via inheritance. For their objects to be used polymorphically, it is only necessary that classes share a common subset of their public interfaces, i.e. the public methods necessary for the method invocations made by the polymorphic client code.

**What is duck typing? How does it relate to polymorphism - what problem does it solve?**

Duck typing is the ability for types that are not related by any form of inheritance to be used polymorphically so long as they expose the right interface for the task at hand. It is a form of polymorphism where unrelated types can respond to the same interface.

Duck typing means that a given piece of code is not concerned with the class of an object passed to it, only with whether that object has the right behavior. If an object quacks like a duck, it can be treated as a duck. Which is to say, if an object has an appropriate public method with the right name, taking the right number of arguments, for the task at hand, duck typing considers it to be in the right category of object.

To implement polymorphic structure through duck typing, we can simply define, in two or more classes, the public methods with the names and parameter lists that are required by the polymorphic client code. Of course, in addition to having the right name and parameters, the method needs to behave appropriately to the polymorphic context for there there to be meaningful polymorphic behavior.

While polymorphic behavior can be implemented through class inheritance hierarchies, or through interface inheritance via mixin modules, duck typing can offer a greater flexibility and maintainability. A new class can be created and have its objects be used by existing code simply by exposing the right public method, without the class needing to be slotted into an inheritance hierarchy. Duck typing can also reduce code dependencies since client code needs to know less about the objects it manipulates.



--

...

Duck typing is the ability for types that are not related by any form of inheritance to be used polymorphically so long as they expose the right interface for the task at hand. It is a form of polymorphism where unrelated types can respond to the same interface.

To implement polymorphism through duck typing, we could define two unrelated classes each with a method with the same name and the same number of required parameters. Despite not being related through inheritance (either class inheritance or mixins), objects of these classes can be used interchangeably by client code that only needs to call the shared method on them.



Of course, when designing classes to implement polymorphism through duck typing, it is important that however different the implementations of the common interface might be, the objects still behave appropriately to the intended polymorphic use-case.

--

[example like that in the LS text, then one of adding a new class which exposes a method needed to be used in a client method] 

The problems solved by duck typing relate to code dependencies. Without duck typing, a piece of client code needs to know more about an object's representation in order to use it. And to implement polymorphic structure without duck typing, classes that might have stood on their own with duck typing would instead have to be inserted into some kind of inheritance relationship.

----

**What is inheritance?**

Inheritance in Ruby can refer to class inheritance, but also to inheritance through mixin modules, sometimes called 'interface inheritance'.

Class inheritance is a concept common to many OOP languages. A class can *subclass* another class, which becomes its *superclass* in this relationship, and thereby inherit the behaviors of the superclass. This means that instance methods from the superclass can be called on an instance of the subclass, and class methods of the superclass can be called on the subclass. A class can only have one superclass in Ruby, though a class may have multiple subclasses. A superclass can in turn subclass another class, and so on in a chain of inheritance. The subclass is a specialized type with respect to the superclass; class inheritance represents an 'is-a' relationship.

In Ruby, the use of mixin modules to distribute behaviors to one or more classes can be thought of as another form of inheritance, sometimes called interface inheritance. When mixed in via the `Module#include` method, a mixin module is placed between the class and its superclass in the inheritance hierarchy. Instance methods defined in the mixin module can then be called on objects of the class. The class is not a specialized type with respect to the module, since unlike a class, modules cannot be instantiated. The inclusion of a module represents a 'has-a' relationship; the class has an ability provided by the module. A class can mix in as many modules as desired.

Each Ruby class has a method lookup path which Ruby uses when a method is called on an instance of that class. Methods inherited from either a superclass or a mixin module can be overridden by a new definition in the inheriting class. This works because the class of the instance comes before the superclass in the method lookup path and once Ruby finds a method with the right name, it stops looking. The superclass or mixin module method can still be called from within the overriding method by use of the keyword `super`.

Inheritance facilitates code reuse by sharing a single definition between multiple classes, and facilitates polymorphism through providing a common interface to different types.

* class inheritance
* mixin modules
* method lookup path
* method overriding



**What is the difference between a subclass and a superclass?**

In relation to the subclass, a superclass represents a basic class with broad reusability. The subclass represents a specialized type with respect to the superclass, with more fine-grained, detailed behaviors, appropriate to more specific or concrete contexts.

**What is a module?**

A module is a collection that can contain classes, methods, constants, and other modules. Like a class, a module can contain shared behaviors, but, unlike a class, a module cannot be instantiated. A module containing instance methods can be mixed in to a class using the `Module#include` method, which makes those methods available to instances of the class. This is called a mixin. Whereas a class can only have one superclass, it can mix in as many modules as necessary.

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

----

**Why do you need to use `self` when calling private setter methods?**

Private setter methods can only be called within instance methods definitions within the class. When calling any setter method within the class, it is necessary to call the setter method on `self` explicitly in order to disambiguate the method call from the initialization of a local variable.

```ruby
class Cat
  def initialize(n)
    @name = n
  end
  
  def change_name(new_name)
    name = new_name # initializes new local variable `name`
  end
  
  attr_reader :name
  
  private
  
  attr_writer :name
end

kitty = Cat.new("Kitty")
puts kitty.name # Kitty
kitty.change_name('Felix')
puts kitty.name # Kitty
```

The above example does not produce the desired results because the attempt to call the setter method `name=` implicitly on the current object is syntactically confused with the initialization of a local variable `name`. Even doing away with the syntactic sugar around setter methods will not work either: `name=(new_name)` will be understood by Ruby as `name = (new_name)` and a new local variable `name` will still be initialized with the value of `new_name`.

In order to disambiguate the syntax, we must call the setter on `self`, an explicit reference to the current object.

```ruby
class Cat
  # code omitted
  def change_name(new_name)
    self.name = new_name # explicit reference to current object
  end
  # ...
  private
  
  attr_writer :name
end

kitty = Cat.new("Kitty")
puts kitty.name # "Kitty"
kitty.change_name("Felix")
puts kitty.name # Felix
```

This explicit `self.` syntax would be necessary within the class even if the setter method `name=` were not private.

Before Ruby 2.7, it was illegal to call private methods on `self` unless the method was a setter method. In all more recent versions, it is now legal to call any private method on `self` within the class (though `self` is the only explicit caller permitted for private methods).

----

**Why use `self`, and how does `self` change depending on the scope it is used in?**

There are two extremely common reasons to use `self`. One example is within the instance methods within a class, in which scope `self` references the calling object. The other example is at the class level, where `self` references the class itself. 

When calling setter methods within the class within an instance method, we must explicitly call the setter method on `self` in order to disambiguate the method call from the initialization of a new local variable. Within the instance methods of a class, `self` references the current object, the instance that called the instance method.

```ruby
class Cat
  attr_accessor :name

  def initialize(name)
    self.name = name  # necessary use of `self`
  end
  
  def what_am_i
    puts self.inspect # outputs a detailed string representation of the current
    									# object
  end
end

felix = Cat.new("Felix")
felix.what_am_i # <Cat:0x... @name="Felix">
```

The other common use for `self` is at the  class level, where `self` references the class itself. Here, defining a method on `self` results in a class method. Within a class method, `self` still references the class.

```ruby
class Cat
  def self.what_am_i # defining a new class method on Cat
    puts "I am the #{self} class"
  end
end

Cat.what_am_i # "I am the Cat class"
```

In general, it is considered good style to use `self` only when necessary.

---

**What is inheritance, and why do we use it?**

In Ruby, inheritance can take two forms.

Class inheritance is when a class inherits behavior from another class. The class that inherits is called the subclass and the class from which it inherits is called the superclass. Any given class can only have one superclass but may have multiple subclasses. The superclass can in turn have its own superclass, and so on in a chain or hierarchy of inheritance. The relationship between a subclass and its superclass is an 'is-a' relationship, which is to say that the subclass 'is a' specialized type of the superclass type. The superclass defines general, highly-reusable behaviors, while its subclasses define more specific, fine-grained behaviors. A subclass can extend the superclass with additional behaviors as well as override and refine specific behaviors inherited from the superclass.

Class inheritance allows us to model naturally hierarchical relationships between entities in the problem domain. This helps us in the design phase of the program, permitting us to think in abstractions that mirror the problem domain. By allowing us to extract common behaviors from subclasses to a shared superclass, class inheritance permits code reuse and polymorphism, leading to more maintainable code.

```ruby
class Animal
  attr_reader :name

  def initialize(n)
    @name = n
  end

  def speak
    puts "makes sound"
  end
end

class Cat < Animal # Cat subclasses Animal
  def speak
    puts "meow!"
  end
end

class Dog < Animal # Dog subclasses Animal
  def speak
    puts "woof!"
  end
  
  def swim
    puts "I'm swimming"
  end
end

felix = Cat.new("Felix")
puts felix.name # Felix
felix.speak 		# meow!

barny = Dog.new("Barny")
puts barny.name # Barny
barny.speak     # woof!
```

Here, the `Cat` and `Dog` classes are subclasses of the `Animal` superclass. They inherit the behavior of the `Animal` class, including the `initialize` constructor and the `name` method, as demonstrated. Both `Cat` and `Dog` offer a specialized implementation for the `speak` method; this is called method overriding. The `Dog` class extends the functionality of its superclass by defining a `swim` method. Since, for the purposes of example, this is a shared behavior of dogs but not of all animals generally, it makes sense for the `Dog` class to define this more specific behavior.

Each class can only have one superclass but can have many subclasses. A superclass can in turn have its own superclass, forming a hierarchy or chain of inheritance.

The other form inheritance can take in Ruby is through the use of mixin modules. A module can be defined to contain related behaviors that can then be mixed in to one or more classes by using the `Module#include` method. The class that mixes in a mixin module has access to the behaviors defined in the module, but is not considered a specialized type with respect to the module, since, unlike a class, a module cannot itself be instantiated. Instead, the relationship of the class to the module is a 'has-a' relationship, in that the class 'has a' behavior provided by the module. This is sometimes called 'interface inheritance'.

For example,

```ruby
module Speakable
  def speak
    puts "Hello"
  end
  
  def say(something)
    puts something
  end
end

class Student
  include Speakable
end

class Professor
  include Speakable
end

student = Student.new
student.speak # "Hello"

professor = Professor.new
professor.speak # "Hello"
```

In this example, the inclusion of the `Speakable` module into two otherwise unrelated classes, `Student` and `Professor`, means that both class now have the ability to `speak`.

Modules can be mixed in to two or more classes that do not need to be related by class inheritance. Yet, since Ruby is a single (class) inheritance language, mixin modules can be used in place of multiple (class) inheritance to supplement the behavior of related classes when common behaviors cannot be extracted to the superclass without providing them to subclasses that should not inherit them.

In both cases, inheritance allows code reuse, increasing code maintainability. Inheritance means that multiple types become able to respond to a common interface, thus facilitating polymorphism.



---

**Give an example of how to use class inheritance**

Class inheritance is the relationship between a subclass and its superclass, whereby the subclass inherits behavior from the superclass. This is an 'is a' relationship in that the subclass is a specialization of the superclass. This means that class inheritance should be used to model naturally hierarchical relationships in the problem domain.

The subclass-superclass relationship is expressed by using the `<` operator after the name of the subclass, followed by the name of the superclass. We can extract common behaviors from the subclasses to their superclass and the subclasses will then inherit the behaviors.

As an example, 

```ruby
class Boat
  def cast_anchor
    puts "casting anchor!"
  end
end

class Schooner < Boat
  def set_sail
    puts "setting sail!"
  end
end

class Speedboat < Boat
  def start_engine
    puts "starting the engine"
  end
end

schooner = Schooner.new
speedboat = Speedboat.new

schooner.cast_anchor  # "casting anchor!"
schooner.set_sail     # "setting sail!"

speedboat.cast_anchor  # "casting anchor!"
speedboat.start_engine # "starting the engine!"
```

Here, we extract the common `cast_anchor` instance method from the subclasses `Schooner` and `Speedboat` to their superclass `Boat`. Instances of `Schooner` and `Speedboat` both have access to this method through class inheritance, as demonstrated on lines 22 and 25. The `Schooner` class specializes its superclass by the addition of the `set_sail` instance method, while the `Speedboat` class add its own instance method `start_engine`. These additional behaviors are specific to each subclass.

As well as simply adding behavior, subclasses can override methods inherited from their superclass. For example,

```ruby
class Animal
  def speak
    puts "*animal noises*"
  end
end

class Cat < Animal
  def speak
    puts "meow!"
  end
end

class Dog < Animal
end

cat = Cat.new
cat.speak # meow!

dog = Dog.new
dog.speak # *animal noises*
```

Here, both `Cat` and `Dog` inherit the `speak` instance method from `Animal`. `Cat` overrides this on lines 8-10, however. This means that `Cat` instances have their own specialized implementation of this method, while `Dog` instances inherit the generic `speak` method from `Animal`. This is demonstrated on lines 17 and 20.



**Give an example of overriding. When would you use it?**

Method overriding allows us to specialize the behavior of a subclass in fine-grained ways. When a subclass inherits a method, we can override the inherited method with a different or more specialized implementation of a method of the same name. When an instance of the subclass has the method called on it, Ruby will search the subclass for instance methods first and find a method of that name, and so will not continue on the method lookup path to find the superclass method with that name. Methods inherited by mixing in a module can be overridden in the same way.

It is common to override inherited methods if the subclass needs a more specialized implementation than its more general superclass. For example, if a `Document` class normally fetches the `text` of the document from a local file, we might want a `DatabaseDocument` subclass to inherit most of its behavior from `Document` but override the `text` method in order to fetch the document text from a database instead:

```ruby
class Document
  # rest of class omitted ...
  
  def text
    "text fetched from file"
  end
end

class DatabaseDocument < Document
  # rest of class omitted ...
  
  def text
    "text fetched from database"
  end
end

doc1 = Document.new
doc2 = DatabaseDocument.new

[doc1, doc2].each { |doc| puts doc.text }
# "text fetched from file"
# "text fetched from database"
```



It is important to be careful *not* to override methods inherited from the `Object` class (which most Ruby classes inherit from). These methods are so integral to the core functionality of Ruby programming that overriding them can have dire results for your application. However, certain methods inherited from `Object` are common and useful to override, an example being the `to_s` method.

**Give an example of using the `super` method. When would we use it?**

When a method overrides a method further up the inheritance hierarchy, the superclass method can still be called from within the subclass method by the use of the keyword `super`.

```ruby
class Pet
  def greeting
    "Hi"
  end
end

class Cat < Pet
  def greeting
    super + " from a cat"
  end
end

kitty = Cat.new
puts kitty.greeting # "Hi from a cat"
```

This allows us to reuse existing code, and is useful for any situation in which we simply want to extend the behavior of the inherited method rather than change the existing implementation.

**Give an example of using the `super` method with an argument**

When a method overrides a method further up the inheritance hierarchy, the superclass method can still be called from within the overriding method by the use the `super` keyword. Called without arguments, `super` calls the next method further up the method lookup path passing all arguments through to the superclass method. If `super()` is called with empty parentheses, no arguments are passed. Ordinary method call syntax can be used to pass specific arguments to the superclass method, e.g. `super(first_argument, second_argument)`.

Especially used with `super`, overriding `initialize` is very common in Ruby. This allows us to `initialize` the subclass instances with greater number of instance variables, allowing for a more fine-grained, specialized state for the subclass objects than for the more general superclass.

```ruby
class Pet
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
end

class Dog < Pet
  attr_accessor :color

  def initialize(name, color)
    super(name)
    @color = color
  end
end

barny = Dog.new("Barny", "brown")
puts barny.inspect # <Dog:0x... @name="Barny", @color="brown">
```

Here, we have a generic `Pet` superclass whose `initialize` constructor simply takes a `name` for the `Pet` instance and uses it to initialize a `@name` instance variable on line 5. The `Dog` class, which subclasses `Pet`, defines an `initialize` method that overrides the superclass method but also makes use of it, passing through its own `name` argument to the superclass `initialize` method via `super(name)` on line 13. After this, on line 14, the subclass `initialize` constructor initializes the `@color` instance variable to the second argument, `color`. Thus we can see, on line 19, that a newly-created `Dog` instance has both `name` and `color` attributes. `Dog` provides setter and getter methods for the additional attribute through the call to `Module#attr_accessor` on line 10.



---

A way to think about Duck Typing just occurred to me. When you inherit methods, an object has access to that method through the method lookup path. When you override methods, you place a new method closer in the lookup path. When you mixin a module, you insert the module into the method lookup path.

With duck typing, none of this takes place. Instead, you have two classes which do not receive a method from the same source in their method lookup paths. Instead, they just defined a method with the same name in two completely separate inheritance chains. So there is no location in the method lookup path connecting them at all. So it's better to focus on understanding it from that perspective than it is to contrast duck typing mentally with static typing or thinking about late binding etc. It is an emergent situation that is more than the sum of its parts, in that we are thinking about it as a situational possibility or pattern.

So class inheritance and mixins are both ways to implement polymorphism through manipulating the method lookup path. Therefore, even in Ruby, there is a concrete difference between this situation and duck typing.

Duck typing just means that an object exposes the necessary interface and behavior for a given task, or can be grouped with (categorized with) other objects based on that common interface (e.g., objects that can be passed to a particular function which calls a particular method on them, an array of such objects that will be passed to a function, etc)

```ruby
# class inheritance
class Guitar
  def strum
    "strumming chord"
  end
end

class ElectricGuitar < Guitar # has `strum` because it is in 
  														# method lookup path
end

class AccousticGuitar < Guitar
end

guitars = []
10.times do |counter|
  guitars << counter.even? ? ElectricGuitar.new : AccousticGuitar.new
end
guitars.each { |guitar| guitar.strum }
# each element is-a 'guitar'


# interface inheritance / mixin modules
module Strummable
  def strum
    "strumming"
  end
end

class Harp
  include Strummable # has `strum` because it is in method lookup path
end

class Guitar
  include Strummable
end

chordophones = []
10.times do |counter|
  chordophones << counter.even? ? Guitar.new : Harp.new
end
chordophones.each { |chordophones| chordophones.strum }
# each chordophone has-an ability to be strummed

# duck typing
class Harp
  def strum
    "ethereal arpeggios"
  end
end

class Ukelele
  def strum
    "plinky chord"
  end
end

strummables = []
10.times do |counter|
  strummables << counter.even? ? Harp.new : Ukelele.new
end
strummables.each { |strummable| strummable.strum }
# each strummable exposes the necessary behavior to be grouped in strummables
# for the task of strumming

```



---

**When creating a hierarchical structure, under what circumstance would a module be useful?**

Ruby is a single inheritance OOP language, which means that classes can only inherit from a single superclass. When creating a class hierarchy, there may be functionality which should be shared by two or more classes but, because of the limit of one superclass per class, there is no viable superclass to extract the behavior to without sharing it with subclasses that should not have access to it. However, mixin modules can be used in place of multiple inheritance to achieve code reuse.

For instance, if we had the following class hierarchy,

```ruby
class Auto
end

class Truck < Auto
end

class Car < Auto
end

class Sedan < Car
end

class Sportscar < Car
end
```

If we wanted to add functionality that related to the two-seater vehicles, `Truck` and `Sportscar`, there is no viable superclass to extract the functionality to. Defining the methods in `Auto` would share them with all of its subclasses, including `Sedan`. With pure class inheritance, we would have to repeat the definitions of the two-seater methods in both of these subclasses. However, mixin modules provide a way to write the method definitions once and then share this behavior with whichever classes we want by mixing in the module with the `Module#include` method:

```ruby
module TwoSeatable
  def number_of_seats
    2
  end
end

class Auto
end


class Truck < Auto
  include TwoSeatable
end

class Car < Auto
end

class Sedan < Car
end

class Sportscar < Car
  include TwoSeatable
end

car = Car.new
truck = Truck.new
sportscar = Sportscar.new

puts truck.number_of_seats # 2
puts sportscar.number_of_seats # 2
```

Here, the `number_of_seats` instance method, defined in the `TwoSeatable` module is mixed into the `Truck` class (line 12) and the `Sportscar` class (line 22). 

Using mixin modules to group common behaviors allows us to reuse code effectively in situations where Ruby's single inheritance would make it extremely difficult using class inheritance alone. Reusing code leads to more maintainable code and reduces the potential for errors.

**What is interface inheritance, and under what circumstance would it be useful in comparison to class inheritance?**

When we define behavior in a module and mix that module in to a class using the `Module#include` method, the class gains access to those behaviors; this is sometimes called 'interface inheritance'.

Class inheritance means that one type inherits the behaviors of another type. The resulting type specializes the type of the superclass. The relationship is an 'is a' relationship, in that the subclass 'is a' specialized type of the superclass type. For instance,

```ruby
class Reptile
end

class Lizard < Reptile
end
```

Here, it makes sense that `Lizard` subclasses `Reptile` because a lizard *is a* specific type of reptile.

With interface inheritance, the class doesn't inherit from another type. Rather, it inherits the interface provided by the mixin module. The class that mixes in the module is not a specialization of the type of the module. A module cannot be instantiated. The relationship between the class and the module can be described as a 'has a ' relationship, in that the class 'has an' ability provided by the module. Conventionally, mixin modules are often named with adjectives describing the ability they impart to the classes that mix them in, often ending in the suffix '-able'. For instance,

```ruby
class Climbable
  def climb
    puts "I'm climbing"
  end
end

class Monkey
  include Climbable
end

class MountainGoat
  include Climbable
end

monkey = Monkey.new
goat = MountainGoat.new

monkey.climb # "I'm climbing"
goat.climb # "I'm climbing"
```

Here, two classes of animal, `Monkey` and `MountainGoat`, which do not share a class inheritance hierarchy, both possess an ability to `climb` by mixing in the `Climbable` module.

If there is an 'is a' relationship between the entities in the problem domain, class inheritance expresses this relationship better. If there is a 'has a' relationship, interface inheritance expresses that relationship better.

Whereas a class can only have one superclass, it can `include` an arbitrary number of mixin modules. This means interface inheritance can be used to supplement the behaviors inherited from the superclass. This is Ruby's solution to the problems that multiple inheritance might solve in other languages. Interface inheritance can thus be useful when behaviors needed by two or more subclasses cannot be extracted to their common superclass without providing the behaviors to classes that should not have access to them.

Since a module cannot be instantiated, a module cannot take the place of a superclass when the superclass needs to be able to instantiate objects itself.

**How is the method lookup path affected by module mixins and class inheritance?**

When a method is invoked on an object, Ruby searches the method lookup path for objects of that class. Ruby searches the path for a method with the name used in the invocation.

The method lookup path begins with the class of the object. If the method name is not found, Ruby then searches modules mixed in by the `Module#include` method in the reverse order of the calls to `include`. If the method name is still not found, Ruby moves on to the superclass. This process repeats until the name is found, or a `NoMethodError` is raised to signify that there is no method of that name available to that object.

The `Module#ancestors` method can be called on a class to return an array of classes and mixin modules representing the method lookup path for objects of that class. For instance,

```ruby
module Walkable
end

module Swimmable
end

class Animal
  def speak
    puts "hello"
  end
end

class Dog < Animal
  include Walkable
  include Swimmable
end

Dog.ancestors # [Dog, Swimmable, Walkable, Animal, Object, Kernel, BasicObject]
barny = Dog.new
barny.speak # "hello"
```

On lines 1-13, we create a hierarchy of two classes `Animal` and its subclass `Dog`, and two mixin modules, `Walkable` and `Climbable`, which are mixed in to `Dog`. The call to `Dog.ancestors` on line 15 demonstrates the method lookup path for objects of the `Dog` class. First, the `Dog` class itself is searched. Then the `Swimmable` module is searched before the other module because the call to `include` for `Swimmable` was the last `include` method call. Next the `Walkable` module is searched, and then the superclass `Animal` is searched. Since custom classes that do not explicitly inherit from another class implicitly inherit from `Object`, this is the next class searched. `Object` mixes in the `Kernel` module, and inherits from `BasicObject`.

On line 20, the `speak` method is called on an object of the `Dog` class. Ruby first searches `Dog` and does not find the method. Ruby then searches `Swimmable` and then `Walkable` and does not find a method called `speak`. Ruby then searches the `Animal` class and finds a `speak` method, so `Animal#speak` is the method executed for this invocation.

Mixed in modules are inserted in the method lookup path between the class and its superclass in the reverse order of their `include` calls. This means that in the rare case of two or more mixin modules containing methods with the same name, the method in the module included last will be chosen. The superclass is searched after the class and its mixin modules.

**What is namespacing?**

Namespacing means grouping language elements under a name that serves to qualify the names of those elements. In Ruby, a namespace is implemented by creating a module within which to group related classes.

Namespacing classes in this way allows us to conceptually group related classes in order to logically organize our code. This also makes the role of classes easier to grasp in code that makes use of them. Namespacing classes also prevents name collisions between a class and another class with the same name somewhere else in the code base.

Namespaced classes can be referred to by using the `::` operator. For example,

```ruby
module Tree
  class Oak
    def to_s
      "an oak tree"
    end
  end
  
  class Elm
    def to_s
      "an elm tree"
    end
  end
end

oak = Tree::Oak.new
elm = Tree::Elm.new

puts oak # "an oak tree"
puts elm # "an elm tree"
```

**How does Ruby provide the functionality of multiple inheritance?**

Ruby is a single-inheritance OO language, which means that Ruby permits a class to subclass from only one superclass. Multiple inheritance languages allow a class to subclass from multiple superclasses, providing flexibility at the cost of greater complexity.

Single inheritance can be limiting in situations where two subclasses need to share behavior but the behavior cannot be extracted to a common superclass without providing the behavior to subclasses that should not share it. Fortunately, Ruby provides a way to implement the functionality of multiple inheritance via the inclusion of mixin modules (sometimes called 'interface inheritance').

Given the following class structure, it might be desirable to add a `climb` method to `Monkey` and `MountainGoat`.

```ruby
class Mammal
end

class Monkey < Mammal
end

class MountainGoat < Mammal
end

class Dolphin < Mammal
end
```

However, if we were to extract this `climb` method to the `Mammal` superclass, this would provide the behavior to `Dolphin`, and dolphins should not be able to `climb`.

In this situation we can use a module to implement the functionality of multiple inheritance. We extract the shared behavior to a module with an adjectival name that describes the shared behavior the module provides (by convention, often ending in '-able'). We then 'mix in' the module to the classes that should share the behavior it contains, using the `Module#include` method.

```ruby
module Climbable
  def climb
    puts "I'm climbing"
  end
end

class Mammal
end

class Monkey < Mammal
  include Climbable
end

class MountainGoat < Mammal
  include Climbable
end

class Dolphin < Mammal
end

monkey = Monkey.new
goat = MountainGoat.new
dolphin = Dolphin.new

monkey.climb # "I'm climbing"
goat.climb   # "I'm climbing"
dolphin.climb # raises NoMethodError
```

As we can see from lines 25-27, we have provided the `climb` behavior to the classes in the existing class hierarchy that need it, and have avoided providing the behavior to classes that should not have it.

This use of mixin modules in Ruby provides most of the advantages of multiple inheritance (though unlike a class, a module cannot itself be instantiated).

**Describe the use of modules as containers**

Modules can serve as 'containers' for related functionality that does not properly belong to any of the classes in a program. We define methods on the module itself, and, much like when defining class methods, we often use the `self` keyword at the module level in order to do so. These module methods can be called on the module itself, using the dot operator:

```ruby
module Temperature
  def self.celsius_to_fahrenheit(celsius)
    celsius * 9 / 5.0 + 32
  end
  
  def self.fahrenheit_to_celsius(fahrenheit)
    (fahrenheit - 32) * 5 / 9.0
  end
end

Temperature.celsius_to_fahrenheit(100) # => 212.0
```

Such 'module methods' can also be called using the `::` operator:

```ruby
Temperature::celsius_to_fahrenheit(100) # => 212.0
```

However, the dot operator is the preferred style.

---

**Why should a class have as few public methods as possible?**

Classes should define an interface through which client code can interact with objects of the class, while concealing as many of the implementation details as possible. This is done in order to prevent client code from becoming dependent on the implementation details of the class, which might change over time. Reducing the number of potential code dependencies in this way helps build maintainable software that can be changed or added to without breaking existing code.

In Ruby, the interface of a class consists of its public methods. These should be as few in number as possible in order to simplify the use of objects of the class, and to hide as much of the implementation as possible. Designing a simple interface to objects of the class allows users of the class to think at a greater level of abstraction, the abstraction level of the problem domain rather that of implementation details. This helps in breaking down and solving problems. Keeping as much of the representation of the object hidden as possible helps avoid undesired mutation of an object's state.

---

**What is the `private` method call used for?**

The `Module#private` method is a method access control modifier. 

Access control is a common OO feature that allows a programmer to restrict or permit access to parts of an object from different parts of the program. In Ruby, direct access to an object's instance variables is automatically restricted to within the instance methods of the object. However, by default, Ruby instance methods are `public`, meaning they can be called from anywhere in the program there is a reference to the object. Ruby's method access control modifier methods govern which methods remain `public` and which have restricted access.

When we define a class, Ruby allows the programmer to define methods as `private`, using the `Module#private` method. A `private` method can only be called from within instance methods in a class on the calling object itself. Calling a `private` method from outside the class raises a `NoMethodError`. It is useful to make methods `private` when they do work within the class but should not be part of the class interface.

For instance,

```ruby
class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end
  
  def change_name(new_name)
    self.name = new_name unless new_name.empty?
  end
  
  # rest of class omitted ...
  
  private
  
  def name=(new_name)
    @name = new_name
  end
end

tom = Cat.new("Brian")
puts tom.name # "Brian"

tom.change_name("Tom")
puts tom.name # "Tom"

tom.name = "" # raises NoMethodError, private method called from outside class
```

Here, the `Cat` class defined on lines 1-15 has a `public` method `change_name` (lines 8-10) that calls the `private` method `name=`, defined after the `private` method call on line 14. Users of the class only need to know that they can call the `change_name` method on `Cat` objects. They do not need to know that the implementation of `change_name` involves a call to the private setter method `name=`. If they attempted to call `name=` directly from outside the class, a `NoMethodError` will be raised, as on line 21. This prevents the `@name` instance variable from being set by client code without the check `unless new_name.empty?` that is performed within the `change_name` definition (line 9).

Making methods `private` hides implementation details from users of the class. It strengthens encapsulation, simplifying the class interface and helping to prevent client code from becoming dependent on details about the class that may change. Making methods `private` can also help prevent an object's state from being modified in undesirable ways.

Before Ruby 2.7, `private` methods could not be called explicitly on `self` unless they were setter methods. Other `private` methods could only be called on the calling object implicitly (without dot operator notation). After Ruby 2.7, all `private` methods can be called explicitly on `self`.

**What is the `protected` method used for?**

Access control is a common feature of OO programming languages. Access control specifies which parts of an object are accessible from different parts of the program. In Ruby, an object's instance variables are only ever directly accessible to the object's instance methods. The access control provided by Ruby is therefore method access control, via the access control modifier methods `Module#public`, `Module#private`, and `Module#protected`.

By default, instance methods defined in a class definition are `public`. The `public` instance methods of a class are callable from anywhere there is a reference to an object of that class. The `public` methods therefore form the interface of  the class. Instance methods declared `private` cannot be called from outside the class, and can only be called from within instance methods of the class on the calling object.

`protected` methods are similar to `private` methods in that they cannot be called from outside the class. However, whereas a `private` method can only be called within an instance method on the calling object, a `protected` method can be called from within an instance method on any object of the class (e.g., one that has been passed as argument to the instance method).

`protected` methods are defined within a class after calling the `Module#protected` method. Once called, `protected` makes all method definitions in the class `protected` from that point on unless another method access modifier is called.

For instance,

```ruby
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def older_than?(other_person)
    age > other_person.age
  end
  
  protected
  
  def age
    @age
  end
end

bill = Person.new("Bill", 175)
george = Person.new("George", 185)

puts bill.older_than?(george) # false
puts george.older_than?(bill) # true

bill.age # raises NoMethodError, protected method called outside the class
```

Here, we define a `Person` class on lines 1-16. The `older_than?` public instance method (lines 7-9)  makes use of the protected `age` method, which is defined after the call to `Module#protected` on line 11. `older_than?` has an `other_person` parameter; the method expects another `Person` object to be passed as argument. Within the `older_than?` body, on line 8, we call protected method `age` on the calling object and on the `Person` object that has been passed as argument. These two integers are compared using the `Integer#>` method, and the boolean return value forms the return value of `older_than?`. This works, as we can see on lines 21-22, because a `protected` method can be called within instance methods of the class on any object of the class, even if it is not the calling object. However, attempting to call the protected `age` method from outside the class, as on line 24, raises a `NoMethodError` exception.

`protected` methods are useful when we want to restrict access to the method from outside the class but need to allow a greater freedom of access between objects of the class.

**What are two rules of protected methods?**

There are two main rules of protected methods:

1. A protected method cannot be called from outside the class.
2. A protected method can be called by an object of the class on another object of the same class.

For instance,

```ruby
class Person
  def initialize(age)
    @age = age
  end
  
  def older?(other)
    age > other.age
  end
  
  protected
  
  def age
    @age
  end
end

bill = Person.new(45)
george = Person.new(23)

puts bill.older?(george) # true
puts george.older?(bill) # false

bill.age # NoMethodError raised, protected method called from outside the class 
```

Here, we define a `Person` class over lines 1-15. The `older?` method calls the protected method `age` on both the calling object and another `Person` object passed to the method as argument and assigned to parameter `other`. The call to `Module#protected` on line 10 means that the `age` method (defined on lines 12-14) is protected, and can be called on the `Person` object passed to the `older?` method as well as the calling object. This is demonstrated on lines 20-21. However, attempting to call the protected method `age` from outside the class, on line 23, raises a `NoMethodError` exception.

----

**Why is it generally a bad idea to override methods from the `Object` class, and which is commonly overridden?**

Custom classes implicitly inherit from the `Object` class. `Object` includes many methods that are key in Ruby's basic functionality, and all objects whose class inherits ultimately from `Object` have access to these methods.

However, because all methods in Ruby can be overridden by subclasses, it is important to be careful not to accidentally override critical methods inherited from `Object` as this can have confusing and far-reaching consequences.

For example, all objects whose class inherits from `Object` have access to the `Object#send` method. This is a critical method that offers an alternative way to invoke methods on an object, by explicitly passing a message to the object with `send` that consists of the name of the method to be invoked (as a symbol) and any arguments to be passed. If the `send` method is overridden, this disables a core piece of Ruby functionality:

```ruby
class Message
  attr_reader :text
  
  def intialize(text)
    @text = text
  end
  
  def display_message
    puts "*** #{message} ***"
  end

  def send
    # implementation to send message over network 
  end
end

greeting = Message.new("Hello world")
greeting.display_message # "*** Hello world ***"
greeting.send :display_message # raises ArgumentError, 0 expected, 1 given  
```

Here, in our `Message` class, we have accidentally overridden the `Object#send` method with a method that sends our message to a network destination. When we attempt to call `Object#send` on line 19, with the name of the `display_message` method passed as a Symbol argument, an `ArgumentError` is raised because the overriding `Message#send` method has no formal parameters and cannot accept the `:display_message` argument.

A method inherited from `Object` that *is* commonly overridden is the `Object#to_s` method. The default `Object#to_s`, implicitly inherited by custom classes, returns a string in the format `<ClassName:0x...>` where `ClassName` is the name of the object's class and `0x...` stands for an encoding of the object's `object_id`. It is very common to override this method to produce a more suitable string representation. `to_s` is implicitly called whenever an object is passed as argument to `Kernel#puts`, or when an object is interpolated into a string.

For instance,

```ruby
class Book
  def initialize(author, title)
    @author = author
    @title = title
  end
  
  def to_s
    "''#@title', by #@author"
  end
end

book = Book.new("Leo Tolstoy", "Anna Karenina")
puts book # "'Anna Karenina', by Leo Tolstoy"
```

Here, our `Book` class overrides `Object#to_s` on lines 7-8 with a more suitable string representation of a book object. This is then invoked implicitly when a `Book` object is passed to `puts` on line 13. `puts` calls the `Book#to_s` method, which is closer in the method lookup path than `Object#to_s`, and outputs the custom string representation.

When overriding `to_s` it is important to return a String object, or Ruby will call a `to_s` method further up the method lookup path to get a String return value; this is usually `Object#to_s`.

**What is the relationship between a class and an object?**

A class acts as a blueprint or template for objects. A class predetermines the attributes and behaviors of an object of the class. Objects are instantiated from classes using the `new` class method, which in turn calls the `initialize` instance method, the constructor method that sets the initial state of the instance. All Ruby objects are instances of some class.

Classes group behaviors and objects encapsulate state. The instance methods defined in the class, and the inheritance hierarchy of the class, determine what behaviors are available to an object. Each object of the class has its own set of instance variables that track the unique state of that object, distinct from the state of all other objects of the class.

**Explain the idea that a class groups behaviors**

A class is a collection of behaviors, which is to say a collection of methods. All the objects instantiated from a class have access to the instance methods predetermined by the class. The instance variables of an object, which are unique to that object, are initialized by the instance methods defined in the class, including the `initialize` constructor method. Until a method is called on the object that initializes an instance variable, the object will not possess that variable. In this sense, a class predetermines behaviors for its objects and those behaviors determine the set of *potential* instance variables the object might have.

Through class inheritance, a class also makes available to its objects the behaviors defined its superclass and the other classes in its inheritance chain. 

**Objects do not share state between other objects, but do share behaviors**

An object encapsulates state. Each object has its own set of instance variables that track the state unique to that object. The collaborator objects referenced by an object's instance variables comprise the state of a given object. In Ruby, the *potential* set of instance variables that can be initialized in an object is predetermined by the instance methods that an object has access to. When an instance method initializes an instance variable of a given name in an object, that instance variable is unique to the object, although other objects of the same class might have identically-named instance variables tracking their own individual states. In this way, every object of a class has its own unique state, distinct from that of all other objects of the class. 

For example,

```ruby
class Cat
  def initialize(name)
    @name = name
  end
  
  def speak
    "#{@name} says meow"
  end
end

whiskers = Cat.new("Whiskers")
felix = Cat.new("Felix")

whiskers.speak # "Whiskers says meow"
felix.speak    # "Felix says meow"
```

Here, we define a `Cat` class on lines 1-11. All `Cat` objects have access to the behavior defined in the `Cat` class. However, the `whiskers` instance has a separate state from the `felix` instance. When they are each initialized by the same `Cat#initialize` method, the individual `@name` instance variable for each instance is set to the string passed as argument for that particular call to the `Cat::new` method (lines 11-12). On line 14, the `Cat#speak` method is called on the `whiskers` instance, returning a string involving interpolation of information about that particular instance's state: `"Whiskers says meow"`. On line 15, the exact same `Cat#speak` method is called on `felix`, with identical behavior except the interpolated state is different, since the instances have their own separate state: `"Felix says meow"`.

An object's behavior is predetermined by its class, where the instance methods available to the object are defined. A class may also inherit behavior from its superclass and the rest of the inheritance hierarchy. All objects of a class have access to the same set of instance methods predetermined by the class.

An object's instance variables are initialized by its instance methods and so the instance variables will have the same names as the instance variables of other instances of the class, but the variables are scoped at the instance level and are unique to that instance, thus keeping track of the object's individual state.

 **The values in the objects' instance variables (states) are different, but they can call the same instance methods (behaviors) defined in the class**

An object's behavior is determined by its class. All objects of a class have access to the same set of instance methods defined in the class, and those defined in the classes and modules that the class inherits from.

An object's instance variables are scoped at the object level, and therefore are unique to that object, tracking its individual state. An object only has the instance variables that its instance methods (including the constructor) initialize. Since all objects of a class have access to the set of instance methods predetermined by the class, this means that their instance variables may have the same names, but they are completely distinct variables in distinct scopes.

For example,

```ruby
class Cat
  def initialize(name)
    @name = name
  end
end

tom = Cat.new("Tom")
felix = Cat.new("Felix")

p tom # <Cat:0x... @name="Tom">
p felix # <Cat:0x... @name="Felix">
```

Here we can see that the two objects of the `Cat` class (defined on lines 1-5)  that are instantiated on lines 7-8 both have an instance variable called `@name`, which is initialized by the `initialize` constructor instance method (lines 2-4) called by the `Cat::new` class method when the objects are created. The `@name` variable is set to the object passed as argument to `new` and passed through to `initialize`. We can see from the output of passing these `Cat` instances to the `Kernel#p` method on lines 10-11 that each instance's `@name` variable references a different string object. Thus the shared method `initialize` has created unique instance variables in the `tom` and `felix` objects, and these distinct variables are tracking distinct state individual to the object.

**Classes also have behaviors not for objects (class methods)**

While classes contain instance method definitions, we can also define methods on the class itself, which are known as class methods. We do this by prefixing the name of the method being defined with either the name of the class, or with the keyword `self`. Inside the class definition but outside instance method definitions, `self` references the class.

Instance methods can only be called on an object of the class. We need to instantiate an object before the instance method can be called. Class methods cannot be called on the instances of the class. Instead, we call them on the class itself using the name of the class followed by dot operator method-call notation.

For example,

```ruby
class Temperature
  def self.celsius_to_fahrenheit(celsius) # defining a class method
    celsius * 9 / 5.0 + 32
  end
  
  # rest of the class omitted ...
end

# calling the class method:
p Temperature.celsius_to_fahrenheit(0) # 32.0
p Temperature.celsius_to_fahrenheit(100) # 212.0

# class method cannot be called on instance
temp = Temperature.new
temp.celsius_to_fahrenheit(100) # raises NoMethodError
```

Since objects encapsulate state, instance methods frequently involve persistent state. Class methods are therefore useful for methods that are logically related to the class but do not deal with state, especially the state of any particular object of the class.

Class methods may also be used to manipulate class variables, which track class-level information about the class as a whole. For instance,

```ruby
class Cat
  @@total_cats = 0

  def initialize(name)
    @name = name
    @@total_cats += 1
  end
  
  def self.number_of_cats
    @@total_cats
  end
end

puts Cat.number_of_cats # 0

kitty = Cat.new("Kitty")
whiskers = Cat.new("Whiskers")

puts Cat.number_of_cats # 2
```

Here, the `Cat` class defined on lines 1-12 initializes the class variable `@@total_cats` to `0` at the class level. Each time a new `Cat` is created, the `initialize` constructor instance method increments `@@total_cats`. If we want to view the number of `Cat` objects instantiated so far in the program, we can call the `Cat::number_of_cats` class method, defined on lines 9-11. This is demonstrated on line 14, and then again on line 19. The class method here returns information about the class rather than about any particular instance of the class.

**sub-classing from parent class. Can only sub-class from 1 parent; used to model hierarchical relationships**

Ruby is a single inheritance OO language, which means a class can only subclass from one superclass. A class can have as many subclasses as desired. Other languages have facilities for multiple inheritance, meaning a class can sub-class from multiple superclasses. In Ruby, this functionality is implemented instead via mixin modules.

The subclass is a specialized type with respect to the superclass. This means that the superclass defines general, highly-reusable behaviors, and the subclass defines more fine-grained, detailed behaviors. This can be implemented by defining additional methods in the subclass, or by method overriding. Method overriding is where a subclass defines a method with the same name as a superclass method, providing its own more fine-grained implementation. When that method name is invoked, the subclass method will be earlier in the method lookup path and so it is the subclass definition of the method that gets called.

The specialization of the superclass by a subclass represents an 'is a' relationship. It makes logical sense for the `Lizard` class to subclass from the `Reptile` class because a lizard is a more specific type of reptile. Class inheritance is therefore useful in modeling naturally hierarchical relationships between  entities in the problem domain. For instance, the following class hierarchy:

```ruby
class Animal
end

class Reptile < Animal
end

class Lizard < Reptile
end

class Snake < Reptile
end
```

**mixing in modules. Can mix in as many modules as needed; Ruby's way of implementing multiple inheritance**

Ruby is a single inheritance OO language, which means that a class can only subclass from one superclass. Some other languages have multiple inheritance, whereby a subclass can have multiple superclasses. Ruby provides similar functionality to multiple inheritance via mixin modules. Modules can be defined to contain instance methods and can then be 'mixed in' to a class via the `Module#include` method. Objects of the class will then have access to the instance methods deifned in the module. Whereas a class can only have one superclass, a class can mix in as many modules as necessary. This use of mixin modules is sometimes called 'interface inheritance'.

This can be very useful when a class hierarchy contains subclasses that share some behavior that cannot be extracted to any existing superclass without providing that behavior to classes that should not have it.

To illustrate,

```ruby
class Animal
end

class Fish < Animal
end

class MountainGoat < Animal
  def climb
    "I'm climbing"
  end
end

class Lizard < Animal
  def climb
    "I'm climbing"
  end
end
```

Here, the `climb` method required by class `MountainGoat` and class `Lizard` cannot be extracted to the common superclass `Animal` because not all Animals can climb. Doing so would provide the method to the `Fish` class, which should not be able to `climb`. However, the `climb` method is defined twice, which increases the chance of error, and inhibits maintainability. In order to reuses a single definition, we can extract the common behavior to a mixin module.

```ruby
module Climbable
  def climb
    "I'm climbing"
  end
end

class Animal
end

class Fish < Animal
end

class MountainGoat < Animal
  include Climbabale
end

class Lizard < Animal
  include Climbable
end

goat = MountainGoat.new
lizard = Lizard.new

puts goat.climb # "I'm climbing"
puts lizard.climb # "I'm climbing"
```

Mixin modules are conventionally given adjectival names often ending in `-able`, which express the behavior or ability provided by the module. Here, the `Climbable` module defines the `climb` method once, and then access to this method is provided by the calls to `Module#include` in the definitions of `MountainGoat` and `Lizard`, on line 14 and line 18. Lines 24-25, demonstrate that the `climb` instance method is now available to objects of both these classes.

**understand how sub-classing or mixing in modules affects the method lookup path**

When a method is invoked on an object, Ruby uses the method lookup path for that class of object in order to find a method of that name to call. Ruby will search the class for a method. When the class mixes in modules, Ruby will search the modules after searching the class. When there are multiple modules mixed in to a class, they will be searched in reverse order of the calls to `Module#include` that mixed them in. After the class and its modules have been searched, Ruby moves on to the superclass. This process repeats until the method is found, or the method lookup path is exhausted without finding a method. Since most Ruby classes inherit from class `Object`, the end of the method lookup path usually contains the `Object` class, then the `Kernel` module, that `Object` mixes in, and then `BasicObject`, the superclass of `Object`.

The method lookup path for an object can be found by calling the `Module#ancestors` method on the class of that object. `ancestors` returns an array of the classes and modules in the method lookup path in the order they will be searched.

For example,

```ruby
module Walkable
end

module Climbable
end

class Animal
end

class Cat < Animal
  include Walkable
  include Climbable
end

kitty = Cat.new
puts kitty.class.ancestors # [Cat, Climbable, Walkable, Animal, Object, Kernel, BasicObject]
```

Here, we define a class hierarchy with `Animal` as the superclass of `Cat`. `Cat` also mixes in the `Walkable` and `Climbable` modules. We instantiate a `Cat` object `kitty` on line 15. On line 16, we call the `class` method on `kitty`, which returns the `Cat` class, and call `ancestors` on `Cat`. The returned array contains the method lookup path. Ruby will search `Cat`, and then the last module included, `Climbable`. Next it searches the first module included, `Walkable`. This means that if there were a method with the same name defined in both modules, the definition in the last module included, `Climbable`, would be the method called. After the modules, comes the superclass `Animal`. Since `Animal` has no explicit superclass, it implicitly inherits from `Object`, which includes `Kernel` and subclasses from `BasicObject`.

----

What will the following code output?

```ruby
class Animal
  def initialize(name)
    @name = name
  end

  def speak
    puts sound
  end

  def sound
    "#{@name} says "
  end
end

class Cow < Animal
  def sound
    super + "moooooooooooo!"
  end
end

daisy = Cow.new("Daisy")
daisy.speak
```

The `Animal` class is defined on lines 1-13. The `initialize` method sets instance variable `@name` to the argument passed through from `Animal::new`, `name`. The `Animal#speak` instance method calls the `Animal#sound` method and passes the return value to `Kernel#puts` (line 7). The `Animal#sound` method returns a string with `@name` interpolated into it: `"#{@name} says "`.

The `Cow` class, defined on lines 15-19, inherits from the `Animal` class. `Cow` overrides `Animal#sound` with its own `sound` definition on lines 16-18. The `super` keyword calls `Animal#sound` and then the string `"moooooooooo!"` is concatenated to it. The resulting string is the last evaluated expression and so forms the return value.

On line 21, we instantiate `Cow` object with the string `"Daisy"` passed as argument to `Cow::new`. This method invocation calls the `initialize` method defined in the superclass `Animal`, so the string `"Daisy"` is used to initialize the `@name` instance variable in our new `Cow` object. So when the `Cow#speak` method is called on `daisy` on line 22, the output will be `"Daisy says moooooooooo!"`. This string is the result of `Cow#sound` concatenating the return value of its superclass method to the hard-coded string.

7m15s	

---

What code snippet can replace the "omitted code" comment to produce the indicated result? 

```ruby
class Person
  attr_writer :first_name, :last_name

  def full_name
    # omitted code
  end
end

mike = Person.new
mike.first_name = 'Michael'
mike.last_name = 'Garcia'
mike.full_name # => 'Michael Garcia'
```

The `Person` class is defined on lines 1-7, with getters and setters generated for the `:first_name` and `:last_name` attributes with a call to `Module#attr_accessor` on line 2. The `full_name` method defined on lines 4-7 has an empty definition body and so currently returns `nil`.

The `Person#full_name` method call on line 12 suggests that `full_name` should return the strings returned by `Person#first_name` and `Person#last_name`  concatenated around a single space.

One solution would be:

```ruby
class Person
  # code omitted
  def full_name
    first_name + ' ' + last_name
  end
  # code omitted
end
```

4m59s

---

The last line in the above code should return "A". Which method(s) can we add to the Student class so the code works as expected?

```ruby
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade # => "A"
```

The `Student` class is defined on lines 1-8. The call to `Module#attr_accessor` on line 2 generates setter and getter methods, for the `:name` and `:grade` attributes. The `Student#initialize` method (defined lines 4-7) takes one parameter `name`. The body of the definition sets `@name` to the reference of `name` and `@grade` to `nil`.

The call to the non-existent `Student#change_grade` method, and the suggested output for `grade`, imply that `change_grade` should set the `@grade` instance variable. One solution would be:

```ruby
class Student
  # code omitted
  
  def change_grade(new_grade)
    self.grade = new_grade
  end
  
  # code omitted
end
```

5m11s

---

In the example above, why would the following not work?

```ruby
def change_grade(new_grade)
 grade = new_grade
end
```

The problem with the `Student#change_grade` implementation given is that without being called on an explicit receiver the syntax for calling `Student#grade=` cannot be disambiguated from the initialization of a new local variable `grade`, which is currently what this method does. In order to disambiguate the setter method invocation, we can call `grade=` explicitly on `self`:

```ruby
def change_grade(new_grade)
  self.grade = new_grade
end
```

----

On which lines in the following code does self refer to the instance of the MeMyselfAndI class referenced by i rather than the class itself? Select all that apply.

```ruby
class MeMyselfAndI
  self

  def self.me
    self
  end

  def myself
    self
  end
end

i = MeMyselfAndI.new
```

The `MeMyselfAndI` class is defined over lines 1-11. The `self` reference on line 2 is within the class definition but outside any instance method definition, so `self` references the `MyMyselfAndI` class. This is also true of the `self` on line 5, since this takes place within a class method definition `MeMyselfAndI::me`.

The reference to `self` on line 9 is within the context of an instance method definition, `MyMyselfAndI#myself`. This references the calling object. So when `myself` is called on the `MeMyselfAndI` object instantiated on line 13 and used to initialize local variable `i`, the reference will be to object `i`, not the class itself.

3m58s

---

Given the below usage of the Person class, code the class definition.

```ruby
bob = Person.new('bob')
bob.name                  # => 'bob'
bob.name = 'Robert'
bob.name                  # => 'Robert'
```

The `Person` class will need an `initialize` method that takes one parameter and sets and instance variable to the string object passed on, as is clear from lines 1 and 2.  Lines 2-3 imply the need for getter and setter methods for a `name` attribute, referencing and setting the same instance variable initialized in the constructor. The following class definition would satisfy the client code:

```ruby
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end
```

2m49s

---

Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

```ruby
bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'
```

Hint: let first_name and last_name be "states" and create an instance method called name that uses those states.

Line 2 suggests that the `Person#name` method still exists, but lines 4-6 suggest that it now returns the strings tracked by the `first_name` and `last_name` attributes concatenated around a string containing a single space. Lines 1-3 could suggest that the constructor method only sets the `first_name` attribute, but it seems more likely that a full name could be given when instantiating a `Person` object, in which case both `@first_name` and `@last_name` could be set, and that there would be some logic to deal with a case like the above where only a single name is given.

One solution would be:

```ruby
class Person
  attr_accessor :first_name, :last_name
  
  def initialize(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
  
  def name
    "#{first_name} #{last_name}".strip
  end
end
```

8m08s

I'm not sure this is right - it's a better `initialize` method than it needs to be, and you should probably just write the bare minimum class that makes the driver code work. So something like:

```ruby
class Person
  attr_accessor :first_name, :last_name
  
  def initialize(first_name)
    @first_name = first_name
    @last_name = ''
  end
  
  def name
    "#{first_name} #{last_name}".strip
  end
end
```

----

```ruby
class Person
  attr_accessor :first_name, :last_name
  
  def initialize(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
  
  def name
    "#{first_name} #{last_name}".strip
  end
  
  def name=(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
end
```

----

Using the class definition from step #3, let's create a few more people -- that is, Person objects.

```ruby
bob = Person.new('Robert Smith')

rob = Person.new('Robert Smith')
```

If we're trying to determine whether the two objects contain the same name, how can we compare the two objects?

In order to compare objects of custom classes by their values, we can override the `Object#==` method with a custom implementation that compares the value of the object we deem the most significant. The `==` method is used by Ruby's core classes to compare the significant values of two objects. The given driver code shows that the objects instantiated on lines 1 and 3 are distinct objects of the same class with identical (but again distinct) String objects as values. Therefore we need to compare the significant values of two distinct objects, and the `==` method is the conventional way to test for this form of equality.

 In this case, we could compare return value of the `Person#name` method using the `String#==` method to produce a boolean return value for `Person#==`. The `String#==` method performs character-wise comparison on the two strings being compared, returning `true` only if both strings have the same length and the same character at each index of the string, `false` otherwise.

Our implementation might look like this:

```ruby
class Person
  attr_accessor :first_name, :last_name
  
  def initialize(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
  
  def name
    "#{first_name} #{last_name}".strip
  end
  
  def name=(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
  
  def ==(other)
    name == other.name
  end
end
```



Continuing with our Person class definition, what does the below print out?

```ruby
bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"
```

As defined so far, the above code would output `"The person's name is: <Person:0x...>"` (where `0x...` is an encoding of the object id). This is because string interpolation implicitly calls `to_s` on an interpolated object or expression and we have not defined `to_s` in our `Person` class, so the default `Object#to_s` method is used. `Object#to_s` returns a string in the format `<ClassName:0x...>` where `ClassName` is the name of the class and `0x...` is an encoding of the object id.

**Let's add a `to_s` method to the class**

In order to provide a more meaningful string representation for a `Person`, we can override the `to_s` method.

```ruby
class Person
  attr_accessor :first_name, :last_name
  
  def initialize(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
  
  def name
    "#{first_name} #{last_name}".strip
  end
  
  def name=(name)
    @first_name, @last_name = name.split
    @last_name ||= ''
  end
  
  def ==(other)
    name == other.name
  end
  
  def to_s
    name
  end
end
```

This solution uses the string return value of the `Person#name` method to provide a string representation of the object. When overriding `to_s`, it is important to be sure to return a String object, since otherwise Ruby will implicitly call a method higher up the method lookup path in order to provide a String return for `to_s`; usually, this is `Object#to_s`.

**Now, what does the below print out?**

```ruby
bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"
```

Since the `Person#to_s` method returns the return value of `Person#name`, the call to `puts` on line 2 will output: `"The person's name is: Robert Smith"`

---

```ruby
class Wedding
  attr_reader :guests, :flowers, :songs

  def prepare(preparers)
    preparers.each do |preparer|
      case preparer
      when Chef
        preparer.prepare_food(guests)
      when Decorator
        preparer.decorate_place(flowers)
      when Musician
        preparer.prepare_performance(songs)
      end
    end
  end
end

class Chef
  def prepare_food(guests)
    # implementation
  end
end

class Decorator
  def decorate_place(flowers)
    # implementation
  end
end

class Musician
  def prepare_performance(songs)
    #implementation
  end
end
```

The above code would work, but it is problematic. What is wrong with this code, and how can you fix it?

The `Wedding#prepare` method (lines 4-15) uses type checking in the form of testing for which class an object passed as argument belongs to. It does so by using a `case` statement (lines 6-13), which implicitly calls the `===` method to check if an object is a member of a class. The way this code is structured, in order to add more `preparer` classes, we would need to alter the `Wedding#prepare` method as well as creating the new class. If we did this enough times, the `Wdding#prepare` method would become extremely long and possibly error-prone. Moreover, each `when` clause needs to know both the name of the class and the name of the specific method that takes a specific attribute of `Wedding` as argument.

We can restructure this code to be more maintainable and to have fewer code dependencies by employing polymorphism through duck typing.

```ruby
class Wedding
  attr_reader :guests, :flowers, :songs
  
  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare(self)
    end
  end
end

class Chef
  def prepare(wedding)
    prepare_food(wedding.guests)
  end
  
  def prepare_food(guests)
    # implementation
  end
end

class Decorator
  def prepare(wedding)
    decorate_place(wedding.flowers)
  end
  
  def decorate_place(flowers)
    # implementation
  end
end

class Musician
  def prepare_wedding(wedding)
    prepare_performance(wedding.songs)
  end

  def prepare_performance(songs)
    #implementation
  end
end
```

Now the `Wedding#prepare` method can accept objects of any type so long as they respond appropriately to a simple, common interface. That is to say, an object can be treated like a `preparer` so long as it exposes a compatible `prepare` method that can accept the calling `Wedding` object as argument (referenced by `self`, line 6). Our three unrelated classes now have a `prepare` method each, which acts as a wrapper around their more specific function, e.g. `Chef#prepare` (defined on lines 12-14) calls the `Chef#prepare_food` method (lines 16-18).

----

**What happens when you pass an object to the `p` method? And the `puts` method?**

When an object is passed to the `Kernel#p` method, the `inspect` method is implicitly called on the object to return a detailed string representation. For custom classes, the default inherited `inspect` will be `Object#inspect`. The `Object#inspect` method returns a string of the form `<ClassName:0x... @var1="value 1", @var2="value 2" ...>`, where `ClassName` is the name of the calling object's class, `0x...` is an encoding of the object id, and `@var1="value 1", @var2="value 2" ...`  is a list of the object's instance variables and their current values (the string representations of which are returned by implicitly calling `inspect` on each value).

When an object is passed to the `Kernel#puts` method, the `to_s` method is implicitly called on the object to return a string representation. For custom classes, the default inherited `to_s` is `Object#to_s`, which returns a string of the form `<ClassName:0x...>`, which is the same as the `Object#inspect` method without the list of instance variables and their values. Since the `to_s` method is implicitly called by `puts` and in string interpolation, and the name of the method specifically signifies conversion to a String, it is more commonly overridden by custom classes than `inspect`.

As an example,

```ruby
class Tree # a simple custom class
  def initialize(type)
    @type = type
  end
end

willow = Tree.new("willow")
p willow # <Tree:0x... @type="willow">
puts willow # <Tree:0x...>

class Cat # a class that overrides `to_s`
  def initialize(name)
    @name = name
  end
  
  def to_s
    "a cat called #{@name}"
  end
end

jinx = Cat.new("Jinx")
p jinx # <Cat:0x... @name="Jinx">
puts jinx # "a cat called Jinx"
```

When overriding `to_s`, we must return a String object. Otherwise, if we attempt to return some other class of object, then whenever `to_s` is called implicitly by `puts` or string interpolation, Ruby will search for a `to_s` method further up the method lookup path and implicitly call that method in order to return a String object; usually this is `Object#to_s`. For instance,

```ruby
class Cat # a class that overrides `to_s` but attempts to return an Integer
  def initialize(name)
    @name = name
  end
  
  def to_s
    "a cat called #{@name}"
    42 # attempting to return Integer
  end
end

jinx = Cat.new("Jinx")
puts jinx # <Cat:0x...> (returned by `Object#to_s`)
```

----

**What is a spike?**

Since it can be difficult to know exactly how to break a problem down into classes and methods, a code spike is sometimes used very early on in the design process. A spike is exploratory code, an experimental sketch whose purpose is to validate or invalidate initial assumptions about how to model the problem in classes, methods, and the relationships between classes. Code quality is unimportant since the spike will not be used except as a testing-ground for ideas. The spike should help you to understand the problem better and help you analyze the problem into workable class and method structures.

**When writing a program, what is a sign that you're missing a class?**

If your program contains several methods whose names contain the same noun, it is often a sign that we are missing a class. This is to say that it may well be better to encapsulate part of the logic into a class. For instance, if we had instances of a `Document` class which stores the `publication_date` attribute as an array, we might need several helper methods to deal with the return value of `Document#date`.

```ruby
document1.publication_date = [2024, 3, 23]
document2.publication_date = [2002, 5, 16]

puts "#{document1.title} was published on" \
			 "#{format_publication_date(document1.date)}"
puts "#{document1.title} was published on" \
  		 " #{format_date(document1.date)}"

if compare_publication_date(document1.date, document2.date) < 0
  puts "#{document1.title} was published earlier than #{document2.title}"
elsif compare_publication_date(document1.date, document2.date) > 0
  puts "#{document1.title} was published later than #{document2.title}"
else
  puts "#{document1.title} and #{document2.title} were published on the same day"
end
```

In this short piece of code, we have two helper methods, `format_publication_date` (lines 4-5) and `compare_publication_date` (line 7 and line 9), which are needed to process or compare the Array object returned by `Document#publication_date`. The recurrence of the term `publication_date` in the names of these methods points toward a missing class.

Encapsulating the logic and the representation of the date into a custom `PublicationDate` class allows us to write more readable code in which the methods pertaining to the `publication_date` can be logically grouped together.

```ruby
document1.publication_date = PublicationDate(2024, 3, 23)
document2.publication_date = PublicationDate(2002, 5, 16)

puts "#{document1.title} was published on #{document1.publication_date.display}"
puts "#{document1.title} was published on #{document1.publication_date.display}"

if document1.publication_date < document2.publication_date
  puts "#{document1.title} was published earlier than #{document2.title}"
elsif document1.publication_date > document2.publication_date
  puts "#{document1.title} was published later than #{document2.title}"
else
  puts "#{document1.title} and #{document2.title} were published on the same day"
end
```

The top-level method `format_publication_date` becomes `PublicationDate#display` and the logic contained in `compare_publication_date` and its slightly cryptic return value is encapsulated into the more comprehensible pair of operator-methods `PublicationDate#<` and `PublicationDate#>`

---

**What are some rules/guidelines when writing programs in OOP?**

The link says:

* Explore the problem before design - do a spike
* Repetitive nouns in method names is a sign that you're missing a class - encapsulate logic in collaborator class



* When naming methods, don't include the class name - name methods so that they read well at invocation, use consistent naming conventions, think about the interface of the method

```ruby
# bad
class Customer
  def customer_details
    # returns a string containing information about the customer
  end
end
# ...
# when we call the method, we can end up with this:
puts customer1.customer_details
```

```ruby
# good
class Customer
  def details
    # returns a string containing information about the customer
  end
end
# ...
# when we call the method, this reads more fluently:
puts customer1.details
```

Most of the time the method call will read more naturally without the class name in the method name. We need always to consider the interface of a method, how it will be invoked by client code. Use consistent naming conventions that are easy to remember, that have explanatory value as to what the method will do, and that read fluently at the point of invocation. 

* Avoid long method invocation chains

Long chains of method invocations on the return values of previous method invocations can make for concise but brittle code. If any method in the chain returns an unexpected value -- most frequently `nil` -- then the entire chain will break down. Accounting for the possibility of a `nil` return is much more difficult in this situation than if we had broken up the chain by initializing variables. For instance,

```ruby
player1.details.text.name
```

This line of code is brittle. If `player1.details` returns `nil`, then we will be attempting to call `text` on `nil`, which will raise a `NoMethodException`. Instead, we could break up the chain using variables to test for a `nil` return.

```ruby
details = player1.details
puts details.text.name if details
```

* Avoid design patterns for now

"Premature optimization is the root of all evil". This phrase can apply to optimizing for flexibility as much as performance. Therefore, it is better to avoid attempting to optimize our code for 'best practices' by mis-applying 'design patterns' that we do not have the understanding or context yet to apply well.

---

Why does this code not have the expected return value?

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
  end
end

ade = Student.new('Adewale')
ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

Our `Student` class is defined on lines 1-7, with an `initialize` constructor method (lines 4-7). The second parameter of this method `grade` has a default value of `nil`. It is important to remember that the parameters `name` and `grade` are local variables that will cease to exist after the method returns. 

An implicit call to `Student#initialize`  is made on line 9, when the `new` class method is called on `Student`. There is only one argument passed to `new`, the string `'Adewale'`, which will be passed through to the `initialize` method. 

On this invocation, the `name` parameter will be initialized to `'Adewale'`, while the `grade` parameter is initialized to its default value `nil`. Within the body of the method definition, a `@name` instance variable is initialized to the reference of local variable `name`, the string `'Adewale'`. This is the only instance variable initialization in `initialize`. Therefore, no `@grade` instance variable exists in the object when it is instantiated. This is why the list of instance variables in the `inspect` string returned by line 10 does not include `@grade=nil`.

In order to rectify this, we can change the `Student#initialize` method to the following:

```ruby
class Student
  # ...
  def initialize(name, grade=nil)
    @name = name
    @grade = grade
  end
end
```

9m01s

---

What change(s) do you need to make to the above code in order to get the expected output?

```ruby
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

sir_gallant = Knight.new("Gallant")
sir_gallant.name # => "Sir Gallant"
sir_gallant.speak # => "Sir Gallant is speaking."
```

We have two classes, a superclass `Character` (defined lines 1-11) and its subclass `Knight` (lines 13-17).

The superclass `initialize` method takes one parameter, `name`, which is used to initialize the instance variable `@name`. The `Knight` subclass inherits this method. The `Knight` class overrides the simple `name` getter method for the `@name` instance variable, defined in `Character` on line 2 (with a call to the `Module#attr_accessor` method) with the method `Knight#name` that is defined on lines 14-16.  The method body (line 15) prepends the string `"Sir "` to the return value of calling `Character#name` via the `super` keyword.

The problem is with the `speak` method, that `Knight` inherits from `Character`, defined on lines 8-10. The string it returns involves an interpolation of a direct reference to the `@name` instance variable rather than a call to the `name` getter method. This means the functionality from `Knight#name` is not used, and so the invocation on a `Knight` object of `speak`, on line 21, does not return the expected string. We can solve this problem by changing the `Character#speak` method definition as follows:

```ruby
class Character
  # code omitted ...
  def speak
    "#{name} is speaking."
  end
end
```

8m31s

---

Make the changes necessary in order for this code to return the expected values.

```ruby
class FarmAnimal
  def speak
    "#{self} says "
  end
end

class Sheep < FarmAnimal
  def speak
    super + "baa!"
  end
end

class Lamb < Sheep
  def speak
    "baaaaaaa!"
  end
end

class Cow
  def speak
    super + "mooooooo!"
  end
end

Sheep.new.speak # => "Sheep says baa!"
Lamb.new.speak # => "Lamb says baa!baaaaaaa!"
Cow.new.speak # => "Cow says mooooooo!"
```

Our `FarmAnimal` class (defined on lines 1-5) is subclassed by `Sheep` (7-11). Class `Lamb` (lines 13-17) in turn subclasses `Sheep`. `Cow` (19-23) does not currently inherit from any of our custom classes.

When we call the `Sheep#speak` method, which overrides `FarmAnimal#speak`, on an instance of `Sheep` (line 25 ), it produces an unexpected value. The `Sheep#speak` method calls the `FarmAnimal#speak` method via the `super` keyword (on line 9) and appends the string `"baa!"` to produce its return value. Unfortunately, `FarmAnimal#speak` neglects to call `class` on `self` on line 3, which means the object interpolated in the string it returns is a representation of the instance rather than the name of the class.

The `Lamb#speak` method, which overrides `Sheep#speak`, fails to make a call to its `super` method `Sheep#speak`, and so it simply returns the string `"baaaaaaa!"` (line 15). Thus when we call `Lamb#speak` on a `Lamb` instance (line 26), we get an unexpected return value.

`Cow#speak` is more problematic still, since the definition (lines 20-23) attempts to call a `super` method named `speak` even though `Cow` does not subclass a class with this method. So when we call `Cow#speak` on a `Cow` instance (line 27), we raise a `NoMethodError`.

To fix this, we can change the `FarmAnimal#speak` method to reference the class rather than the instance. Then we need `Cow` to inherit from `FarmAnimal` and we need `Lamb#speak` to prepend the return value of calling `super` to its string literal.

```ruby
class FarmAnimal
  def speak
    "#{self.class} says "
  end
end

class Sheep < FarmAnimal
  def speak
    super + "baa!"
  end
end

class Lamb < Sheep
  def speak
    super + "baaaaaaa!"
  end
end

class Cow < FarmAnimal
  def speak
    super + "mooooooo!"
  end
end

p Sheep.new.speak # => "Sheep says baa!"
p Lamb.new.speak # => "Lamb says baa!baaaaaaa!"
p Cow.new.speak # => "Cow says mooooooo!"
```

13m07s

----

Identify all custom defined objects that act as collaborator objects within the code. 

```ruby
class Person
  def initialize(name)
    @name = name
  end
end

class Cat
  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

sara = Person.new("Sara")
fluffy = Cat.new("Fluffy", sara)
```

We define a `Person` class on lines 1-5, and a `Cat` class on lines 7-12.

The `Person` class contains one instance method, the constructor `Person#initialize`. This method is defined with one parameter, `name`, that is used to initialize the instance variable `@name` in the body of the method definition.

The `Cat` class also defines only one instance method, again the constructor `Cat#initialize`. This method takes two parameters, `name` and `owner`, and the body of the definition uses these to initialize the `@name` and `@owner` instance variables.

On line 14, we instantiate a new `Person` object to be used to initialize local variable `sara`. The argument to the `Person::new` method, which is passed through to `Person#initialize`, is a String object, `"Sara"`. This String becomes a collaborator object for the `sara` `Person` object, tracked by the `@name` instance variable.

On line 15, we instantiate a `Cat` object, which variable `fluffy` is initialized to, passing two arguments to the constructor. The first argument, the String `"Fluffy"` is used to initialize the `@name` instance variable. This is a collaborator object for `fluffy`. The second argument, used to initialize `@owner`, is the `sara` `Person` object. Therefore, `sara` is also a collaborator object of `fluffy`.

7m33s

---

**How does equivalence work in Ruby?**

In Ruby, testing for equivalence is generally a question of calling methods that look like operators, but which are methods defined in specific classes.

`BasicObject#==`

The most commonly used form of equivalence testing in Ruby is the `==` method. The `==` method is conventionally defined to test for object value equivalence. This means that `==` method is generally used to test whether two different objects have the same value. 

The `==` method is inherited from `BasicObject#==` unless overridden. It is commonly overridden by Ruby core and standard library classes, since the value `BasicObject#==` uses for comparison is the object id. Classes override `==` in order to specify which value encapsulated in their objects should be used for comparison. For String objects, this is their string value, and so on.

Like other fake operator methods, which `==` method is called will be determined by the class of the calling object (the left-hand operand).

```ruby
string1 = "string value"
string2 = "string value"
string3 = "some other value"

puts string1 == string2 # true
puts string2 == string1 # true
puts string1 == string1 # true

puts string1 == string3 # false
puts string2 == string3 # false
```

In order to override `==` in our own classes, we define it as a method and specify the value to be used for comparison. The comparison is generally done by the `==` method of a built-in class. 

For instance,

```ruby
class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end
  
  def ==(other)
    name == other.name
  end
end

cat1 = Cat.new("Fluffy")
cat2 = Cat.new("Fluffy")

puts cat1 == cat2 # true
```

Our `Cat` class overrides the `BasicObject#==` method in order to compare `Cat` objects based on their `name` attribute. Since we set `@name` to String objects when constructing our `Cat` objects (lines 13-14), in practice `String#==` is used by `Cat#==` in order to determine the return value when we call `Cat#==` on line 16.

Certain classes, especially Numeric classes, can compare values across classes using implicit conversion. For instance, we can compare the values of an Integer and a Float:

```ruby
42 == 42.0 # true
42.0 == 42 # true
```

On line 1, the `Integer#==` method is called, and on line 2, the `Float#==` method is called. Both methods are capable of converting between Integer and Float values in order to compare them.

When we define the `==` method, a corresponding `!=` method is automatically generated for us.

`BasicObject#equal?`

The `equal?` method, inherited from `BasicObject` tests for equivalence based on object equality. This means that it returns `true` only if both the caller and argument are the same object. Essentially, it is defined to test equivalence based on unique `object_id` value, and because of the function it serves, `equal?` should not be overridden. It is generally used to test if the object referenced by one variable is the same object that is referenced by another variable; it returns `true` if both variables point to the same object.

```ruby
string1 = "string value"
string2 = "string value" # different String object with same value

string1.equal?(string2) # false, they point to different String objects
string1.object_id == string2.object_id # false

string3 = string1 # both variables point to the same String object
string1.equal?(string3) # true
string1.object_id == string3.object_id # true
```

Certain built-in classes of immutable object can only have one instance with any given value. This is true for Symbol and Integer objects. Therefore, object equivalence for these classes will always correspond to object value equivalence.

```ruby
symbol1 = :symbol_value
symbol2 = :symbol_value
symbol1.equal?(symbol2) # true
symbol1 == symbol2 # true
symbol1.object_id == symbol2.object_id # true
```

`Object#===`

The `===` method is most often used implicitly by `case` statements, rather than being called explicitly. The conventional meaning of the `===` method is to check whether the argument object belongs in the group that the calling object represents. For instance,

```ruby
(1..10) === 5 # true
(1..10) === 50 # false

String === "a string object" # true
String === 42 # false
```

The default `Object#===` method is overridden by many built-in classes but is less commonly overridden by custom classes since the main use case for `===` is in `case` statements.

The `case` statement,

```ruby
x = 55

case x
when (1..50)
  puts "small number"
when (50..100)
  puts "large number"
end
# "large number"
```

is equivalent to

```ruby
x = 55

if (1..50) === x
  puts "small number"
elsif (50..100) === x
  puts "large number"
end
# "large number"
```

`Object#eql?`

The `eql?` method is inherited from `Object`. The `eql?` method generally determines if two objects have the same value *and* are of the same class. The `eql?` method is mainly used implicitly by the `Hash` class to determine equality among its members. It is not very commonly overridden by custom classes.

---



















