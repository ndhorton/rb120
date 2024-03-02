**<u>Class Inheritance, Encapsulation, Polymorphism</u>**

**<u>Ruby OOP book</u>**

"Object Oriented Programming... is a programming paradigm that was created to deal with the growing complexity of large software systems. Programmers found out very early on that as applications grew in complexity and size, they became very difficult to maintain. One small change at any point in the program would trigger a ripple effect of errors due to dependencies throughout the entire program"

problem: maintainability at scale (size and complexity)

why: dependencies throughout program means that a change in one place can affect many other places

solution: 

"Programmers needed a way to create **containers for data that could be changed and manipulated without affecting the entire program**. They needed **a way to section off areas of code that performed certain procedures so that their programs could become the interaction of many small parts, as opposed to one massive blob of dependency**"

An object is a container for data that can be changed and manipulated without affecting the entire program

Wikipedia article on OO design: "An object contains encapsulated data and procedures grouped together to represent an entity. The 'object interface' defines how the object can be interacted with. An object-oriented program is described by the interaction of these objects."

So an object is a container for data grouped with procedures that presents an interface for other objects to interact with it. Object-oriented programming is composing a program that consists of the interaction of these objects.



An object sections off state from the overall program state, reducing dependencies and making the program easier to maintain. The object is thus serving encapsulation: in the sense of being a container for data that can be manipulated or changed without affecting the entire program, and in the sense of being a way to section off areas of code that perform certain procedures so that the program can become the interaction of many small parts, as opposed to one blob of dependency.

So we do have the sense of encapsulation (or objects in the concrete sense of encapsulation as implemented in Ruby) as

1. data hiding, restricting and controlling access to state and functionality
2. bundling or sectioning off data with procedures that operate on and with that data



Interface: the messages an object will respond to

Objects respond to messages by calling sectioned off areas of code that are known to certain objects and can only be called by sending a message to some object



----

**What is OOP and why is it important?**

* OOP is a programming paradigm that attempts to solve the problems of building and maintaining large and complex software systems
* As procedural programs grew in size and complexity, the myriad of dependencies throughout a program could make it hard to change any part of the codebase without adverse effects rippling out to many other parts
* OOP attempts to solve this problem by providing a way to create containers for data that can be changed and manipulated without affecting the rest of the program, and a way to section off areas of code from the rest of the codebase, so that a program becomes the orchestrated interaction of discrete parts, rather than a mass of dependency
* OOP thus attempts to reduce dependencies and avoid the problems of shared state in large, complex programs
* OOP also allows the programmer to think at a higher level of abstraction. Objects can represent domain-level 'nouns' or entities and can perform actions corresponding to the domain-level behavior the programmer wishes to model.
* In Ruby, this is achieved through a combination of *encapsulation* and *polymorphism*, facilitated by *inheritance*

-----

**What is OOP and why is it important?**

* OOP is a programming paradigm that aims to solve the difficulties of building and maintaining large and complex software systems
* As procedural programs grew in scale and complexity, a program could become a web of closely-knotted dependencies, making it difficult to change one part of the codebase without adverse effects rippling out to many other parts
* OOP attempts to obviate this problem by providing a way to create containers for data that can be changed or manipulated without affecting other parts of the program, and a way to section off areas of code from the rest of the program so that the program becomes the orchestrated interaction of small, discrete parts, rather than a mass of dependency
* OOP thus attempts to reduce dependencies and avoid the problems of shared state in large, complex software projects
* OOP also allows the programmer to think on a higher level of abstraction. Objects can represent domain-level 'nouns' or entities, and objects can act in ways that correspond to the domain-level behaviors the programmer wishes to model
* In Ruby, this is achieved through a combination of encapsulation and polymorphism, facilitated by inheritance.

----

Both encapsulation and polymorphism seem involved in this description of OOP. Polymorphism allows dependencies to be "inverted", so that modules of code depend on interfaces that can be resolved to the specific implementation at runtime rather than knowledge of each other's source code directly.

```ruby
f(o) # we need to have function f() imported/included/required, or else what is f()?
o.f() # we don't need to know what o is; we don't need to know where f() is defined
```

So the dependency changes

from: main -> module containing `f()`

to: main -> interface that specifies signature `f()` <- module where class of `f()` is defined

Both the main program and the module need to know about the interface but not each other

 Encapsulation means that an object can bear a polymorphic function to facilitate polymorphism. Inheritance also facilitates polymorphism.

