## LS OOP Book

Methods and keywords:

- `Module#include` - **mixin** a module into a class
- `Kernel#class` - returns the name of the class of the object it is called on
- `class` - keyword opens a class definition, closed by `end`
- `Class#new` - instantiate an object from a class
- `module` - keyword opens a module definition, closed by `new`
- `Module#ancestors` - returns an array containing the **method lookup path** for the class or module it is called on
- `new` - gets inherited from the `Class` class as a class method  (though it corresponds to the description of `Class#class`, not `Class::class`, which is the equivalent method for the `Class` class itself) by any user-defined class. When called on a particular class, `new` calls `allocate` to allocate memory to a new instance of that class; then `new` calls that class’s `initialize`method
- `initialize` - the name of the **constructor** method for a given class. For user-defined classes, the implementation of `initialize` is user-defined. The LS OOP book describes `initialize` as an instance method. It is a private method, which discourages calling it after construction, though it *can* be called again on an already-constructed instance by explicit message-passing with the `send` method (`my_instance.send(:initialize, arg, another_arg,...)`).
- `self` - keyword, “From within the class, when an instance method uses `self`, it references the calling object… [However] using `self` inside a class but outside an instance method refers to the class itself.” OOP, CaO  II
- `Module#attr_reader` - takes a symbol as argument, creates an instance variable called `@[symbol value]` and a getter method called `[symbol value]`
- `Module#attr_writer` - takes a symbol as argument, creates an instance variable and a setter method
- `Module#attr_accessor` - takes a symbol as argument, creates an instance variable, a getter method, and a setter method
- `super` - keyword used to call methods higher up the method lookup path. “When you call `super` from within a method, it searches the method lookup path for a method with the same name, then invokes it” - OOP, Inheritance
- `::` - operator for **namespacing**
- `Module#public` - access modifier method (can be called on the object from wherever)
- `Module#private` - access modifier method (can only be called from other methods within the class definition)
- `Module#protected` - access modifier method (can be called from other methods within the class definition and also from a within a method called on another instance of the same class, but not from elsewhere)
- `Object#send` - explicit message-sending method, can be used to invoke methods on objects. The first argument passed to `send` should be a symbol or string representing the method you want to call; further arguments are the arguments to the method named by the symbol or string.
- `Object#instance_of?` - returns `true` if the calling object is an instance of the `Class` passed as argument, `false` otherwise. Note that if called on an instance of a subclass with the superclass passed as argument, `instance_of?` returns `false`; it only returns `true` if the instance is a direct instance of the `Class` passed as argument.
- `Object#to_s` - returns a string representation of the calling object. You generally want to override this method.
- `Object#allocate` - allocates space for a new object of the calling class. Does not call `initialize` constructor. `allocate` is automatically called by `new` before `new` calls `initialize`.
- `class << self` - ???
- `begin` - keyword begins a section of code that might be expected to raise exceptions
- `rescue` - keyword followed by `=>` and the name of a local variable to which the exception object will be assigned if an exception is raised. Begins the section where an exception can be handled.
- `Kernel#raise` - method used to explicitly and deliberately raise an exception
- `ensure` - keyword begins a block that is always executed whether an exception is raised or not

### The Object Model

"**Encapsulation** is hiding pieces of functionality and making it unavailable to the rest of the code base. It is a form of data-protection, so that data cannot be manipulated or changed without obvious intention. it is what defines the boundaries in your application and allows your code to achieve new levels of complexity. Ruby, like many other OO languages, accomplishes this task by creating objects, and exposing interfaces (i.e., methods) to interact with those objects.

Another benefit of creating objects is that they allow the programmer to think on a new level of abstraction. Objects are represented as real-world nouns and can be given methods that describe the behavior the programmer is trying to represent.” - LS OOP book, The Object Model

**Polymorphism** is the ability for different types of data to respond to a common interface. For instance, if we have a method that invokes the `move` method on its argument, we can pass the method any type of argument as long as the argument has a compatible `move` method. The object might represent a human, a cat, a jellyfish, or, conceivably, even a car or a train. That is, it lets objects of different types respond to the same invocation.

