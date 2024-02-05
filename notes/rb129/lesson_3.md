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















