So inheritance facilitates 

----

**Encapsulation**

"**Encapsulation** is hiding pieces of functionality and making it unavailable to the rest of the code base."

So defining methods in classes/on objects and controlling access to those methods. Separating implementation from interface. ("section off areas of code that perform certain procedures so that their programs could become the interaction of many small parts, as opposed to one massive blob of dependency")

"It is a form of data protection, so that data cannot be manipulated or changed without obvious intention."

So avoiding the problems of shared state, tracking state at a discrete, cellular level rather than globally ("a way to create containers for data that can be changed and manipulated without affecting the rest of the program")

Essentially, lots of little programs interacting, like computers on a network

"It is what defines the boundaries in your application and allows your code to achieve new levels of complexity."

"Ruby, like many other OO languages accomplishes this task by creating objects, and exposing interfaces (i.e., methods) to interact with those objects"



Encapsulation is hiding pieces of functionality from the rest of the code base (separating implementation from interface, private and protected methods).



Encapsulation is a form of data protection, so that data cannot be manipulated or changed without obvious intention (encapsulation of state, instance variables can only be accessed through the interface provided).



Encapsulation defines the boundaries in a program and allows your code to achieve new levels of complexity (separation of implementation from interface, localization of persistent state rather than shared state, the interaction of small parts, permitting abstraction of functions and variables to a 'noun' with attributes and behaviors)



* Encapsulation involves hiding pieces of functionality from the rest of the code base. Encapsulation thus separates interface from implementation
* Encapsulation is a way to protect data from being manipulated or changed without deliberate intent.
* Encapsulation sections off data and functionality, allowing the program to become the interaction of small, discrete parts. This permits the programmer to think at a higher level of abstraction, making it easier to develop larger and more complex programs
* In Ruby, encapsulation is achieved by the creation of objects; objects expose interfaces through which the rest of the program (including other objects) can interact with them



"**Polymorphism** is the ability for different types of data to respond to a common interface. For instance, if we have a method that invokes the `move` method on its arguments, we can pass the method any type of argument as long as the argument has a compatible `move` method. The object might represent a human, a cat, a jellyfish, or, conceivably, even a car or train. That is, it lets objects of different types respond to the same method invocation."

The example given could be inheritance polymorphism at first, but then suggests polymorphism through duck-typing

I suppose duck-typing means relying on the actual interface of an object, meaning what methods can be called on it and whether those methods do what you want them to, rather than having a language-level check that an object is *of* a certain formally-defined type, or implements a formally-defined interface. So a method definition only requires that the object passed to it responds to the names of methods it will invoke on that object and that the return values or side-effects of those invocations are compatible with the method definition's intent.

"'Poly' stands for 'many' and 'morph' stands for 'forms'. OOP gives us flexibility in using pre-written code for new purposes"

* Polymorphism is the ability for different types of data to respond to a common interface
* 'Poly' means 'many' and 'morph' means 'form'
* Polymorphism allows objects of different types to respond to the same method invocation. In Ruby, this can happen through class inheritance, mixin modules, or duck-typing

**Inheritance**

"The concept of **inheritance** is used in Ruby where a class inherits the behavior of another class, referred to as the **superclass**. This gives Ruby programmers the power to define basic classes with large reusability and smaller **subclasses** for more fine-grained detailed behaviors"

"Another way to apply polymorphic structure to Ruby  programs is to use a `Module`. Modules are similar to classes in that they contain shared behavior. However, you cannot create an object with a module. A module must be mixed in with a class using the `include` method invocation. This is called a **mixin**. After mixing in a module, the behaviors declared in that module are available to the class and its objects."

* Class inheritance facilitates polymorphism; behavior is shared between a superclass and its subclasses
* Mixin modules facilitate polymorphism, allowing behavior to be shared between otherwise unrelated classes

"Inheritance is when a class **inherits** behavior from another class"

"We use inheritance as a way to extract common behaviors from classes that share that behavior, and move it to a superclass. This lets us keep logic in one place"

* Inheritance is when a class inherits behavior from another class
* Inheritance allows us to extract common behavior from classes that share that behavior and move it to a superclass. This facilitates code reuse and means changes can be made in one place rather than many

* We use the `<` symbol to signify that the class we are defining subclasses an existing class

```ruby
class GoodDog
  def speak
    "Hello!"
  end
end
```

Here, we extract the behavior to a superclass, `Animal`, which provides the behavior to `GoodDog` and any other subclass via inheritance

