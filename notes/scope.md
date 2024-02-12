# Instance variables, class variables, and constants, including the scope of each type and how inheritance can affect that scope #

## Instance variables ##

Off the top of my head:

* instance variable identifiers begin with a single `@`
* instance variables are scoped at the object level
* instance variables track the state of an individual object; instance variables continue to track the state of an object for the lifetime of that object
* instance variables can only be directly referenced within the instance method definition of the object's class (or within a module mixed in to that class)
* which instance variable is referred to by a given name within an instance method definition depends on which object is the current object referenced by `self`
* to retrieve the object referenced by an instance variable from outside the object, we need a public getter method
* to set an instance variable from outside the object, we need a public setter method
* instance variables are not directly inherited; rather, methods that initialize instance variables are inherited and an object acquires its instance variables when they are initialized by that object's methods
* In Ruby, an 'attribute' generally means an instance variable with the name of the attribute that may or may not include public accessor methods

<u>**Ruby OOP Book**</u>

**Classes and Objects I**

"State refers to the data associated to an individual object (which are tracked by instance variables)... instance variables are scoped at the object (or instance) level, and are how objects keep track of their states."

"Instance variables keep track of state"

"The `@name` variable looks different because it has the `@` symbol in front of it"

"an **instance variable**... is a variable that exists as long as the object instance exists and is one of the ways we tie data to objects... It 'lives on' to be referenced, until the object instance is destroyed"

```ruby
class GoodDog
  def initialize(name)
    @name = name
  end
end

sparky = GoodDog.new("Sparky")
```

On line 7, the string `"Sparky"` is passed into the `GoodDog::new` method and through to the constructor `GoodDog#initialize` method to be assigned to the parameter local variable `name`. On line 3, the instance variable `@name` is initialized to the string referenced by `name`. Local variable `name` will cease to exist after the `initialize` method returns, but `@name` will live on for the duration of the lifetime of this particular `GoodDog` instance.

"From that example, we can see that instance variables are responsible for keeping track of information about the *state* of an object. In the above line of code, the name of the `sparky` object is the string `"Sparky"` . This state for the object is tracked in the instance variable, `@name`... Every object's state is distinct, and instance variables are how we keep track"

* instance variable names begin with a single `@`
* once initialized, an instance variable's lifetime will only end with the destruction of the object instance it belongs to
* instance variables keep track of an object's state
* an object's instance variables are particular to that object and track the distinct state of that particular object

**<u>1:4: Attributes</u>**

"the term 'attributes' in Ruby is used quite loosely and is generally approximated as *instance variables*. Most of the time, these instance variables  have accessor methods.... however, it's not a must for the purposes of this definition"

"When we say that classes define the attributes of their objects, we're referring to how classes specify the names of instance variables each object should have (i.e., what the object should be made of). The classes also define the accessor methods ( and level of method access control); however, we're generally just pointing to the instance variables. Similarly, when we say state tracks attributes for individual objects, our purpose is to say that an object's state is composed of instance variables and their values; here, we're not referring to the getters and setters"

* an object's state is composed of instance variables and the objects they reference

**<u>3:3 Variable Scope</u>**

"Instance variables are variables that start with `@` and are scoped at the object level. They are used to track individual object state, and do not cross over between objects"

* Instance variables are scoped at the object level
* Instance variables are used to track the individual object's state and are not shared between objects of a class
* Instance variables separate the state of an object from other objects

"Because the scope of instance variables is at the object level, this means that the instance variable is accessible in an object's instance methods, even if it's initialized outside of that instance method"

* all the instance methods of an object have access to all of that object's instance variables, regardless of which instance method they were initialized in

"Unlike local variables, instance variables are accessible within an instance method even if they are not initialized or passed in to the method. Remember, their scope is at the *object level*"

* Instance variables permit an object to have its own distinct state
* References to uninitialized instance variables evaluate to `nil`. Although accessing an uninitialized instance variable evaluates to `nil`, this does not actually initialize a new instance variable to `nil`

"another distinction from local variables. If you try to reference an uninitialized local variable, you'd get a `NameError`. But if you try to reference an uninitialized instance variable, you get `nil`"

"Instance variables initialized at the class level are an entirely different thing called *class instance variables*. You shouldn't worry about that yet, but just remember to initialize instance variables within instance methods"

* Instance variables are initialized and referenced within instance methods

**<u>3:4 Inheritance and Variable Scope</u>**

"Instance variables and their values are not inherited"

* Instance variables are not directly inherited; rather, instance methods that initialize instance variables are inherited (with respect to both class inheritance and mixin modules)



Definition