“’Poly’ stands for ‘many’ and ‘morph’ stands for ‘forms’. OOP gives us flexibility in using pre-written code for new purposes” - LS OOP book, The Object Model

“The concept of **Inheritance** is used in Ruby where a class inherits the behaviors of another class, referred to as the **superclass**. This gives Ruby programmers the power to define basic classes with large reusability and smaller subclasses for more fine-grained, detailed behaviors.” -LS OOP book, The Object Model

**behaviors** - instance methods

**attributes** - instance variables

Class - a class can be thought of like a mold, out of which objects are formed.

Module - a module is another way to achieve polymorphism in Ruby. A module is a collection of behaviors that is reusable across multiple classes. A module is “mixed in” to a class using the `include` method invocation.

Method Lookup Path - a hierarchy of classes and modules to look for a method

### Objects and Classes I

**state - tracked by instance variables**

**behaviours**

Calling the `Class#new` method calls the named class’s `allocate` method to assign memory to the new instance, and then `new` calls that class’s `initialize` method.

```ruby
class GoodDog
  def initialize(name)
    @name = name
  end
end

sparky = GoodDog.new("Sparky")
```

Here, the string `"Sparky"` is passed to the `GoodDog::new` method, which passes it through to the `GoodDog#initialize` method, where it is assigned to the method parameter (a local variable) `name`. Within the body of the method definition, the string, referenced by local variable `name`, is then assigned to the instance variable `@name`.

An instance variable is created when a new instance is constructed. The instance variable is local to the scope of that instance and it persists for the lifetime of the instance. It goes on to say, “In our instance methods … we have access to instance variables” (OOP, Classes & Objects I). Does this mean that you cannot (or ***\**\*should\*\**\*** not) use instance variables in class methods? Presumably, since how can there be an instance variable if there is no instance?

“an instance variable … is one of the ways we tie data to objects” - LS OOP book, Classes and Objects I

“Every object’s state is distinct, and instance variables are how we keep track.” - LS OOP book, Classes and Objects I

### Classes and Objects - Part II

Instance methods - “methods that pertain to an instance or object of the class” - LS OOP, CaO II

Instance variables - 1 `@` used to track state of instances of a class

Class methods - “Class methods are methods we can call directly on the class itself, without having to instantiate any objects” - OOP CaO II

Class variables - 2 `@@` used to track state of class itself

Class variables can be accessed from within instance methods. The other way around is technically possible too, though probably not at all useful (specifically, setting an instance variable in a class method seems to create an instance variable specifically for the class as an object)

`self` - “From within the class, when an instance method uses `self`, it references the calling object… [However] using `self` inside a class but outside an instance method refers to the class itself.” OOP, CaO  II

### Inheritance

“We use inheritance as a way to extract common behaviours from classes that share that behavior, and move it to a superclass. This lets us keep logic in one place.” - OOP, Inheritance

If a **subclass** inherits a method from a **superclass** but you want to use a more specific implementation for the subclass, you can **override** the superclass method by defining a method with the same name in the subclass.

Ruby looks first in the class of the instance on which a method is called; if it can’t find the method there, it goes up one level in the method lookup path, etc.

If you simply call `super`, all arguments passed to the subclass method will be passed through to the superclass method. If this behavior is not desired, as for instance when the superclass method takes fewer arguments than the subclass method, you need to pass the correct arguments with the same `super(arg1, arg2, ...)` syntax as a normal method. If the superclass method takes no arguments, but the subclass method does, it is necessary to call `super()` with empty parentheses to prevent `super` attempting to pass arguments to a method that does not take them which would cause an `ArgumentError` to be raised.

DRY - Don’t Repeat Yourself

Class inheritance - superclass and subclass

“Class inheritance is the traditional way to think about inheritance: one type inherits the behaviors of another type. The result is a new type that specializes the type of the superclass” - OOP, Inheritance