```ruby
class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal; end

class Cat < Animal; end

sparky = GoodDog.new
paws = Cat.new
puts sparky.speak # "Hello!"
puts paws.speak # "Hello!"
```

To illustrate how this facilitates polymorphism:

```ruby
animals = []
animals << Cat.new
animals << GoodDog.new
animals << Animal.new

# the shared behavior `speak` means that objects of any of the 2 subclasses
# and their superclass can be passed to the block
animals.each { |animal| animal.speak } # Hello! Hello! Hello!
```

To demonstrate overriding

```ruby
class GoodDog < Animal
  attr_accessor :name
  
  def intialize(n)
    @name = n
  end
  
  def speak
    "#{name} says arf!"
  end
end
```



* Subclasses can override a method defined in a superclass with a new definition
* Inside the overriding subclass method definition, the reserved word `super` can be used to call the method with the same name in the superclass (or the nearest class or module in the method lookup path). Used without parentheses, `super` passes all arguments passed to the overriding method through to the superclass method. Used with empty parentheses `super()` passes no arguments. You can also explicitly pass arguments through to the superclass method in the parentheses `super(arg1, arg2)` like a regular method call.

"Inheritance can be a great way to remove duplication in your code base. There is an acronym that you'll see often in the Ruby community, "DRY". This stands for "Don't Repeat Yourself". It means that if you find yourself writing the same logic over and over again in your programs, there are ways to extract that logic to one place for reuse."