* an instance variable associates data to a particular object
* instance variables keep track of an object's state
* an object's instance variables are particular to that object and track the distinct state of that particular object
* an object's state is composed of instance variables and the objects they reference
* an instance variable can exist as long as the object exists
* Instance variables are scoped at the object level
* Instance variables are used to track the individual object's state and are not shared between objects of a class
* Instance variables separate the state of an object from other objects
* Instance variables permit an object to have its own distinct state



Implementation

* instance variable names begin with a single `@`
* all the instance methods of an object have access to all of that object's instance variables, regardless of which instance method they were initialized in
* Instance variables are directly set and referenced only within instance methods
* to retrieve the reference of an instance variable from outside the object, we need a public getter method

* to set an instance variable from outside the object, we need a public setter method

* instance variables are not directly inherited; rather, methods that initialize instance variables are inherited and an object acquires its instance variables when they are initialized by that object's methods
* References to uninitialized instance variables evaluate to `nil`. Although accessing an uninitialized instance variable evaluates to `nil`, this does not actually initialize a new instance variable to `nil`



Benefits

* instance variables associate data to a particular object, separating this state from other objects, facilitating encapsulation at the object level
* Unlike local variables, an instance variable can exist as long as the object exists. This means that instance variables can keep track of state between method calls. However, unlike global variables, instance variables preserve encapsulation
* In Ruby, an 'attribute' of an object generally means an instance variable with the name of the attribute that may or may not include public accessor methods. This permits Ruby objects to model domain entities (including real world objects) possessed of attributes or characteristics, facilitating thinking at a further level of abstraction







## Class Variables ##

**<u>Ruby OOP book</u>**

"Just as instance variables capture information related to specific instances of classes (i.e., objects), we can create variables for an entire class that are appropriately named **class variables**."

"Class variables are created using two `@` symbols like so: `@@`"

* The names of class variables start with `@@`.

"we can access class variables from within an instance method"

* Class variables can be accessed from everywhere within a class and its descendants: within instance and class methods, and within the class definition(s) outside of any method definition

"a class level detail that pertains only to the class, and not to individual objects"

**<u>3:3: Variable Scope</u>**

"Class variables start with `@@` and are scoped at the class level"

* Class variables are scoped at the class level

"all objects share 1 copy of the class variable. (This also implies objects can access class variables by way of instance methods.)"

"class methods can access a class variable provided the class variable has been initialized prior to calling the method"

* A class, its descendant classes, and all instances of all those classes share one copy of a single class variable

* Attempting to access an uninitialized class variable will raise a `NameError` exception

"only class variables can share state between objects. (We're going to ignore globals)"

* Class variables are the only variables that can share state between objects (ignoring global variables)

**<u>3:4 Variable scope and inheritance</u>**

"class variables are accessible to sub-classes"

"Note that since this class variable is initialized in the `Animal` class, there is no method to explicitly invoke to initialize it. The class variable is loaded when the class is evaluated by Ruby"

"But there's a potentially huge problem. It can be dangerous when working with class variables **within the context of inheritance**, because there is only one copy of the class variable across all sub-classes"

* Class variables are shared with descendant classes rather than inherited. There is only one copy of a class variable shared between that class and all of its descendants

**Aside**

A class variable instantiated in a class will be shared with that class's descendants but not with ancestors. This creates difficult-to-think-about scenarios to do with initialization of class variables in class methods.

```ruby
class Parent
  def self.show_value
    @@value
  end

  def self.set_value
    @@value = 5
  end
end

class Child < Parent; end

Child.set_value
puts Child.show_value # outputs 5
puts Parent.show_value # outputs 5
```

