# What's the Output?

# On line 16, the getter method `Pet#name` is called on the `Pet` object `fluffy` and the return value,
# the string `"Fluffy"` referenced by `@name` is passed to `puts` and printed to screen. This prints the string
# that was passed to the `Pet::new` method without modification.
# On the following line, line 17, the `Pet` object `fluffy` itself is passed to `puts`, and since `puts`
# always calls the `to_s` method of the object passed as argument, the destructive call to `String#upcase!`
# on line 9 mutates the state of the String object assigned to `@name`. So line 17 will print `My name is FLUFFY.`
# in upper case and this change of case will persist.
# So although the code on line 18 is identical to the code on line 16, the state of the string object
# referenced by `@name` returned by `Pet#name` will reflect the mutation performed by the `Pet#to_s` method: `FLUFFY`

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

# To make the `to_s` method behave in a more predicatable manner, we need simply remove the
# mutating call to `String#upcase!` and call the non-mutating `upcase` method on `@name`
# where it is interpolated into the string literal on line 21.

# 11:43

# Further exploration

# On line 1, the variable `name` which is local to the `main` scope is initialized to
# the Integer object 42. Then `name` is passed to the `Pet::new` method on line 2, and the
# Pet object returned is assigned to local variable `fluffy`. The `new` method invoked the
# `Pet#initialize` method which called `Integer#to_s` on the Integer object passed as argument
# before the resulting new String object is assigned to `@name`.
# On line 3, the local variable `name`, which still references the Integer 42, is reassigned to the
# Integer `1` greater, 43, with `+=` syntactic sugar.
# When the `Pet#name` method is called on `fluffy` on line 4, the object returned and passed to `puts` is
# the String object still referenced by `@name`, `"42"`.
# Line 5, where `fluffy` is passed to `puts` will call the `Pet#to_s` method and print `"My name is 42"`.
# Line 6 will again print the string value `42`. Finally, line 7 will print `43`, since local variable `name`
# references the incremented Integer.
puts "--"

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name