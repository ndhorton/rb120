# Lesson 3 #

## 3:2: Equivalence ##

Not objects: methods, blocks, if statements, argument lists, variables

When we are using the `==` operator, we are actually calling a method: "the string objects somehow know to compare their values, even though they're different objects. What we're asking is 'are the values within the two objects the same?' and not 'are the two objects the same?'"

`==` a comparison for equality of two objects' values (though if two variables point to the same object, obviously the object has the same value as itself)

`equal?` a comparison that checks whether two variables (or similar means of reference, e.g. an array index) are pointing to the same object

```ruby
str1 = 'text'
str2 = 'text' # two separate String objects with the same value 'text'

str1 == str2 # true (object value equality)

str1.equal?(str2) # false (no object equality/identity)

str1 = str2 # now str1 and str2 point to exactly the same object

str1.equal?(str2) # true (object equality/identity)
```

So `==` compares two objects' values while `equal` compares two variables (or other reference identifiers) to see if they point to the same object

"In summary, the `==` method compares the two variables' values whereas the `equal?` method determines whether the two variables point to the same object."

The object value used for comparison between two comparable objects is down to the caller's class definition's `==` method implementation.

"`==` is not an operator in Ruby, like the `=` assignment operator. Instead, it's actually an instance method available on all objects. Ruby gioves the `==` method a special syntax to make it look like a normal operator. "

```ruby
str1 = 'text'
str2 = 'text'

str1 == str2  # This is syntactic sugar that is semantically equivalent to
str1.==(str2) # this more syntactically-obvious method call
```

So left hand operand is actually the caller/receiver and the right hand operand is actually an argument passed to the `==` method defined in the caller's class.

"Since it's an instance method, the answer to "how does `==` know what value to use for comparison" is: it's determined by the class."

"The original `==` method is defined in the `BasicObject` class, which is the parent class for *all* classes in Ruby. This implies *every* object in Ruby has a `==` method. However, each class should define the `==` method to specify the value to compare [because] ... the default implementation for `==` [in a custom class] is the same as `equal?` (which is also in the `BasicObject` class). It's not very useful, because when we use `==`, we don't actually want to ask 'are the two variables pointing to the same object?', and instead, we want to ask 'are the values in the two variables the same?' To tell Ruby what 'the same' means for a `Person` object, we need to define the `==` method"

`>` and `<` are also instance methods, not real operators, and can be redefined

```ruby
45 == 45.00 # true
```

"The above code is actually `45.==(45.00)`, which means that it's calling the `Integer#==` method. You can imagine that the implementer of this method took care to consider the possibility of comparing an integer with a float, and handled the conversion from float to integer appropriately"

"This is the first time we've seen comparing two objects of *different* classes. But this is possible because you can implement `==` however you wish... `45 == 45.0` is not the same as `45.0 == 45`. The former is calling `Integer#==` while the latter is calling `Float#==`. Thankfully, the creator of those methods took time to make the interface consistent"

"When you define a `==` method, you also get the `!=` for free"

"Symbols and integers [and other core types of immutable object] behave slightly differently in Ruby than other objects. If two symbols or two integers have the same value, they are also the same object. This is a performance optimization in Ruby, because you can't modify a symbol or integer. This is also why Rubyists prefer symbols over strings to act as hash keys: it's a slight performance optimization and saves on memory"



