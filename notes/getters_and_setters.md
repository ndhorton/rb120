## Use `attr_*` to create setter and getter methods ##

```ruby
class Person
  def initialize(name)
    @name = name
  end

  def name
    @name
  end
  
  def name=(name)
    @name = name
  end
end
```

is equivalent to

```ruby
class Person
  def initialize(name)
    @name = name
  end

  attr_accessor :name
end
```

If we only want the getter method for the `@name` instance variable, we can change `attr_accessor` to `attr_reader`. Likewise, if we only want a setter method for `@name`, we can change `attr_accessor` to `attr_writer`.

Since the attribute access methods `attr_*` generate simple setters and getters, it is sometimes necessary to define custom setters and getters to perform checks on input before setting a variable, or to format or hide information stored in an instance variable before returning it.

A getter method defined as above (with a name ending in `=`) will always return the object passed as argument to the method after setting the instance variable to it.



**Definition**

* `attr_*` methods are three methods that are shorthand for the creation of getter methods and setter methods. A getter method is used to retrieve information referenced by an instance variable of an object. A setter method is used to set an instance variable of an object.
* An instance variable named in a class, combined  with any setters and getters it might have, can be referred to as an  'attribute'.

**Implementation**

* `attr_reader` followed by a symbol creates a getter method with the name given by the symbol for an instance variable with the same name (with `@` prepended)
* `attr_writer` creates a getter method in the same fashion as above
* `attr_accessor` creates both a getter and setter method for an instance variable

**Benefits**

* If you only require a basic setter and/or getter method for an attribute, using the `attr_*` methods to define them leads to lexically shorter and more legible classes



## How to call setters and getters ##

**Definition**

* A getter method is used to retrieve information referenced by an instance variable of an object. A setter method is used to set an instance variable of an object.

**Implementation**

* Client code can call public getter methods on an object using the dot operator
* Client code can call public setter methods on an object using either standard method call syntax, or more often, using the special syntactic sugar that Ruby provides to make setter methods resemble assignment
* Within the instance method definitions of a class, a getter method can be called with the current object as implicit caller
* Within the instance method definitions of a class, a setter method can only be called explicitly on the current object referenced by the `self` keyword

**Benefits**

* Ruby encapsulates instance variables within the object. Getters and setters provide a way to access the objects referenced by instance variables from outside the object. Class authors can decide on the level of access to an instance variable by choosing which getters and setters to expose in the public interface
* Within the class, using getters and setters instead of directly referencing or assigning instance variables means that certain checks or other functionality can be implemented in one place to control what information is retrieved from an attribute and what values can be tracked by an attribute. For example, a getter may be defined to return only part of the sensitive information tracked by an instance variable. Or a setter may check that a value conforms to certain invariants before allowing it to be assigned to an instance variable.



two main situations

* calling them from outside the object
* calling them within the class definition - the need to use `self` as caller for setter methods

To call public setter and getter methods from outside the object, we use the dot operator like any other public method. However, in addition to the standard method calling syntax, Ruby provides syntactic sugar to make setter methods appear more like assigning a variable.

```ruby
class Person
  def initialize(name)
    @name = name
  end

  attr_accessor :name
end

bob = Person.new('Steve')
bob.name # => "Steve"

bob.name=("Bob")
bob.name = "Bob" # syntactic sugar semantically equivalent to line 12

bob.name # => "Bob"
```

(This example is too similar to the material. Try to think of a custom class)

Within a class definition, setter and getter methods can be called within instance method definitions.

Setters are called on the implicit current object, just like other instance methods. However, setter methods called within the class definition must be called on the current object explicitly, using the `self` keyword.

```ruby
class Employee
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
  
  attr_accessor :first_name, :last_name

  def full_name
    first_name + ' ' + last_name
  end
  
  def capitalize_name!
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end
end
```

(This example is kind of poor)

If we attempt to call a setter method within the class definition without `self` as the explicit caller, Ruby would interpret this as initializing a new local variable.

```ruby
class Employee
  # code omitted
  def capitalize_name!
    first_name = first_name.capitalize # initialize `first_name` local variable
    last_name = last_name.capitalize # initialize 'last_name` local variable
  end
end
```