Here, the class method `set_value` is inherited from `Parent` but called on `Child`. The `show_value` method is then called on `Parent`, which returns the value of the `@@value` class variable. This is fine -- class methods are inherited by descendants and when the message is sent to `Child` it calls `Parent::set_value`. This initializes a class variable `@@value` that is shared between `Parent` and its descendant class (and all instances, though this doesn't concern us yet).

```ruby
class Parent
  def self.show_value
    @@value
  end
end

class Child < Parent
  def self.set_value
    @@value = 5
  end
end


Child.set_value
puts Parent.show_value # raises NameError
```

This code, however, raises an exception. Since `set_value` is now defined in the `Child` class, the class variable it initializes belongs to `Child` and is shared by the descendant of `Child` but not its ancestor `Parent`. 

What is even more confusing is that the `show_value` method is still inherited by `Child` but the reference to `@@value` in `show_value` will not reference the class variable initialized by `Child::set_value` even if `show_value` is called on `Child`.

```ruby
class Parent
  def self.show_value
    @@value
  end
end

class Child < Parent
  def self.set_value
    @@value = 5
  end
end


Child.set_value
puts Child.show_value # raises NameError
```

So this code also raises a `NameError`. `self`, within the call to `Child.show_value`, will be `Child`, and yet the class variable reference `@@value` on line 4 will always be to a class variable initialized in `Parent` or one of its ancestors. This suggests that the lexically-enclosing class where a class method is defined determines the resolution of a class variable reference, not the class referenced by `self` during a class method call.

So essentially, don't use class variables, or *if you must* then avoid dynamic initialization.

**end of aside**

"Avoid using class variables when working with inheritance. In fact, some Rubyists would go as far as recommending avoiding class variables altogether"

* (Benefits) Class variables are the only way to share state between objects (other than globals)
* (Benefits: drawbacks) Class variables have similar problems to globals especially when working with inheritance in that it becomes difficult to reason about all the different places in which state changes can occur

## Constants ##

**<u>Ruby OOP book</u>**

"When creating classes there may also be certain variables that you never want to change. You can do this creating what are called **constants**. You define a constant by using an upper case letter at the beginning of the variable name. While technically constants just need to begin with a capital letter, most Rubyists will make the entire variable uppercase"

* Constants are variables you can use when you do not want them to be reassigned once initialized

There is the question of whether the object they reference should be mutated or not but I don't think RB120 goes into this?

* Constant names must begin with a capital letter; conventionally, constant names are all uppercase SNAKE_CASE

Again, we'll ignore the fact that classes, modules and structs use PascalCase constants as names (especially since these names appear to be conjoined internally to the class, module, or struct)

**<u>3:3 Variable Scope</u>**

"Constant variables are usually just called constants, because you're not supposed to re-assign them to a different value"

* Constant variables are usually just called constants

"If you do reassign a constant, Ruby will warn you (but won't generate an error). Constants begin with a capital letter and have *lexical* scope."

* If you reassign a constant, Ruby will give a warning but will not raise an exception

We'll ignore that you cannot reassign a constant in a method definition, or that will raise an exception (`Syntax Error`, `dynamic constant assignment`)

* Constants have lexical scope

"**Lexical scope** means that where the constant is defined in the source code determines where it is available."

* Lexical scope means that the textual location where the constant is initialized in the source code determines where that constant definition is available

"When Ruby tries to resolve a constant, it searches lexically -- that is, it searches the surrounding structure (i.e., lexical scope) of the constant reference"

* In order to resolve a(n unqualified) constant reference, Ruby searches the lexically-enclosing structure at the location in the source code where the reference to a constant is made (usually a class or module definition)

It then widens its lexical search to any lexical structures that enclose the immediate lexical structure, which may be, for instance, a class definition lexically-nested inside a module definition. This lexical search of nested source code  structures continues outward up to but not including the top-level code.

"When trying to reference a constant from an unconnected class though, a `NameError` is thrown as the class is not part of the lexical search, and consequently, not included in the constant lookup path... Unlike class or instance variables, we can actually reach into the `Computer` class and reference the `GREETINGS` constant. In order to do so, we have to tell Ruby where to search for the `GREETINGS` constant using `::`, which is the namespace resolution operator."

* To reference a constant that is not accessible through lexical or class hierarchal searches, and not defined at top-level, we must use the namespace resolution operator `::`

**<u>3:4: Inheritance and Variable Scope</u>**

"As described in the previous assessment, Ruby first attempts to resolve a constant by searching in the lexical scope of that reference. If this is unsuccessful, Ruby will then traverse up the inheritance hierarchy *of the structure that references the constant*."

* If no constant definition is found during the lexical part of the constant resolution search, Ruby will then search the class hierarchy of the lexically-enclosing structure in which the constant is referenced.

"So far, we've described the order of constant resolution as lexical scope of the reference first, and then the inheritance hierarchy of the enclosing class/module. There's one caveat to this: the lexical scope doesn't include the main scope (i.e., top level)"

"Ruby attempts to resolve the `WHEELS` constant on line 9 by searching the lexical scope up to (but not including) the `main` scope. Ruby then searches by inheritance where it finds the `WHEELS` constant in the `Vehicle` class, which is why `4` is output on line 14. The top level scope is only searched *after* Ruby tries the inheritance hierarchy"

"So, the full constant lookup path is first the lexical scope of the reference, then the inheritance chain of the enclosing structure, and finally the top level"

* The constant resolution lookup path for an unqualified constant reference is, first, the lexical scope of the reference, then the class inheritance chain of the lexically-enclosing structure, then finally the `main` or top-level scope.

"Constants have *lexical scope*, meaning the position of the code determines where it is available. Ruby attempts to resolve a constant by searching lexically of the reference, then by inheritance of the enclosing class/module, and finally the top level"

* The lexically-enclosing structure will be a class or module



 

























