## Fake Operators and Equivalence ##

**<u>3: 2: Equivalence</u>**

"When we compare `str1` with `str2` using `==`, the string objects somehow know to compare their values, even though they're different objects. What we're asking is 'are the values within the two objects the same?' and *not* 'are the two objects the same'"

"But... suppose we care about whether the two variables actually point to the *same* object? That's where another method comes in: the `equal?` method"



* `==` is a fake operator -- it is actually a method, conventionally defined to test for object-value equality between two different objects
* the `equal?` method is defined to test for object equality between two variables, essentially checking whether two variables point to the same object



```ruby
str1 = "something"
str2 = "something"
str1_copy = str1

# comparing the string object's values
str1 == str2 # true
str1 == str1_copy # true
str2 == str1_copy # true

# comparing the actual objects
str1.equal? str2 # false
str1.equal? str1_copy # true
str2.equal? str1_copy # false
```

"Notice that when we use `==` to compare the string object values, everything is `true`; all 3 variables have the value `"something"`. However, the story changes when we use the `equal?` method. Because the `equal?` method checks to see if the two objects are the same, only `str1.equal? str1_copy` returns `true`. This is because `str1` and `str1_copy` reference the same object, or space in memory.

"`==` is not an operator in Ruby, like the `=` assignment operator. Instead, it's actually an instance method available on all objects. Ruby gives the `==` method a special syntax to make it look like a normal operator. For example, instead of calling the method as `str1.==(str2)`, we can use the more natural syntax `str1 == str2`. Both options are functionally equivalent. This syntactical sugar is a double-edged sword: it allows us to write more naturally, but makes deciphering code more difficult for beginners."

* Fake operator methods like `==` have a special syntactical sugar that allows them to be called like operators. So the method call `obj1.==(obj2)` is semantically equivalent to `obj1 == obj2`. Both forms of syntax call the same method.

"Since it's an instance method, the answer to "how does `==` know hat value to use for comparison" is" it's determined by the class"

* The value `==` compares is determined by the `==` method definition found in the method lookup path of the calling object

"The original `==` method is defined in the `BasicObject` class, which is the parent class for *all* classes in Ruby. This implies *every* object in Ruby has a `==` method. However, each class should define the `==` method to specify the value to compare."



"Suppose we have a `Person` class:"

```ruby
class Person
  attr_accessor :name
end

bob = Person.new
bob.name = "bob"

bob2 = Person.new
bob2.name = "bob"

bob == bob2 # false

bob_copy = bob
bob == bob_copy # true
```

"This implies that the default implementation for `==` is the same as `equal?` (which is also in the `BasicObject` class). It's not very useful, because when we use `==`, we don't actually want to ask "are the two variables pointing to the same object?", and instead, we want to ask "are the values in the two variables the same? To tell Ruby what 'the same' means for a `Person` object, we need to define the `==` method."

* `BasicObject#==` is inherited by every class that does not override it. The `BasicObject` implementation is functionally equivalent to the `BasicObject#equal?` method, comparing for actual object equality. Therefore, custom classes need to override it in order to specify which value should be used for the expected value equality comparison.

```ruby
class Person
  attr_accessor :name
  
  def ==(other)
    name == other.name # relying on String#== here
  end
end

bob = Person.new
bob.name = 'bob'

bob2 = Person.new
bob2.name = 'bob'

bob == bob2 # true
```

"By defining a `==` method in our `Person` class, we're overriding the default `BasicObject#==` behavior, and providing a much more meaningful way to compare two `Person` objects."

"Note that the `Person#==` method we just wrote uses the `String#==` method for comparison. That's perfectly ok, and almost every Ruby core library class will come with its own `==` method. Therefore, you can sagely use `==` to compare `Array`, `Hash`, `Integer`, `String`, and many other objects. But just remember there's a method *somewhere* backing that equality comparison, and so it can be modified"

"You can imagine that the implementer of [the `Integer#==` method] took care to consider the possibility of comparing an integer with a float, and handled the conversion from float to integer appropriately"

* Some core classes define `==` to include the possibility of comparing objects of two different classes for value equality, such as Integer and Float

