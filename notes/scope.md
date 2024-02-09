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
* instance variables keep track of an object's state; an object's instance variables are particular to that object and encapsulate the distinct state of that particular object

**<u>1:4: Attributes</u>**

"the term 'attributes' in Ruby is used quite loosely and is generally approximated as *instance variables*. Most of the time, these instance variables  have accessor methods.... however, it's not a must for the purposes of this definition"

"When we say that classes define the attributes of their objects, we're referring to how classes specify the names of instance variables each object should have (i.e., what the object should be made of). The classes also define the accessor methods ( and level of method access control); however, we're generally just pointing to the instance variables. Similarly, when we say state tracks attributes for individual objects, our purpose is to say that an object's state is composed of instance variables and their values; here, we're not referring to the getters and setters"

* an object's state is composed of instance variables and the objects they reference

