## Equivalence, 3,2:

* `BasicObject#==` - tests for equality of values, not objects
* `BasicObject#equal?` - tests for identity of objects, rather than equivalence of values. Unlike `==`, should never be overridden in subclasses
* `Object#===` - overridden by subclasses to provide semantics for case statements
* `Object#eql?` - returns `true` if two objects contain the same value and are of the same class

`BasicObject#==` is generally overridden to provide class-specific meanings for objects of subclasses; it usually tests equivalence of some primary attribute of the class. So comparing two String objects with `String#==` tests for the equivalence of their string values (rather than their `String#size` attributes), and so on.

`Object#eql?` has to do with equivalence of hash keys (i.e. it returns `true` if and only if the two objects return the same value when put through the hash function (not sure if this is to do with Ruby's internal lookup tables or the actual Hash class implementation, or whether the same algorithm is used for both)).

The `==` method compares the values of the objects referenced by two variables whereas the `equal?` method compares the variables to see if they point to the same object

So, in a sense, a bit like

```c
int *a = malloc(1 * sizeof(int));
int *b = malloc(1 * sizeof(int));

*a = 5;
*b = 5;

printf("is a equal to b in the sense of Ruby's `==` method?\n");
if (*a == *b) // dereference and compare integer values
    printf("yes\n");
else
    printf("no\n");

printf("is a equal to b in the sense of Ruby's `equal?` method?\n");
if (a == b)   // compare addresses/pointers
    printf("yes\n");
else
    printf("no\n");

free(b);
free(a);

// prints:
// is a equal to b in the sense of Ruby's `==` method?
// yes
// is a equal to b in the sense of Ruby's `equal?` method?
// no
```

but not exactly, in the sense that no variables need be involved at all, e.g.

```ruby
5 == 5 # true
5.equal?(5) # true

:symbol_value == :symbol_value # true
:symbol_value.equal? :symbol_value # true
```

Here we can reference and compare the same identical object without variables because Integer objects are immutable (and have a built in literal notation). The same goes for symbols.



When you override the `BasicObject#==` method in a custom class, you get a `!=` method for your custom class for free.

## Variable Scope, 3: 3 ##

**Instance variable scope**

Instance variables "are scoped at the object level. They are used to track individual object state, and do not cross over between objects." 

If you try to reference an uninitialized local variable, you will raise a `NameError` exception. But if you try to reference an uninitialized instance variable, this action will simply return `nil`.

An odd piece of behavior is the following:

```ruby
class Person
  @name = 'dave'
  
  def name
    @name
  end
  
  def self.name
    @name
  end
end

p Person.name  # outputs `"dave"`

dave = Person.new
p dave.name    # outputs `nil`
```

So it seems like if you initialize an instance variable at the class level, that instance variable pertains only to the class itself and -- *unlike* class  variables -- it will not be available within instance methods.

"don't do that for now... instance variables initialized at the class level are an entirely different thing called *class instance variables*. You shouldn't worry about that yet, but just remember to initialized instance variables within instance methods."



**Class Variable Scope**

Class variables are scoped at the class level.

* all object instances of a class share 1 copy of any given class variable defined in that class and can access class variables via instance methods
* class methods can access a class variable provided the class variable has been initialized prior to calling the method

If you attempt to access a class variable that has not been initialized, this will raise a `NameError`.

Only class variables can share state between objects (ignoring globals)



**Constant Variable Scope**

"Constant variables are usually just called constants, because you're not supposed to re-assign them to a different value. If you do re-assign a constant, Ruby will warn you (but won't generate an error)."

Constants have *lexical scope*. "**Lexical scope** means that where the constant is defined in the source code determines where it is available. When Ruby tries to resolve a constant, it searches lexically -- that is, it searches the surrounding structure (i.e., lexical scope) of the constant reference."

## Inheritance and Variable scope ##



"unlike instance methods, instance variables and their values are not inherited"

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



"class variables are available to sub-classes. Note that since this class variable is initialized in the `Animal` class, there is no method to explicitly initialize it. The class variable is loaded when the class is evaluated in Ruby."

However, this means you cannot override a class variable initialized at the class level, only reassign it (and it will then be reassigned for the superclass as well as the subclass, and also any other subclasses of the superclass, since a class variable initialized at the class level of a superclass will be shared by all subclasses).

"For this reason, avoid using class variables when working with inheritance. In fact, some Rubyists would go as far as recommending avoiding class variables altogether. The solution is usually to use *class instance variables*, but that's a topic we aren't ready to talk about yet."

So, instance variables are not inherited since they come to be initialized by behavior, which is inherited. Class variables are not so much inherited as **shared** by subclasses, and the shared variable can only be reassigned, not overridden with a class variable of the same name.

"Ruby first attempts to resolve a [reference to a] **constant** by searching in the lexical scope of that reference. If this is unsuccessful, Ruby will then traverse up the inheritance hierarchy *of the structure that references the constant*... [However, the] top-level scope is only searched *after* Ruby tries the inheritance hierarchy.

""**Constants** have *lexical scope*, meaning the  position of the code determines where it is available. Ruby attempts to  resolve a constant by searching lexically of the reference, then by  inheritance of the enclosing class/module, and finally the top level."

## Fake Operators, 3:5 ##

Real operators (not methods):

`.`  `,` `::` - method/constant resolution operators

`&&` `||` - logical AND and OR

`..` `...` - range operators

`? :` - ternary operator(s)

`=` `%=` `/=` `-=` `|=` `&=` `>>=` `<<=` `*=` `&&=` `||=` `**=` - assignment and operation/assignment shortcuts

`{` - block delimiter

in addition, `!~` cannot be directly defined in custom classes, though it is a method



## Exceptions, 3:6 ##

* `Kernel#raise` - raise an exception
* `begin` - opens a block for potentially exceptional code
* `rescue` - opens block to handle exceptions when raised in a `begin` block
* `ensure` - comes after all `rescue` blocks and executes whether an exception is raised or not
* `retry` - can only be used in a `rescue` block; retries execution of the `begin` block
* `Exception#message` - returns error message
* `Exception#backtrace` - returns an array containing lines of text tracing the path of execution that led to the exception being raised

"An **exception** is simply an **exceptional state** in your code"

"[An exception] is not necessarily a bad thing, but it is Ruby's way of letting you know that your code is behaving unexpectedly. If an exception is raised an your code does not handle the exception, your program will crash and Ruby will provide a message telling you what type of error was encountered"

"Ruby provides a hierarchy of built-in classes to simplify exception handling. In fact, the exception names that you see when your program crashes, such as `TypeError`, are actually class names. The class at the very top of the hierarchy is the `Exception` class. `Exception` has several subclasses, many of which have descendants of their own"

**Exception Class Hierarchy**

```ruby
Exception
	NoMemoryError
	ScriptError
		LoadError
		NotImplementedError
		SyntaxError					- raised when syntax invalid (missing `end` etc)
	SecurityError
	SignalException
		Interrupt						- pressing Ctrl-C raises an exception via Interrupt
	StandardError					- many familiar children/grandchildren
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
		RuntimeError
		SystemCallError
			Errno::*
		ThreadError
		TypeError
		ZeroDivisionError
	SystemExit
	SystemStackError		- raised in the case of stack overflow, too-deep recursion
	fatal
```

"Most often, the errors you want to handle are the descendants of the `StandardError` class... Generally, it is safe to handle these exceptions and continue running the program"



"Some exceptions are more serous than others; there are some errors that we *should* allow to crash our program. Important errors such as `NoMemoryError`, `SyntaxError`, and `LoadError` must be addressed in order for our program to operate appropriately. Handling all exceptions may result in masking critical errors and can make debugging a very difficult task"

"In order to avoid causing unwanted behaviors yourself, it is important to be intentional and very specific about which exceptions you want to handle and what action you want to take when you handle them... examples include logging the error, sending an e-mail to an administrator, or displaying a message to the user"

**The `begin`/`rescue` block**

```ruby
# The begin/rescue block

begin
  # put code at risk of failing here
rescue TypeError
  # take action
end
```

"If no exception type is specified, all `StandardError` exceptions will be rescued and handled. Remember *not* to tell Ruby to rescue `Exception` class exceptions. Doing so will rescue *all* exceptions down the `Exception` class hierarchy and is very dangerous"

So the default for `rescue` without argument is limited to `StandardError` and its descendants.

```ruby
begin
  # some code at risk of failing
rescue TypeError
  # take action
rescue ArgumentError
  # take a different action
end
```

or, if multiple types of exception need the same action taken

```ruby
begin
  # some code at risk of failing
rescue ZeroDivisionError, TypeError
  # take action
end
```

**Exception Objects and Built-in Methods**

"Exception objects are just normal Ruby objects that we can gain useful information from. Ruby provides behaviors for these objects that you may want to use while handling the exception or debugging"

```ruby
rescue TypeError => e # when TypeError raised, assigns exception object to variable e
```

```ruby
begin
  # code at risk of failing here
rescue StandardError => e # stores exception object in e
  puts e.message          # output error message
end
```

"You may also choose to include an `ensure` clause in your `begin`/`rescue` block after the last `rescue` clause. This branch will always execute, whether an exception was raised or not. So, when is this useful? A simple example is resource management; the code below demonstrates working with a file. Whether or not an exception was raised when working with the file, this code ensures that it will always be closed"

```ruby
file = open(file_name, 'w')
begin
  # do something with file
rescue
  # handle exception
rescue
  # handle a different exception
ensure
  file.close # executes every time, regardless of exception raised or not
end
```

"If there are multiple `rescue` clauses in the `begin`/`rescue` block, the `ensure` clause serves as a single exist point for the block and allows you to put all of your cleanup code in one place"

"One important thing to remember about `ensure` is that it is critical that this code does not raise an exception itself. If the code within the `ensure` clause raises an exception, any exception raised earlier in the execution of the `begin`/`rescue` block will be masked and debugging can become very difficult"

"Using `retry` in your `begin`/`rescue` block redirects your program back to the `begin` statement. This allows your program to make another attempt to execute the code that raised an exception. You may find `retry` useful when connecting to a remote server, for example. Beware that if your code continually fails, you risk ending up in an infinite loop. In order to avoid this, it's a good idea to set a limit on the number of times you want `retry` to execute. `retry` must be called within the `rescue` block... using `retry` elsewhere will raise a `SyntaxError`"

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



`Kernel#raise` allows you to raise an exception yourself. "This allows you to choose what type of exception to raise and even set your own error message. If you do not specify what type of exception to raise, Ruby will default to `RuntimeError` ( a subclass of `StandardError`)"

```ruby
raise TypeError.new("Something went wrong!")
raise TypeError, "Something went wrong!"
```

In the following code, the exception type will default to `RuntimeError`

```ruby
def validate_age(age)
  raise("invalid age") uless (0..105).include?(age)
end
```

"exceptions you raise manually in your program can be handled in the same manner as exceptions Ruby raises automatically"

```ruby
begin
  validate_age(age)
rescue RuntimeError => e
  puts e.message         # => "invalid age"
end
```

**Raising custom exceptions**

"In addition to providing many built-in exception classes, Ruby allows us the flexibility to create our own custom exception classes"

```ruby
class ValidateAgeError < StandardError; end
```

"Notice that our custom exception class `ValidateAgeError` is a subclass of an existing exception. This means that `ValidateAgeError` has access to all of the built-in exception object behaviors Ruby provides, including `Exception#message` and `Exception#backtrace`."

"Most often you will want to inherit from `StandardError`"

```ruby
def validate_age(age)
  raise ValidateAgeError, "invalid age" unless (0..105).include?(age)
end

begin
  validate_age(age)
rescue ValidateAgeError => e
  # take action
end
```