"when you define a `==` method, you also get the `!=` for free"

* When a custom class defines the `==` method, Ruby defines a corresponding `!=` method automatically

"Every object has a method called `object_id`, which returns a numerical value that uniquely identifies the object. We can use this method to determine whether two variables are pointing to the same object. We could do this with `equal?` as well, but let's play around with `object_id`"

"Symbols and integers behave slightly differently in Ruby than other objects. If two symbols or two integers have the same value, they are also the same object. This is a performance optimization in Ruby, because you can't modify a symbol or integer. This is also why Rubyists prefer symbols over strings to act as hash keys: it's a slight performance optimization and saves on memory"

* If a symbol has the same value as another symbol, they will be the same object. The same is true for integers

"The `===` method... just like `==`... looks like a built-in Ruby operator when you use it, but it's in fact an instance method. The more confusing part about this method is that it's used implicitly by the `case` statement"

```ruby
num = 25

case num
when 1..50
  puts "small number"
when 51..100
  puts "large number"
else
  puts "out of range"
end
```

This code calls `Range#===` with the `case` expression passed as argument for each Range object in each `when` clause. The code is equivalent to:

```ruby
num = 25

if (1..50) === num
  puts "small number"
elsif (51..100) === num
  puts "large number"
else
  puts "out of range"
end
```

"`===` doesn't compare two objects the same way that `==` compares two objects. When `===` compares two objects, such as `(1..50)` and `25`, it's essentially asking 'if `(1..50)` is a group, would `25` belong in that group?' In this case, the answer is 'yes'"

* `===` is another fake operator method, normally called automatically by `case` statements.
* The `===` method is usually defined such that the caller represents a group and the method is checking whether the object passed as argument belongs in that group

"Finally, we get to the last equality comparison method: `eql?`. The `eql?` method determines if two objects contain the same value and if they're of the same class. This method is used most often by `Hash` to determine equality among its members. It's not used very often"

* `eql?` is used by Hash objects to determine equality among members. It is rarely called explicitly



"

Most Important

`==`

* for most objects, the `==` operator compares the values of the objects, and is frequently used
* the `==` operator is actually a method. Most built-in Ruby classes, like Array, String, Integer, etc, provide their own `==` method to specify how to compare objects of those classes
* by default, `BasicObject#==` does not perform an equality check; instead it returns `true` if two objects are the same object. This is why other classes often provide their own behavior for `#==`
* If you need to compare custom objects, you should define the `==` method

Less Important

`equal?`

* the `equal?` method goes one level deeper than `==` and determines whether two variables not only have the same value, but also whether they point to the same object
* do not define `equal?`
* the `equal?` method is not used very often
* calling `object_id` on an object will return the object's unique numerical value. Comparing two objects' `object_id` has the same effect as comparing them with `equal?`

`===`

* used implicitly in `case` statements
* like `==`, the `===` operator is actually a method
* you rarely need to call this method explicitly, and only need to implement it in your custom classes if you anticipate your objects will be used in `case` statements, which is probably pretty rare

`eql?`

* used implicitly by `Hash`
* very rarely used explicitly

"

**<u>3:5: Fake Operators</u>**

"One reason Ruby is hard for beginners is due to its liberal syntax. We've already seen ... that the 'double equals' equality operator, `==`, is actually a method and not a real operator. It only *looks* like an operator because Ruby gives us special **syntactical sugar** when invoking that method. Instead of calling the method normally (eg, `str1.==(str2)`), we can call it with a special syntax that reads more naturally (eg, `str1 == str2`)"

From the table,

```ruby
# Real operators
. , ::
&&
||
.. ...
? :
= %= /= -= += |= &= >>= <<= *= &&= ||= **= { }
```

all other operators are actually methods

... defining `>` and `<` etc ...

shift operators

"When implementing fake operators, choose some functionality that makes sense when used with the special operator-like syntax. For example, using the `<<` method fits well when working with a class that represents a collection"

```ruby
class Team
  attr_accessor :name, :members
  
  def initialize(name)
    @name = name
    @members = []
  end
  
  def <<(person)
    members.push person
  end
end

cowboys = Team.new("Dallas Cowboys")
emitt = Person.new("Emmitt Smith", 46)

cowboys << emmitt
cowboys.members
```

