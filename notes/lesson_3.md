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
