* Use attr_* to create setter and getter methods
* How to call setters and getters
* Referencing and setting instance variables vs. using getters and setters

## Ruby OOP book ##

**Calling setters and getters (and intro to getters and setters)**

An object's instance variables track the attributes defined in the class. However, there is no way to interact with an object's instance variables from outside the class without explicitly defining public methods to do

```ruby
# cannot directly access attributes/instance variables in Ruby
# from outside the object without some kind of public method

class Mouse
  def initialize(name)
    @name = name # setting an instance variable within the class
  end
end

jerry = Mouse.new("Jerry")
puts jerry.name # raises NoMethodError
```

"A `NoMethodError` means that we called a method that doesn't exist or is unavailable to the object. If we want to access the object's name, which is stored in the `@name` instance variable, we have to create a method that will return the name. We can call it `get_name`, and its only job is to return the value in the `@name` instance variable"

* An object's instance variables are only accessible to client code, if at all, through the public interface defined by the object's class.
* Client code has no way to access an object's instance variables without the object's class defining public instance methods to reference and/or set those instance variables

"Finally, as a convention, Rubyists typically want to name those *getter* and *setter* methods using the same name as the instance variable they are exposing or setting"

* The Ruby convention is to name getter and setter methods using the same name as the instance variable they reference or set

```ruby
class Mouse
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

jerry = Mouse.new("Jerry")
puts jerry.name # "Jerry"
jerry.name = "Fievel"
puts jerry.name # "Fievel"
```

"Ruby gives us a special syntax to use [getter methods]."

```ruby
class Mouse
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

jerry = Mouse.new("Jerry")
puts jerry.name # "Jerry"
jerry.name=("Mickey") # conventional method call syntax
puts jerry.name # "Mickey"
# But a method with a name ending in `=` permits special assignment-style
# syntactic sugar to be used when calling it
jerry.name = "Fievel"
puts jerry.name # "Fievel"
```

* In Ruby, setter methods ending in `=` permit a special assignment-style calling syntax. Ruby's syntactic sugar makes calling `object.value = 3` equivalent to the conventional method calling syntax `object.value=(3)`. Semantically, both syntactic forms call the same method with the same argument

while i remember

* Ruby methods with names ending in `=` have a predetermined return value. Since the syntactic sugar is designed to make setter method calls mimic variable assignment, methods with names ending in `=` will always return the object passed as argument, in the same way real variable assignment would. If the setter method is defined to return something other than the argument, Ruby will ignore that attempt. Furthermore, methods with names ending in `=` must be defined with one parameter



**Intro to `attr_*` methods**



"Because [setter and getter] methods are so commonplace, Ruby has a built-in way to automatically create these getter and setter methods for us, using the `attr_accessor` method"

```ruby
class Cat
  attr_accessor :name # equivalent to the following:
  # def name
  #   @name
  # end
  # def name=(name)
  #   @name = name
  # end

  def initialize(name)
    @name = name
  end
end

tom = Cat.new("Tom")
puts tom.name # "Tom"
tom.name = "Jerry"
puts tom.name # "Jerry"
```

"The `attr_accessor` method takes a symbol as an argument [or multiple symbols], which it suses to create the method name for the getter and setter methods."

"But what if we only want the getter method without the setter method? .... etc"

* Since they are so commonplace in Ruby, simple getter and setter method definitions can be replaced by a call to the `attr_accessor` method. This method takes symbols as arguments and uses each symbol to create a setter and getter method of that name to set and reference a correspondingly-named instance variable
* If only a getter method is needed, we can use `attr_reader`. If we only need a setter method, `attr_writer`

We can create setters and getters for multiple attributes with a single call to one of these methods

```ruby
class Contestant
  attr_accessor :name, :age, :occupation
  # code omitted ...
end
```



**Accessor methods vs directly setting and referencing instance variables**

"With getter and setter methods, we have a way to expose and change an object's state. We can also use these methods from within the class as well."

* In addition to using them as a public interface to an object's state, we can use setter and getter methods to set and reference instance variables within the class as well

"Why do this? Why not just reference the... instance variable, like we did before? Technically, you could just reference the instance variable, but it's generally a good idea to call the *getter* method instead."

"Suppose we're keeping track of social security numbers in an instance variable called `@ssn`. And suppose that we don't want to expose the raw data, i.e. the entire social security number, in our application. Whenever we retrieve it, we want to only display the last 4 digits and mask the rest, like this: "xxx-xx-1234". If we were referencing th `@ssn` instance variable directly, we'd need to sprinkle our entire class with code like this:"

```ruby
# converts '123-45-6789' to 'xxx-xx-6789'
'xxx-xx-' + @ssn.split('-').last
```

"And what if we find a bug in this code, or if someone says we need to change the format to something else?"

* Using getter methods within the class means that we can process the value during its retrieval. This means any formatting or other manipulation of the data associated to the instance variable can be done in one place, the getter method, rather than in every place that the value is referenced.
* This means less repetitive code (DRY) and thus less chance of bugs. It also means that should the formatting or manipulation of the data need to be changed, the class definition can be changed in one place rather than many. Using getter methods instead of direct instance variable references within the class can therefore improve maintainability

* In order to call a setter method within the class, we must explicitly call it on the keyword `self` to disambiguate the expression from the initialization of a local variable.

```ruby
class Cat
  attr_accessor :name, :age, :weight
  def initialize(name, age, weight_in_kg)
    @name = name
    @age = age
    @weight = weight_in_kg
  end
  
  def update_info(new_age, new_weight)
    age = new_age # initializes local variable `age`
    weight = new_weight # initalizes local variable `weight`
    
    # to call the setter methods, we must do the following:
    self.age = new_age
    self.weight = new_weight
  end
end
```



* Generally, Rubyists avoid calling methods explicitly on `self` where it is not required. Setter methods called within the class are one of the situations that definitely require it. Making a call to `Kernel#class` on the current object is another, since this needs to be disambiguated from the keyword `class`.

## 1:4: Attributes ##

"As a general programming concept, we can think of attributes as the different characteristics that make up an object. For example, the attributes of a `Laptop` object might include: make, color, dimensions, display, processor, memory, storage, battery life, etc. Generally, these attributes can be accessed from outside the object. Also, when we talk about attributes, we might be referring to just the characteristic names, or the names *and* the values attributed to the object -- the meaning is typically clear from context"

"However, defining attributes in Ruby in this strict way (ie, instance variables with accessor methods) can lead to subtle complications. For example, is an attribute still an attribute if the accessor methods are private? What if there is a setter but no getter (or vice versa)? Lastly, what if there are no `attr_*` methods at all?"

"Due to these issues,you'll often find in our text (and external literature) that the term 'attributes' in Ruby is used quite loosely and is generally approximated as *instance variables*. Most of the time, these instance variables have accessor methods (because objects that are entirely secretive aren't very useful); however, it's not a must for the purposes of this defintion"

"So , **when we say that classes define the attributes of ... objects, we're referring to how classes specify the names of instance variables each object should have (ie, what the object should be made of)**. The **classes also define the accessor methods (and level of method access control); however, we're generally just pointing to the instance variables**. Similarly, **when we say state tracks attributes for individual objects, our purposes is to say that an object's state is composed of instance variables and their values; here we're not referring to the getters and setters**"













































