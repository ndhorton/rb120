**<u>Instance Variables</u>**

**Definition**

* Instance variables keep track of an object's state
* Instance variables permit an object to have its own distinct state; an object's instance variables are not shared by any other objects
* Instance variables can exist so long as the object exists
* Instance variables are scoped at the object level

**Implementation**

* Instance variable names begin with a single `@`
* Instance variables are only directly accessible by an object's instance methods; all of an object's instance methods have access to all of that object's instance variables
* Instance variables are not directly accessible from outside the object; public getter and setter methods are the only means client code has of interacting with an object's instance variables
* Instance variables are not directly inherited. Rather, methods that initialize instance variables are inherited and an object acquires its instance variables when they are initialized by that object's methods
* A reference to an uninitialized instance variable evaluates to `nil` (though such a reference does not initialize an instance variable to `nil`)

**Benefits**

* Instance variables associate data to a particular object, separated from the state of other objects, facilitating encapsulation at the object level
* Unlike local variables, an instance variable can exist as long as the object exists. This means instance variables can keep track of state between method calls. However, unlike global variables, instance variables preserve encapsulation
* In Ruby, an object's 'attributes' are tracked by its instance variables



**<u>Class Variables</u>**

**Definition**

* Class variables are scoped at the level of the class and its descendant classes
* Class variables can be accessed from everywhere within a class and its descendant classes: within instance and class methods, and within the class definition(s) outside of any method definition
* Class variables are shared with descendant classes rather than inherited. There is only one copy of a class variable shared between that class and all of its descendants

**Implementation**

* The names of class variables start with `@@`.
* Attempting to access an uninitialized class variable will raise a `NameError` exception

**Benefits**

* Class variables are the only variables that can share state between objects (ignoring global variables)
* Sharing state is highly problematic, especially when dealing with the expansion of scope via class inheritance. Avoid class variables when possible



**<u>Constants</u>**

**Definition**

* Constants are variables you can use when you do not want them to be reassigned once initialized. Constant variables are thus usually just called constants
* Constants have lexical scope
* Lexical scope means that the textual location where the constant is initialized in the source code determines where that constant definition is available

**Implementation**

* Constants are inherited through class inheritance and mixin modules

* Constant names must begin with a capital letter; conventionally, constant names are all uppercase SNAKE_CASE
* If you reassign a constant, Ruby will give a warning but will not raise an exception
* If you mutate the object referenced by an object, Ruby will not even give a warning
* In order to resolve an unqualified constant reference, Ruby searches the lexically-enclosing structure at the location in the source code where the reference to a constant is made. The lexical structure is a class or module definition
* It then widens its lexical search to any lexical structures that enclose the immediate lexical structure. The lexical search of nested source code structures continues outward, up to but not including the top-level code.
* If no constant definition is found during the lexical part of the constant resolution search, Ruby will then search the class hierarchy of the lexically-enclosing structure where the constant is referenced.
* The constant resolution lookup path for an unqualified constant reference is, first, the lexical scope of the reference, then the class inheritance chain of the lexically-enclosing structure, then finally the `main` or top-level scope.

* To reference a constant that is not accessible through lexical or class hierarchal searches, and not defined at top-level, we must use the namespace resolution operator `::`

**Benefits**

* Constants can be used to give meaningful names to fixed values, facilitating clearer code and expressing intention

