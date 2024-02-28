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