"By implementing a `Team#<<` method, we provided a very clean interface for adding new members to a team object. If we wanted to be strict, we could even build in a guard clause to reject adding the member unless some criteria is met"

```ruby
def <<(person)
  return if person.not_yet_18?
  members.push person
end
```

"Adding the shift operators can result in very clean code, but they make the most sense when working with classes that represent a collection"

```ruby
class Book
  def initialize(author, title)
    @author = author
    @title = title
  end
  
  def ==(other)
    author == other.author && title == other.title
  end
  
  attr_reader :author, :title

  def to_s
    "#{title}, #{author}"
  end
end

class Bookshelf
  def initialize(number)
    @number = number
    @books = []
  end
  
  def <<(book)
    return if books.include?(book)
    books << book
  end
  
  def display_books
    p books.map(&:to_s)
  end

  attr_reader :books
end

bookshelf = Bookshelf.new(1)

tolstoy = Book.new("Tolstoy", "Anna Karenina")
kafka = Book.new("Kafka", "The Trial")
proust = Book.new("Proust", "Swann's Way")
karenina = Book.new("Tolstoy", "Anna Karenina")

bookshelf << tolstoy
bookshelf << kafka
bookshelf << proust
bookshelf.display_books
puts "--"
bookshelf << karenina
bookshelf.display_books
```

The plus method

"

* `Integer#+` - increments the value by value of the argument, returning a new integer
* `String#+` - concatenates with argument, returning a new string
* `Array#+` - concatenates with argument, returning a new array
* `Date#+` - increments the date in days by value of the argument, returning a new Date

"

"The functionality of the `+` method should be either incrementing or concatenation with the argument... it's probably a good idea to follow the general usage of the standard libraries [includes returning a new object of the same class as the caller]"

* When defining a custom `+` method, it should follow the usage of the standard library. This means it should either increment a value by the argument, or concatenate a value with the argument, and then return a new object of the class

```ruby
class BitString
  def initialize(v)
    @value = v
  end

  attr_accessor :value

  def +(other)
    BitString.new(value + other.value)
  end

  def to_s
    value
  end
end

str1 = BitString.new('01011010')
str2 = BitString.new('10111011')
str3 = str1 + str2
puts "str1: #{str1}"
puts "str2: #{str2}"
puts "new bitstring: #{str3}"
puts str3.class
```

**Element setter and getter methods**

"the syntactical sugar given to these methods is so extreme"

```ruby
my_array = %(first second third fourth)

# element reference
my_array[2]			# third
my_array.[](2)  # third

puts my_array.inspect # ["first", "second", "third", "fourth"]

my_array[4] = "fifth"
puts my_array.inspect # ["first", "second", "third", "fourth", "fifth"]

my_array.[]=(5, "sixth")
puts my_array.inspect # ["first", "second", "third", "fourth", "fifth", "sixth"]
```

"If we want to use the element setter and getter methods in our class, we first have to make sure we're working with a class that represents a collection... let's follow the lead of the Ruby standard library and build them as simple getter (reference) and setter (assignment) methods for elements in our collection"

```ruby
class Bookshelf
  # code omitted
  
  def [](idx)
    books[idx] # depending on Array#[]
  end
  
  def []=(idx, obj)
    books[idx] = obj # depending on Array#[]=
  end
end

# code omitted
bookshelf[4] = Book.new("Dickens", "Great Expectations")
puts bookshelf[4] # "Great Expectations, Dickens"
```



"This syntactical sugar adds a new readability to our code"

* When defined logically, following the conventions of the Ruby standard library, defining operator methods in custom classes and taking advantage of their syntactic sugar can enhance the readability of our code



"In this assignment, we saw how many operators are in fact methods that Ruby gives special treatment to. Because they are methods we can implement them in our classes and take advantage of the special syntax for our own objects. If we do that, we must be careful to follow conventions established in the Ruby standard library. Otherwise, using those methods will be very confusing"