* Inheritance can be used to remove duplication of logic (Don't Repeat Yourself). If the same logic is repeated in several classes, you could extract that logic to a common superclass.



```ruby
class Animal
  def speak
    "hello"
  end
end

class Dog < Animal
  def intialize(name)
    @name = name
  end

  def speak
    super + " from #{@name} the dog"
  end
end

class Cat < Animal
  def speak
    super + " from the #{@name} the cat"
  end
end

barnie = Dog.new("Barnie")
felix = Cat.new("Felix")
barnie.speak # "Hello from Barnie the dog"
felix.speak # "Hello from Felix the cat"
```

"Another more common way of using `super` is with `initialize`"

```ruby
class Book
  def initialize(title, author)
    @title = title
    @author = author
  end
end

class Novel < Book
  def initialize(title, author, genre)
    super(title, author)
    @genre = genre
  end
  
  def show_details
    puts "#@author, #@title, #@genre"
  end
end

frankenstein = Novel.new("Frankenstein", "Mary Shelley", "Horror/Sci-fi")
```



* `super` is often used with `initialize` methods, since subclasses often specialize their superclass in a way that requires more attributes

"Class inheritance is  the traditional way to think about inheritance: one type inherits the behaviors of another type. The result is a new type that specializes the type of the superclass."

(this on interface inheritance, though not class inheritance, is later mentioned as a form of polymorphism. The 'interface' part is significant to polymorphism because objects are polymorphic from the outside. Polymorphism is precisely the ability for objects of different types to respond to a common *interface*, and mixin modules are a major way that this can be achieved in Ruby. I think this is why there is emphasis placed on this term, even though mixin modules can be used for other purposes than public methods, and even though 'interface inheritance' tends to refer to more formal relationships in statically typed languages or OOP theory)



"The other form [of inheritance] is sometimes called **interface inheritance**: this is where mixin modules come into play. The class doesn't inherit from another *type*, but instead inherits the interface provided by the mixin module. In this case, the result type is not a specialized type with respect to the module"







"You can only subclass (class inheritance from one class)"

"If there is an 'is-a' relationship, class inheritance is usually the correct choice"

* A class can only have one superclass. You can mix in as many modules (interface inheritance) as you'd like
* A class inheritance subclass-superclass relationship represents an "is-a" relationship. The subclass is a specialization of the type of the superclass.
* An interface inherited from a mixin module represents a 'has-a' relationship. The including class has-a capability provided by the module. The class is not a specialized type with respect to the module.



Different objects respond to the same method in the same way - implementation inheritance, generics, parametric polymorphism, same implementation operating on parameterized type

Different objects respond to the same method in different ways - different implementation, inheritance overriding, interface inheritance, operator/function overloading, ad hoc polymorphism, overloading and coercion

"**Polymorphism** refers to the ability of different object types to respond to the same method invocation, often, but not always, in different ways"

"When two or more object types have a method with the same name, we can invoke that method with any of those objects. When we don't care what type of object is calling the method, we're using polymorphism."

"In other words, data of different types can respond to a common interface"

"Often, polymorphism involves inheritance from a common superclass. However, inheritance isn't necessary"

* polymorphism refers to the ability of different types of object to respond to the same method invocation, often with a different method implementation
* polymorphism means that different data types can respond to a common interface

* The ability of different types of object to respond to a common interface can improve the maintainability of code
* Polymorphism means that we can call a method on two or more objects and, as long as those objects expose a method with that name, we don't have to worry about what type of object is calling the method.
* One way that polymorphism is achieved in Ruby is through class inheritance



```ruby
class Animal
  def move
  end
end

class Fish < Animal
  def move
    puts "swim"
  end
end

class Cat < Animal
  def move
    puts "walk"
  end
end

# Sponges and Corals don't have a separate move method - they don't move
class Sponge < Animal; end
class Coral < Animal; end

animals = [Fish.new, Cat.new, Sponge.new, Coral.new]
animals.each { |animal| animal.move }
```

"Every object in the array is a different animal, but the client code -- the code that uses those objects -- doesn't care what each object is. The only thing it cares about here is that each object in the array has a `move` method that requires no arguments. That is, every generic animal object implements some form of locomotion, though some animals don't move."

" The interface for this class hierarchy lets us work with all of those types in the same way even though the implementations may be dramatically different. That is polymorphism."

"This is polymorphism through inheritance -- instead of providing our own behavior for the `move` method, we're using inheritance to acquire the behavior of a superclass."

"This is a simple example of polymorphism in which two different object types can respond to the same method call simply by **overriding** a method inherited from a superclass. In a sense, overriding methods like this is similar to duck-typing... However, overriding is generally considered as an aspect of inheritance, so this is polymorphism through inheritance"

"Looking at this, we can see that every object in the array is a different animal, but the client code can treat them all as a generic animal, i.e., an object that can move. Thus, the public interface lets us work with all of these types in the same way even though the implementations can be dramatically different. That is polymorphism in action"

* In a class hierarchy, the inheritance of public methods means that the subclasses of a superclass can respond to a common interface, even if a class overrides an inherited method and provides a very different implementation. This ability for all the objects of classes in a class inheritance hierarchy to respond to a common interface is polymorphism through inheritance.

```ruby
module Coatable
  def coating
    "I'm covered in chocolate"
  end
end

class JaffaCake
  include Coatable # mixing in Coatable module
end

class Raisin
  include Coatable # mixing in Coatable module
end

snacks = [JaffaCake.new, Raising.new]
snacks.each { |snack| puts snack.coating }
```

"In addition to using class inheritance to implement polymorphism, we can also use mixin modules to implement polymorphism through inheritance via classes that are not related"

* The sharing of behaviors among classes (which might otherwise be unrelated) via the inclusion of mixin modules is another form of polymorphism through inheritance. This is polymorphism through interface inheritance rather than class inheritance. Through inheriting the interface provided to their classes by a shared mixin module, objects of completely different types can respond to a common interface.



**from Polymorphism forum post: lesson 1**

OP:

"In programs, one bit of data often needs to interact with another bit of data. The code that handles this interaction can easily become fragile by relying on specific details about the types of data... This can make it hard down the line to change one of the data types"

"In object oriented programming, interaction generally means one object sending message to another object. To avoid becoming fragile, we can make use of polymorphism: the code that handles the interaction can remain agnostic about the types of objects interacting (or how they are implemented). Instead, it can rely entirely on the objects' public interfaces to pass message back and forth. This means that if we later decide to change the implementation of an object, or use an entirely different type of object, the code that handles the interaction can still function, so long as the objects it works with provide the expected interface. "

* Polymorphism makes programs less fragile and more flexible by loosening the coupling between a piece of code and the specific details of the type of data it expects to be operating on
* In Ruby, as long as an object exposes the right public methods and behaves appropriately in response to those methods being invoked, the client code does not need to concern itself with he type of the object. This agnosticism towards the type of an object passed to a piece of client code is known as duck typing. If an object walks like a duck and quacks like a duck, it can be treated as a duck.
* While polymorphic behavior can be achieved in Ruby through class inheritance, and through the inclusion of mixin modules, duck typing means that objects that do not share any significant ancestors can still be treated polymorphically if they expose the appropriately named method (and as long as the return value or side effects of that method fit the purposes of the client code).

TA:

```ruby
class Animal
  def eat
    # generic eat method
  end
end

class Fish < Animal
  def eat
    # eating specific to fish
  end
end

class Cat < Animal
  def eat
    # eat implementation for cat
  end
end

def feed_animal(animal)
  animal.eat
end

array_of_animals = [Animal.new, Fish.new, Cat.new]
array_of_animals.each do |animal|
  feed_animal(animal)
end
```

"Looking at the above example, we can see that Polymorphism is basically designing your data types in such a way that you can treat a bunch of types as if they were a single type. Every object in the array is a different type of animal but the client code can treat them all as a generic animal... So as you said, the public interface allows us to work with all of these types in the same way even though the implementation can be dramatically different."

"Polymorphism becomes even more important in statically typed languages because you have to declare the type of each parameter, variable, and return value. Declaring the `animal` parameter of `feed_animal` as being of type `Animal` makes sure that the method is able to handle any sub-type of `Animal`"

* Polymorphism is made possible by designing data types so that a selection of different types can be treated as though they were the same type

**Back to 2:6**

"**Duck typing** occurs when objects of different *unrelated* types both respond to the same method name. With duck typing, we aren't concerned with the class or type of an object, but we do care whether an object has a particular behavior. *If an object quacks like a duck, then we can treat is like a duck.* Specifically, duck typing is a form of polymorphism. As long as the objects involved use the same method name and take the same number of arguments, we can treat the object as belonging to a specific category of objects."

Duck typing occurs when objects of unrelated types respond to the same message (a method name to be called with a specific number of arguments)

Duck typing is not concerned with the class or type of an object, but only if it behaves appropriately for the task at hand

If an object quacks like a duck, we can treat it like a duck

Duck typing is a form of polymorphism. So long as the objects respond to the same method name given with the same number of arguments, they belong to the appropriate category of object.



The only type check is that the object must have the behavior necessary for the task at hand, it needs only have a public method of the appropriate name which performs an action compatible with the purposes of the client code.

"In the next example, we define a `Wedding` class and several preparer classes. The example attempts to implement polymorphic behavior without using duck typing; it shows you how you shouldn't do it!"

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
end

class Musician
    def prepare_performance(songs)
      # implementation
    end
  end
end
```

"The problem with this approach is that the `prepare` method has too many dependencies. It relies on specific classes and their names. It also needs to know which method it should call on each of the objects, as well as the argument that those methods require. If you change anything within those classes that impacts `Wedding#prepare`, you need to refactor the method. for instance, if we need to add another wedding preparer, we must add another `case` statement [`when` clause]. Before long, the method will become long and messy."

* Duck typing can reduce dependencies in a piece of code. Client code does not need to have knowledge of the type of the object it is operating on or of the implementation details of the type. This can reduce code fragility and makes it easier to introduce new types of objects into an existing program without changing every method it might be passed to.



"Let's refactor this code to implement polymorphism with duck typing"

```ruby
class Wedding
  attr_reader :guests, :flowers, :songs
  
  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_wedding(self)
    end
  end
end

class Chef
  def prepare_wedding(wedding)
    prepare_food(wedding.guests)
  end
  
  def prepare_food(guests)
    # implementation
  end
end

class Decorator
  def prepare_wedding(wedding)
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
    # implementation
  end
end
```

"Though there is no inheritance in this example, each of the preparer-type classes provides a `prepare_wedding` method. We still have polymorphism since all of the objects respond to the `prepare_wedding` method call. If we later need to add another preparer type, we can create another class and implement the `prepare_wedding` method to perform the appropriate actions."

"Note that merely having two different objects that have a method with the same name and compatible arguments doesn't mean that you have polymorphism. In theory, those methods might be used polymorphically, but that doesn't always make sense. Consider the following two classes:"

```ruby
class Circle
  def draw; end
end

class Blinds
  def draw; end
end
```

"These classes each have a method name `draw`, and the methods take no arguments. In the `Circle` class, `draw` may cause the window blinds in an office building to be drawn (as in close or opend). In theory, you could write some code that uses these methods polymorphically:"

```ruby
[Circle.new, Blinds.new].each { |obj| obj.draw }
```

"However, it's unlikely that this would ever make sense in real code. Unless you're actually calling the method in a polymorphic manner, you don't have polymorphism. In practice, polymorphic methods are intentionally designed to be polymorphic; if there's no intention, you probably shouldn't use them polymorphically."

So duck typing refers to the client code itself. It means that objects can be passed to the code (as arguments, return values, etc) and the code can successfully call methods on them without needing to check the type of the objects it has acquired. The objects do not need to be of related types, nor do they need to formally implement any formally-specified interface, rather they simply need to respond to a common message (a method invocation with a certain number of arguments). This is polymorphism through duck typing.

Inheritance is certainly one way an object might acquire the same method call as an object of a different type (its superclass, say), but equally it could be through designing several unrelated classes to have a method definition of a certain name. 

* Duck typing is a form of polymorphism in which objects of unrelated types can be used polymorphically.
* Duck typing is not concerned with the class or type of an object, but only if it behaves appropriately for the task at hand
* If an object quacks like a duck, we can treat it like a duck
* Duck typing can be seen to occur when objects of unrelated classes respond to the same method name
* Duck typing is a form of polymorphism. So long as the objects respond to the same method name given with the same number of arguments, they belong to the appropriate category of object.
* With duck typing, there is no check as to what type of object the client code is dealing with; rather, the object must only have the behavior necessary for the task at hand.  The object needs only have a public method of the appropriate name that performs an action compatible with the purposes of the client code in order to be the right category of object. This is polymorphism through duck typing.

* Duck typing can reduce dependencies in a piece of code. Client code does not need to have knowledge of the type of the object it is operating on or of the implementation details of the type. This can reduce code fragility and makes it easier to introduce new types of objects into an existing program without changing every method it might be passed to.



So you could say class inheritance and mixin modules are ways that different types of object can acquire common behaviors and respond to a common interface. But from the point of view of polymorphic client code, duck typing means that different types of object do not need to be related at all for the objects to be used polymorphically; all that is necessary is that they respond appropriately to the particular method names necessary for the task at hand.

**Encapsulation again**

"Encapsulation lets us hide the internal representation of an object from the outside and only expose the methods and properties that users of the object need. We can use *method access control* to expose these properties and methods through the public (or external) interface of a class: its public methods."

* Encapsulation lets us hid the internal representation of an object from client code and only expose the methods and properties that users of the object need.
* Method access control hides implementation details and only exposes attributes and methods through a public interface: the public methods of a class

```ruby
class Dog
  attr_reader :nickname
  
  def initialize(n)
    @nickname = n
  end
  
  def change_nickname(n)
    self.nickname = n
  end
  
  def greeting
    "#{nickname.captialize} says Woof Woof!"
  end
  
  private
  
  attr_writer :nickname
end

dog = Dog.new("rex")
dog.change_nickname("barny") # change nickname to "barny"
puts dog.greeting # Displays: Barny says Woof Woof!
```

"In this example, we can change the nickname of a dog by calling the `change_nickname` method <u>without needing to know how the `Dog` class and this method are implemented</u>"

"The same thing happens when we call the method `greeting` on a `Dog` object. The output is `Barny says Woof Woof!`, with the dog's nickname capitalized. <u>Again, we don't need to know how the method is implemented. The main point is that we expect a greeting message from the dog and that's what we get.</u>"

"<u>Note that the setter method for `nickname` is private: it is not available outside of the class</u> and `dog.nickname = "barny"` would raise an error"

"The class should have as few public methods as possible. It lets us simplify using that class and protects data from undesired changes from the outer world"





**Quiz 1**

Quiz 1

'Large, complex programs can be difficult to maintain due to dependencies throughout the program. OOP lets programmers write programs in which the different parts of the program interact, thus reducing dependencies and facilitating maintenance'

* Large, complex programs can be difficult to maintain due to dependencies throughout the program. OOP lets programmers write programs which are the interactions of smaller, sectioned-off parts of the program, reducing dependencies and improving maintainability



'Coding in a non-OO way often means writing code that is useful solely within a single context. Defining basic classes and leveraging concepts like inheritance to introduce more detailed behaviors provides a greater level of reusability and flexibility.'

* Non-OO design can often produce code that is tailored to a single context. OOP features, such as the ability to define simple base classes from which to derive more specialized classes through inheritance, provide a greater level of reusability and flexibility

'Complex coding problems are often difficult to break down and solve in a clear and systematic way. Using OOP to model classes appropriate to the problem, and using real-word nouns to represent objects, lets programmers think at a higher level of abstraction that helps them break down and solve problems'

* Complex problems can be difficult to break down into manageable parts. Using OOP to model classes logically appropriate to the problem, with nouns from the problem domain representing objects, allows programmers to think at a higher level of abstraction, and facilitates the analysis and solution of more complex problems







