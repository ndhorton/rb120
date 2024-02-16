**Ruby OOP Book**

"Access Control is a concept that exists in a number of programming languages, including Ruby. It is generally implemented through the use of *access modifiers*. The purpose of access modifiers is to allow or restrict access to a particular thing. **In Ruby, the things that we are concerned with restricting access to are the methods** defined in a class. In a Ruby context, you'll commonly see this concept referred to as **Method Access Control**"

"How do we defined private methods? We use the `private` method call in our program and anything below it is private (unless another method, like `protected`, is called after it to negate it)"

* Access modifier methods `Module#public`, `Module#private` and `Module#protected` control access to methods.
* Methods are public by default, so the most common access modifiers are `private` and `protected`
* To declare methods `public`, `private` or `protected` we simply call e.g. `private` within a class definition and then any methods defined after it will be private methods until another access modifier method is called

"A **public method** is a method that is available to anyone who knows either the class name or the object's name. These methods are readily available for the rest of the program to use and comprise the class's *interface* (that's how other classes and objects will interact with this class and its objects)"

"Sometimes you'll have methods that are doing work in the class but don't need to be available to the rest of the program. These methods can be defined as **private**."

"`private` methods are only accessible from other methods in the class"

* Public methods are methods that are available to client code and can be called anywhere there is a reference to the object. Public methods form the interface of the class
* Private methods are methods that perform work within the class but which we do not want to be available to client code as part of the interface. Private methods can only be called within the class definition on the current object. Private methods are only accessible from other methods in the class

```ruby
class GoodDog
  DOG_YEARS = 7
  
  attr_accessor :name, :age
  
  def initialize(name, age)
    name = n
    age = a
  end
  
  private
  
  def human_years
    age * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
sparky.human_years # raises `NoMethodError`, "private method `human_years` called"
```

"Public and private methods are most common, but in some less common situations, we'll want an in-between approach. For this, we can use the protected method to create `protected` methods. **Protected methods are similar to private methods in that they cannot be invoked outside the class. The main difference between them is that protected methods allow access between class instances, while private methods do not** ... protected methods cannot be invoked from outside of the class. However, unlike private methods, other instances of the class (or subclass) can also invoke the method. This allows for controlled access, but wider access between objects of the same class type"

```ruby
class Person
  def initialize(age)
    @age = age
  end
  
  def older?(other_person)
    age > other_person.age
  end

  protected
  
  attr_reader :age
end

malory = Person.new(64)
sterling = Person.new(42)

malory.older?(sterling) # true
sterling.older?(malory) # false

malory.age # NoMethodError: protected method `age` called...
```

* Protected methods are similar to private methods in that they can only be invoked by other methods within the class. However, whereas private methods can only be called on the default object, we can call protected methods on other objects of the class, or a descendant class. So if another object of the same class is passed in to a public method of the class, we can call a protected method on it, as well as on the current object.

```ruby
class Person
  attr_reader :name

  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def older_than?(other_person)
    age > other_person.age
  end
  
  protected
  
  attr_reader :age
end

tom = Person.new("Tom", 37)
greg = Person.new("Greg", 28)

puts tom.name # Tom
puts tom.older_than?(greg) # true
puts tom.age # NoMethodError: protected method `age` called ...
```

"In summary, private methods are not accessible outside of the class definition at all, [this next part no longer true:] and are only accessible from inside the class when called without `self`"

"As of Ruby 2.7, it is now legal to call private methods with a literal `self` as the caller. Note that this does **not** mean that we can call a private method with any other object, not even one of the same type. We can only call a private method with the current object"

* Before Ruby 2.7, it was illegal to call private methods with an explicit literal `self` as the caller. Since Ruby 2.7, this is no longer the case.



**Definition**

* Access modifier methods `Module#public`, `Module#private` and `Module#protected` control levels of access to methods.
* Public methods are methods that are available to client code and can be called anywhere there is a reference to the object. Public methods form the interface of the class
* Private methods are methods that perform work within the class but which we do not want to be available to client code as part of the interface. Private methods can only be called within the class definition on the current object. Private methods are only accessible from other methods in the class
* Protected methods are similar to private methods in that they can only be invoked by other methods within the class. However, whereas private methods can only be called on the default object, we can call protected methods on other objects of the class, or a descendant class. So if another object of the same class is passed in to a public method of the class, we can call a protected method on it, as well as on the current object.

**Implementation**

* Methods are public by default, so the most common access modifiers are `private` and `protected`
* To declare methods `public`, `private` or `protected` we simply call e.g. `private` within a class definition and then any methods defined after it will be private methods until another access modifier method is called

**Benefits**

* Method access control facilitates encapsulation of functionality, permitting an object to have internal access to methods that do not form part of its public interface
* Method access control facilitates the separation of interface and implementation
* Method access control can also facilitate encapsulation of state with respect to setter and getter methods