* Many Ruby operators are in fact methods that Ruby gives special treatment to
* Like other methods, we can implement our own version in custom classes and take advantage of their syntactic sugar
* When defining fake operator methods, we must be careful to follow conventions, especially those of the Ruby standard library, or our code may become confusing



**Definition**

* Many Ruby operators are in fact methods to which Ruby gives special treatment by providing syntactic sugar that allows them to be invoked in the style of operators
* Fake operator methods like `==` have a special syntactical sugar that allows them to be called like operators. So the method call `obj1.==(obj2)` is semantically equivalent to `obj1 == obj2`. Both forms of syntax call the same method.
* `==` is a a method conventionally defined to test for object-value equality between two different objects
* the `equal?` method is defined to test for object equality between two variables, essentially checking whether two variables point to the same object. It should not be redefined
* `===` is another equality operator method, normally called only implicitly in `case` statements. The general semantic for `===` is to check whether the object passed as argument belongs in the group represented by the caller
* `eql?` is used by Hash objects to determine equality among key members. It is rarely called explicitly

**Implementation**

* The value `==` compares is determined by the `==` method definition found in the method lookup path of the calling object. All operator methods behave like regular methods in this respect
* `BasicObject#==` is inherited by every class that does not override it. The `BasicObject` implementation is functionally equivalent to the `BasicObject#equal?` method, comparing for actual object equality. Therefore, custom classes need to override it in order to specify which value should be used for the expected value equality comparison.
* When defining operator methods in custom classes, it is best to respect the conventions and semantics of the operator methods in Ruby's standard library classes: `Array#[]=`, `Integer#+`, `String#+`, and so on
* Some core classes define `==` to include the possibility of comparing objects of two different classes for value equality, such as Integer and Float
* When a custom class defines the `==` method, Ruby defines a corresponding `!=` method automatically
* The `===` method is usually defined such that the caller represents a group and the method is checking whether the object passed as argument belongs in that group
* If a symbol has the same value as another symbol, they will be the same object. The same is true for integers. These are special cases whose implementation is different to other objects for optimization reasons
* When defining a custom `+` method, it should follow the usage of the standard library. This means it should either increment a value by the argument, or concatenate a value with the argument, and then return a new object of the class
* Element getter `[]` and element setter methods `[]=` should be defined for collection classes following the conventions of the Ruby standard library
* When defining fake operator methods, we must be careful to follow conventions, especially those of the Ruby standard library, or our code may become confusing
* The `Object#object_id` method returns an Integer number that uniquely identifies that object. Comparing object ids thus performs the same object identity check as `equal?`

**Benefits**

* When they are defined logically, following the conventions of the Ruby standard library, custom operator methods can enhance the readability of our code

```ruby
# real operators
. , ::				# Method and constant resolution operators
&& ||         # Logical operators
.. ...				# Range operators
?:						# The ternary operator
= %= /= -= |= # assignment operator, and
&= >>= <<= *= # operation-and-reassignment shortcut operators
&&= ||= **=
{ }						# block delimiters
```









LS equality bullet points

Most Important

`==`

* for most objects, the `==` operator compares the values of the objects, and is frequently used
* the `==` operator is actually a method. Most built-in Ruby classes, like Array, String, Integer, etc, provide their own `==` method to specify how to compare objects of those classes
* by default, `BasicObject#==` does not perform an equality check; instead it returns `true` if two objects are the same object. This is why other classes often provide their own behavior for `#==`
* If you need to compare custom objects, you should define the `==` method

Less Important

`equal?`

* the `equal?` method goes one level deeper than `==` and determines whether two variables not only have the same value, but also whether they point to the same object
* do not define `equal?`
* the `equal?` method is not used very often
* calling `object_id` on an object will return the object's unique numerical value. Comparing two objects' `object_id` has the same effect as comparing them with `equal?`

`===`

* used implicitly in `case` statements
* like `==`, the `===` operator is actually a method
* you rarely need to call this method explicitly, and only need to implement it in your custom classes if you anticipate your objects will be used in `case` statements, which is probably pretty rare

`eql?`

* used implicitly by `Hash`
* very rarely used explicitly

"