`===` (instance method (called elsewhere 'case equality operator' but I don't think LS use that term))

"The... confusing part about this method is that it's used implicitly by the `case` statement"

```ruby
num = 25

case num
when 1..50
  puts "small number"
when 51..100
  puts "large number"
else
  puts "not in range"
end
```

"Behind the scenes, the `case` statement is using the `===` method to compare each `when` clause with `num`. In this example, the `when` clauses contain only ranges, so `Range#===` is used for each clause. Typically, you do not have to define your own `===` behavior, as you likely wouldn't use your custom classes in a `case` statement. It's sometimes useful to remember that `===` is used for comparison in `case` statements, though"

In order to visualize how the `case` statement uses `===`, consider the following interpretation using an `if` statement:

```ruby
num = 25

if (1..50) === num
  puts "small number"
elsif (51..100) === num
  puts "large number"
else
  puts "not in range"
end
```

"In this example, the `===` method is invoked on a range and passes in the argument `num`. Now, ``===` doesn't compare two objects the same way that `==` compares two objects. When `===` compares two objects, such as `(1..50)` and `25`, it's essentially asking 'if `(1..50)` is a group, would `25` belong in that group?' In this case, the answer is 'yes'" 

```ruby
String === "hello" # true
String === 15 # false
```

"Sidenote: the `===` operator in JavaScript is very different from `===` in Ruby. Do not get the two confused"

`eql?` - determines if two objects contain the same value and are of the same class. Used most often by `Hash` to determine equality among its members. Not used very often by Ruby programmers.



### Most Important

**`==`**

-   for most objects, the `==` operator compares the values of the objects, and is frequently used.
-   the `==` operator is actually a method. Most built-in Ruby classes, like `Array`, `String`, `Integer`, etc. provide their own `==` method to specify how to compare objects of those classes.
-   by default, `BasicObject#==` does not perform an  equality check; instead, it returns true if two objects are the same  object. This is why other classes often provide their own behavior for `#==`.
-   if you need to compare custom objects, you should define the `==` method.
-   understanding how this method works is the most important part of this assignment.

### Less Important

**`equal?`**

-   the `equal?` method goes one level deeper than `==` and determines whether two variables not only have the same value, but also whether they point to the same object.
-   do not define `equal?`.
-   the `equal?` method is not used very often.
-   calling `object_id` on an object will return the object's unique numerical value. Comparing two objects' `object_id` has the same effect as comparing them with `equal?`.

**`===`**

-   used implicitly in `case` statements.
-   like `==`, the `===` operator is actually a method.
-   you rarely need to call this method explicitly, and only need to  implement it in your custom classes if you anticipate your objects will  be used in `case` statements, which is probably pretty rare.

**`eql?`**

-   used implicitly by `Hash`.
-   very rarely used explicitly.

## 3:3: Variable Scope ##

### Instance Variable scope ###

"Instance variables are variables that start with `@` and are scoped at the object level. They are used to track individual object state, and do not cross over between objects."

Aside: the instance variables *in scope* at any point in a program's execution are determined by which object/instance is the current/default object referenced by keyword `self`. Scope can be considered to have two aspects:

1. the **scope** of a given variable
2. which variables are **in scope** in a given context

* "The scope of instance variables is at the object level", which is to say that they are "scoped at the object level"

"Because the scope of instance variables is at the object level, this means that the instance variable is accessible in an object's instance methods, even if it's initialized outside of that instance method [specifically, in another instance method -- class instance variables belong to the class object itself, but we are not concerned with these in RB120]"

Object level meaning, 'for instance, we can use a `@name` variable to separate the state of `Person` objects'. Each `Person` instance will have its own `@name` instance variable tracking its own state, separate to all other `Person` objects.

"Unlike local variables, instance variables are accessible within an instance method even if they are not initialized or passed in to the method. Remember, their scope is at the *object level*"

Unlike with local variables, referencing an uninitialized instance variable evaluates as `nil` rather than raising a `NameError`. "If you try to reference an uninitialized local variable, you'd get a `NameError`. But if you try to reference an uninitialized instance variable, you get `nil`."

"If you accidentally put an instance variable at the *class* level... instance variables initialized at the class level are an entirely different thing called *class instance variables*. You shouldn't worry about that yet"

* Instance variable identifiers begin with a single `@`
* Instance variables are scoped at the object level
* Instance variables are used to separate the state of a single instance of a class. All instances of a class will have their own encapsulated instance variables, which have the same names as those pertaining to other instances of the class but which track that individual instance's state
* A reference to an uninitialized instance variables evaluates to `nil` and does not raise a `NameError` exception
* Once initialized in an instance method of an object, that instance variable is available within all instance methods of that object

## Class Variable scope ##

"Class variables start with an `@@` and are scoped at the class level. They exhibit two main behaviors

* all objects share 1 copy of the class variable. (This also imples objects can access class variables by way of instance methods.)
* class methods can access a class variable provided the class variable has been initialized prior to calling the method."

What this second point means is: a class variable must be initialized at the class level *possibly in a class method but usually outside of any method definition* before you can reference it. Ruby will raise a `NameError` if you reference an uninitialized class variable.

The class itself and all of its instances share any given class variable initialized in that class. Thus class variables can be accessed within a class definition outside of any method definition, within its class method definitions, and within its instance method definitions.

"Only class variables can share state between objects. (We're going to ignore globals)"

## Constant Variable scope ##

"Constant variables are usually just called constants, because you're not supposed to re-assign them to a different value. If you do re-assign a constant, Ruby will warn you (but won't generate an error)."

"Constants begin with a capital letter and have *lexical scope*"

"**Lexical scope** means that where the constant is defined in the source code determines where it is available. When Ruby tries to resolve a constant, it searches lexically -- that is, it searches the surrounding structure (i.e., lexical scope) of the constant reference."

This is to say, Ruby searches the lexically-nested source code context of the constant reference in order to begin searching for a constant definition.



**Attempt at examples**

```ruby
module Outer
  TAU = Math::PI * 2 # Here we are in the *lexical* context line 6's reference
  
  class InnerFirst
    def show_tau
      puts TAU # Has lexical access to Outer as well as Outer::InnerFirst
    end
  end
end

class Outer::InnerSecond
  def show_tau
    puts TAU # The lexical context here is limited to Outer::InnerSecond
  end
end

first = Outer::InnerFirst.new
first.show_tau # 6.28...

second = OuterInnerSecond.new
second.show_tau # raises NameError
```

The lexical context of the reference to `TAU` on line 6 extends outwards to the source code structure of text and symbols that consists of the definition of module `Outer` and everything inside it. The constant definition of `TAU` on line 2 is thus within the lexical context of the reference on line 6. 

On the other hand, the reference to `TAU` on line 13 is lexically confined to the immediate `Outer::InnerSecond` class. Despite being defined within the same `Outer` namespace, the `Outer::InnerSecond` class source code is not *lexically* nested within the actual source code of `Outer` so Ruby will not look in `Outer` for constant resolution. Since there is no definition for `TAU` within the inheritance chain of `Outer::InnerSecond` either, the reference on line 13 raises a `NameError` exception.

So even though `InnerFirst` and `InnerSecond` are defined at the same namespace level, their lexical context -- the textual nesting of their respective source code definitions, or their *mise-en-page*, to borrow a literary term -- is different.

```ruby
class Guitar
  STRINGS = 6
  
  def number_of_strings
    STRINGS
  end
  
  def show_number_of_strings
    self.class::STRINGS
  end
end

class BassGuitar < Guitar
  STRINGS = 4
end

jazz_bass = BassGuitar.new

puts jazz_bass.number_of_strings # 6
puts jazz_bass.show_number_of_strings # 4
```

Since constants have lexical scope, their lookup is determined by the lexical nesting of the constant reference, meaning the textual context of  source code surrounding the reference. 

Here, the `number_of_strings` method is called on a `BassGuitar` object on line 19. Although the method is called on a `BassGuitar` object, `number_of_strings` is defined within the `Guitar` class and so this textual structure is the lexical context of the reference in the method definition on line 5. When Ruby is given an unqualified constant reference, it first checks the lexical context, meaning the source code text of words and symbols surrounding the reference up to but not including the top-level/`main` level. In this case, this means that the source code for the `Guitar` class is searched and the constant definition for `STRINGS` on line 2 is found first. Thus the method call on line 19 inaccurately outputs `6`. If a constant definition had not be found within `Guitar`, Ruby would have begun searching the inheritance hierarchy with the mixins and superclass of `Guitar` and would still never have searched `BassGuitar`.

In order to achieve to correct result (outputting `4`, the definition for `STRINGS` in `BassGuitar`) a dynamic reference must be made, as in the `Guitar#show_number_of_strings` method, on line 9. `show_number_of_strings` is called on a the `BassGuitar` object on line 20. Within the method definition body, on line 9, the reference to `self` returns the calling object -- an instance of `BassGuitar`; the `class` method is called on this and returns `BassGuitar`, the class of the caller. The namespace operator is then used to reference the precise definition of `STRINGS` that we are looking for `BassGuitar::STRINGS`, so the method call to `show_number_of_strings` on line 20 outputs the correct number, `4`.

**Aside: mixin module constant resolution**

One interesting thing to be aware of is that when a module with an instance method referencing an unqualified constant (and without that constant defined in the module or its lexically-nested context), Ruby will begin searching the inheritance hierarchy with class `Object`, then `Kernel`, then `BasicObject`. It will not search the class or superclass of the caller, nor will it search class `Module`.

```ruby
class BasicObject
  STRINGS = 'this is BasicObject::STRINGS'
end


STRINGS = 'this is Object::STRINGS'

class Module
  STRINGS = 'this is Module::STRINGS'
end

module Playable
  def number_of_strings
    STRINGS
  end
end

class StringedInstrument
  STRINGS = 4
end

class Guitar < StringedInstrument
  include Playable

  STRINGS = 6
end

guitar = Guitar.new
puts guitar.number_of_strings # outputs "this is Object::STRINGS"
```

This surprises me because modules do not inherit from a superclass yet it still searches a part of the inheritance tree. But it doesn't search the `Module` class even though `Playable` is an instance of class `Module`.

So anyway, just remember that if a constant reference in a mixin module cannot be resolved lexically, the lookup searches class `Object` (where any top-level/`main` constant definitions are placed) and then checks the ancestors of `Object`: `Kernel` and `BasicObject`. I think it checks `Object` to resolve top-level constants, and any constants in `Kernel` and `BasicObject` are simply inherited by `Object` (by which I mean, those ancestors *have* to be checked if we're searching `Object`). In any normal usage, this means  you can think of it as checking the lexical context of the module and then *essentially* checking top-level (even if technically this means the `Object` class and its ancestors). Basically, it only checks `Object` at all because this is how Ruby implements global constants.

So essentially, modules do not inherit so there are no superclasses to search, but Ruby *has to* search `Object` and by extension its ancestors (because `Object` is where top-level constants end up) in order for there to be 'global' constants, a basic feature of most popular general-purpose programming languages. And remember, crucially, these global constants include the names of any classes and modules defined at top-level.

**Back to notes on LS material**

"Within one class, the rules for accessing constants is pretty easy. When Ruby encounters the name `GREETINGS` on line 5 and 9, it searches the surrounding source code... Since `GREETINGS` is initialized on line 2 within the `Person` class, it is accessible in both the `Person::greetings` class method and `Person#greet` instance method"

* A constant defined in a class is available throughout that class definition, within instance methods and class methods.

"This time, let's have the `Person` class exist in an `ElizabethanEra` module for **namespacing** purposes"

* A constant initialized in a lexically-enclosing module surrounding a class definition can be referenced by any class method or instance method of the lexically-nested class. 

"Unlike class or instance variables, we can actually reach into the `Computer` class and reference the `GREETINGS` constant. In order to do so, we have to tell Ruby where to search for the `GREETINGS` constant using `::`, which is the namespace resolution operator"

* In order to reference a constant that is not initialized in the lexical context of the reference, nor in a class in an inheritance relation to the class where the reference is made, we need to use the namespace resolution operator `::` in order to tell Ruby exactly where to look for the constant.

## 3:4: Inheritance and Variable Scope ##

### Instance variables ###

"Instance variables don't really exhibit any surprising behavior. [in relation to inheritance] They behave very similar to how instance methods would, with the exception that we must first call the method that initializes the instance variable. This distinction suggest that, unlike instance methods, **instance variables and their values are not inherited**."

* instance variables are not directly inherited; however methods that initialize instance variables are inherited

### Class variables ###

```ruby
class Animal
  @@total_animals = 0
  
  def initialize
    @@total_animals += 1
  end
end

class Dog < Animal
  def total_animals
    @@total_animals
  end
end

spike = Dog.new
spike.total_animals # => 1
```



"class variables are accessible to sub-classes. Note that since this class variable [is initialized in the class but outside of any method definition]  there is no method to explicitly invoke to initialize it. The class variable is loaded when the class is evaluated by Ruby. This is pretty expected behavior."

"But there is a potentially huge problem. It can be dangerous when working with class variables within the context of inheritance, because **there is only one copy of the class variable across all sub-classes**"

```ruby
class Vehicle
  @@wheels = 4
  
  def self.wheels
    @@wheels
  end
end

class Motorcycle < Vehicle
  @@wheels = 2
end

class Car < Vehicle
end

Motorcycle.wheels # 2
Vehicle.wheels # 2
Car.wheels # 2 (even though Car inherits from Vehicle, not Motorcycle)
```

"The fact that an entirely different sub-class of `Vehicle` can somehow modify this class variable throws a wrench into the way we think about class inheritance"

"For this reason, avoid using class variables when working with inheritance. In fact, some Rubyists would go as far as recommending avoiding class variables altogether. The solution is usually to use *class instance variables*, but that's a topic we aren't ready to talk about yet."

* class variables are not so much inherited as actually shared between a class and all of its descendant classes. A class variable set in any of the classes in this tree of shared class variables will be able to reassign the class variable for all other related classes
* avoid using class variables when inheritance is involved; perhaps avoid class variables altogether
* class variables track state that is shared between a class and all of its descendant classes and all instances of all those classes

### Constants ###

"As described in the previous assignment, Ruby first attempts to resolve a constant by searching in the lexical scope of that reference. If this is unsuccessful, Ruby will then traverse up the inheritance hierarchy *of the structure that references the constant*"

```ruby
module FourWheeler
  WHEELS = 4
end

class Vehicle
  def maintenance
    "Changing #{WHEELS} tires."
  end
end

class Car < Vehicle
  include FourWheeler
  
  def wheels
    WHEELS
  end
end

car = Car.new
puts car.wheels      # 4
puts car.maintenance # NameError: uninitialized constant Vehicle::WHEELS
```

"When resolving the `WHEELS` constant reference on line 5, Ruby first searches lexically. Since it cannot be found, Ruby then searches the ancestors of the `Car` class (since that's the structure that refers to the constant). Since a `WHEELS` constant exists within the `FourWheeler` module, that is what is output on line 20"

"Next, when resolving the `WHEELS` constant reference on line 7, Ruby first searches the lexical scope of the reference. Since it cannot be found, Ruby then tries the inheritance hierarchy of the `Vehicle` class that encloses the reference. (Note that this is *not* the `Car` class, despite the fact that it is an instance of the `Car` class that is calling the method). Ruby searches the ancestors of `Vehicle`: `Object`, `Kernel`, `BasicObject`. Since none of these classes contain the `WHEELS` constant, an error is raised"

"So far, we've described the order of constant resolution as lexical scope of the reference first, and then the inheritance hierarchy of the [lexically] enclosing class/module. There's one caveat to this: the lexical scope doesn't include the main scope (i.e. top level)"

```ruby
class Vehicle
  WHEELS = 4
end

WHEELS = 6

class Car < Vehicle
  def wheels
    WHEELS
  end
end

car = Car.new
puts car.wheels
```

"Ruby attempts to resolve the `WHEELS` constant on line 9 by searching the lexical scope up to (but not including) the main scope. Ruby then searches by inheritance where it finds the `WHEELS` constant in the `Vehicle` class, which is why `4` is output on line 14. The top level scope is only searched *after* Ruby tries the inheritance hierarchy."

"So,  the full constant lookup path is first the lexical scope of the reference, the the inheritance chain of the enclosing [lexical] structure [surrounding the reference], and finally the top level. This can get quite tricky with complex code"



* **Instance Variables** behave the way we'd expect. The only thing to watch out for is to make sure the instance variable is initialized before referencing it
* **Class Variables** have a very insidious behavior of allowing sub-classes to override super-class class variables. Further, the change will affect all other sub-classes of the super-class. This is extremely unintuitive behavior, forcing some Rubyists to eschew using class variables altogether.
* **Constants** have *lexical scope*, meaning the position of the code determines where it is available. Ruby attempts to resolve a constant by searching lexically of the reference, then by inheritance of the enclosing class/module, and finally the top level

Aside: One thing to note is that modules do not inherit, so if a module is the lexically-enclosing structure surrounding a constant reference then Ruby goes straight to top level/Object if the constant cannot be found during the lexical search

## 3:5: Fake Operators ##

real operators

```ruby
. :: # method and constant resolution
&&   # logical AND and OR
||
.. ... # Range notation
?:     # ternary operator(s)
# Assignment
# the operator-methods and setters called by the shortcuts can be custom
= += -= %= /= |= &= >>= <<= *= &&= ||= **=
{ } # one-liner block delimiters
```

Most commonly overridden

`==` - automatically provides `!=` when defined

`!=` - can be defined separately, or you could override the default provided when `==` is defined. Don't do this though

`< <= > >=` - all common to be defined

`<<` - define for custom collection objects (mimic Array#<<)

`+` - should either be 1) adding/incrementing or 2) concatenating, depending on the kind of object, and should return an object of the caller's class, not e.g. the arrays being concatenated or integer values being added

`[] []=` - Element getter and element setter, the syntactic sugar we are used to `arr[2]` is actually `arr.[](2)`, and `arr[2] = 'fish'` is actually `arr.[]=(2, 'fish')`. So we `def []=(index, object)`. Used for classes that represent a collection

An element getter is an element reference method, an element setter an element assignment method

If we define our own operators, "we must be careful to follow conventions established in the Ruby standard library. Otherwise, using these methods will be very confusing"



## 3:6 Exceptions ##

**What is an exception? ** - "An exception is simply an *exceptional state* in your code. It is not necessarily a bad thing, but it is Ruby's way of letting you know that your code is behaving unexpectedly. If an exception is raised and your code does not handle the exception, your program will crash and Ruby will provide a message telling you what type of error was encountered."

"Ruby provides a hierarchy of built-in classes to simplify exception handling. In fact, the exception names that you see when your program crashes, such as `TypeError`, are actually class names. The class at the very top of the hierarchy is the `Exception` class. `Exception` has several subclasses, many of which have descendants of their own"

To simplify

```ruby
Exception
  NoMemoryError
  ScriptError
    LoadError
    NotImplementedError
    SyntaxError
  SecurityError
  SignalException
    Interrupt
  StandardError
    # ...
  SystemExit
  SystemStackError
  fatal
```

The `StandardError` class is the superclass of pretty much every exception you actually want to handle, and custom exception classes should subclass `StandardError`, not `Exception`

```ruby
Exception
  StandardError
		ArgumentError
			UncaughtThrowError
		EncodingError
		FiberError
		IOError
			EOFError
		IndexError
			KeyError
			StopIteration
		LocalJumpError
		NameError
			NoMethodError
		RangeError
			FloatDomainError
		RegexpError
		RuntimeError # `raise [message]` without specific class will raise this
    SystemCallError
			Errno::*
		ThreadError
		TypeError
		ZeroDivisionError
```

Pressing `ctrl-c` during program operation "actually raises an exception via the `Interrupt` class"

Handling *all* exceptions can be very dangerous: "there are some errors that we *should* allow to crash our program. Important errors such as `NoMemoryError`, `SyntaxError`, and `LoadError` must be addressed in order for our program to operate appropriately. Handling all exceptions may result in masking critical errors and can make debugging a very difficult task."

"The action you choose to take when handling an exception will be dependent on the circumstances; examples include logging the error, sending an e-mail to an administrator, or displaying a message to the user"

`begin/rescue` block

```ruby
begin
  # put code at risk of failing here
rescue
  # take action
end
```

In method definitions, you can usually dispense will `begin` if you think the entire method definition code might cause exceptional behavior

```ruby
def undefined_division
  1 / 0
rescue ZeroDivisionError => e
  puts e.message
end
```

However you can still use a `begin` to be more specific about the area of potentially exceptional code

```ruby
def undefined_division
  puts "I sure hope this simple division operation goes well"
  begin
    1 / 0
  rescue ZeroDivisionError => e
    puts "Nooooo, #{e.message}"
  end
end
```

"If no exception type is specified [after `rescue`], all `StandardError` exceptions will be rescued and handled"

"Remember *not* to tell Ruby to rescue `Exception` class exceptions. Doing so will rescue *all* exceptions down the `Exception` class hierarchy and is very dangerous"

"It is possible to include multiple `rescue` clauses to handle different types of exceptions that may occur."

```ruby
begin
  # some code at risk of failing
rescue TypeError
  # take action
rescue ArgumentError
  # take a different action
end
```

"Alternatively, if you would like to take the same action for more than one type of exception, you can use the syntax on line 3 below"

```ruby
begin
  # some code at risk of failing
rescue ZeroDivisionError, TypeError
  # take action
end
```

**Exception Objects and built-in methods**

"Exception objects are just normal Ruby objects that we can gain useful information from. Ruby provides built-in behaviors for these objects that you may want to use while handling the exception or debugging."

The documentation for the built-in methods that exception objects share is available under the entry for the `Exception` class.

`rescue TypeError => e`

The above syntax rescues any `TypeError` and initializes `e` to the exception object. `e` is simply a conventional name for the local variable.

`Exception#message` - returns String message

`Exception#backtrace` - returns the stack trace associated with the exception

```ruby
begin
  # code at risk of failing here
rescue StandardError => e # storing the exception object in e
  puts e.message          # output error message
end
```

`ensure` - "you may also choose to include an `ensure` clause in your `begin/rescue` block after the last `rescue` clause. This branch will always execute, whether an exception was raised or not."

"When is this useful? A simple example is resource management; the code below demonstrates working with a file. Whether or not an exception was raised when working with the file, this code ensures that it will always be closed."

```ruby
file = open(file_name, 'w')

begin
  # do something with file
rescue
  # handle exception
rescue
  # handle a different exception
ensure
  file.close # executes every time
end
```

"If there are multiple `rescue` clauses in the `begin/rescue` block, the `ensure` clause serves as a single exit point for the block and allows you to put all of your cleanup code in one place, as seen in the code above"

"One important thing to remember about `ensure` is that it is critical that this code does not raise an exception itself. If the code within the `ensure` clause raises an exception, any exception raised earlier in the execution of the `begin/rescue` block will be masked and debugging can become very difficult"

`retry`

"it is unlikely that you will use [`retry`] very often"

"using `retry` in your `begin/rescue` block redirects your  program back to the `begin` statement. This allows your program to make another attempt to execute the code that raise an exception. You may find `retry` useful when connecting to a remote server, for example."

However, "beware that if your code continually fails, you risk ending up in an infinite loop. In order to avoid this, it's a good idea to set a limit on the number of times you want `retry` to execute."

"`retry` must be called within the `rescue` block, using `retry` elsewhere will be a `SyntaxError`"

```ruby
RETRY_LIMIT = 5

begin
  attempts = attempts || 0
  # do something
rescue
  attempts += 1
  retry if attempts < RETRY_LIMIT
end
```

"So far, [we have] discussed how to handle exceptions raise by Ruby. In the previous code examples, we have had no control over when to raise an exception or which error type to use; it has all been decided for us."

"*Handling* an exception is a reaction to an exception that has already been *raised*."

"Ruby actually gives you the power to manually raise exceptions yourself by calling `Kernel#raise`. This allows you to choose what type of exception to raise and even set your own error message. If you do not specify what type of exception to raise, Ruby will default to `RuntimeError` (a subclass of `StandardError`)."

"There are a few different syntax options you may use when working with `raise`, as seen below"

```ruby
raise TypeError.new("Something went wrong!")
raise TypeError, "Something went wrong!"
```

"In the following example, the exception type will default to a `RuntimeError`, because no other is specified"

```ruby
def validate_age(age)
  raise("invalid age") unless (0..105).include?(age)
end

begin
  validate_age(age)
rescue RuntimeError => e
  puts e.message
end
```

It is important to understand that exceptions you raise manually in your program can be handled in the same manner as exceptions Ruby raises automatically.

"Ruby allows us the flexibility to create our own custom exception classes"

```ruby
class ValidateAgeError < StandardError; end
```

"Notice that our custom exception class `ValidateAgeError` is a subclass of an existing exception. This means that `ValidateAgeError` has access to all of the built-in exception object behaviors Ruby provides, including `Exception#message` and `Exception#backtrace`"

"You should always avoid masking exceptions from the `Exception` class itself and other system-level exception classes. Concealing these exceptions is dangerous and will suppress very serious problems in your program -- *don't do it*"

"Most often you will want to inherit from `StandardError`"

"When using a custom exception class, you can be specific about the error your program encountered by giving the class a very descriptive name. Doing so may aid in debugging"

```ruby
class ValidateAgeError < StandardError; end

def validate_age(age)
  raise ValidateAgeError, "invalid age" unless (0..105).include?(age)
end

age = 52

begin
  validate_age(age)
rescue ValidateAgeError => e
  puts e.message
end
```



"You can raise and handle custom exceptions just like any built-in exception that Ruby provides"

It seems to me from trying it out that your custom exception class *must* inherit from an existing exception class in order to be raised properly (not just so it gets the built-in `Exception methods)





