Interface inheritance - mixin modules

“[With **interface inheritance**] The class doesn’t inherit from another type, but instead inherits the interface provided by the mixin module. In this case, the result type is not a specialized type with respect to the module”

- You can only subclass from one class. You can mix in as many modules (interface inheritance) as you’d like.
- If there’s an “is-a” relationship, class inheritance is usually the correct choice. If there’s a “has-a” relationship, interface inheritance is generally a better choice. For example, a dog “is an” animal and it “has an” ability to swim.
- You cannot instantiate modules. In other words, objects cannot be created from modules.

The order in which we `include` modules is significant. Ruby will look first for an instance method in the class of the object on which it is called; if it can’t find it, it then looks in the last-included module, then in the module included before that, and so on until it gets to the first-included module. Then Ruby looks in the parent class.

Modules can also be used for **namespacing**. “In this context, namespacing means organizing similar classes under a module. In orhter words, we’ll use modules to group related classes. Therein lise the first advantage of using modules for namespacing. It becimes easy for us to recognize related xlasses in our code. The second advantage is it reduces the likelihood of our classes colliding with other similarly named classes in our codebase.” - OOP, Inheritance

"**Access Control** is a concept that exists in a number of languages, including Ruby. It is generally implemented through the use of *access modifiers*. The purpose of access modifiers is to allow access to a particular thing. In Ruby, the things we are concerned with restricting access to are the methods defined in a class. In a Ruby context, therefore, you'll commonly see this concept referred to as **Method Access Control**." - OOP, Inheritance 

**Interface** - in Ruby, the interface to a class and its objects consists of the **public** methods of that class and its objects.

In versions of Ruby prior to 2.7, it was illegal to call `self.some_private_method`; you would have to simply call `some_private_method`

It is important to get acquainted with the methods in `Object` to avoid overriding them accidentally. Does this apply to `Kernel` and `BasicObject` too?

It seems that if you create an class variable in a superclass, that variable is then shared among subclasses.

"The purpose of the **constructor** [`initialize`] is to initiate the state of an object." -https://zetcode.com/lang/rubytutorial/oop/

"An object's **attributes** are the data items that are bundled inside that object. The items are also called *instance variables* or *member fields*. An instance variable is a variable defined in a class, for which each object in the class has a separate copy" - Zetcode I

**operator overloading**

**constructor overloading** - "the ability to have multiple types of constructors in a class. This way we can create an object with different number or different types of parameters. Ruby **has no constructor overloading** that we know from some programming languages. This behavior can be simulated to some extent with default parameter values in Ruby" - Zetcode I

Superclass, parent class, base class, ancestor

Subclass, child class, derived class, descendant

"Class methods cannot access instance variables" - Zetcode II

"Exceptions are objects that signal deviations from the normal flow of program execution. Exceptions are **raised**, thrown or **initiated**" - Zetcode II

Exception objects are 'descendants of a built-in exception class' - Zetcode II

"Exceptions are objects. They are descendants of a built-in `Exception` class. Exception objects carry information about the exception. Its type (the exception's class name), an optional descriptive string, and optional traceback information. Programs may subclass `Exception`, or more often `StandardError`, to obtain custom Exception objects that provide additional information about operational anomalies" - Zetcode II

"If the `raise` [method] does not have a specific exception as a parameter, a `RuntimeError` exception is raised setting its message to the given string" - Zetcode II

"Ruby's `ensure` clause creates a block of code that always executes, whether there is an exception or not" - Zetcode II

"Custom exceptions should inherit from the `StandardError` class" - Zetcode II



### <u>Lesson 1:4 Attributes</u> ###

"you'll often find in our text (and external literature) that the term 'attributes' in Ruby is used quite loosely and is generally approximated as *instance variables*. Most of the time, these instance variables have accessor methods (because objects that are entirely secretive aren't very useful); however, it's not a must for the purposes of this definition."   - LS



