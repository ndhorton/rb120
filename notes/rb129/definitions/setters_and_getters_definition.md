**<u>Accessor methods / getters and setters and `attr_*`</u>**

**Definition**

* Instance methods that reference or set a single instance variable are called getter and setter methods
* A getter method is an instance method that returns the reference of an instance variable and a getter method is a method that sets an instance variable
* An object's instance variables are only accessible to client code, if at all, through the public interface defined by the object's class. Client code has no way to access an object's instance variables without the object's class defining public getter and setter methods to reference and/or set those instance variables.
* In addition to using them as a public interface to an object's state, we can also use setter and getter methods to set and reference instance variables within the class
* The Ruby convention is to name getter and setter methods using the same name as the instance variable they reference or set

**Implementation**

* In Ruby, setter methods ending in `=` permit a special assignment-style calling syntax. Ruby's syntactic sugar makes calling `object.value = 3` equivalent to the conventional method calling syntax `object.value=(3)`. Semantically, both syntactic forms call the same method with the same argument
* Ruby methods with names ending in `=` have a predetermined return value. Since the syntactic sugar is designed to make setter method call syntax mimic variable assignment, methods with names ending in `=` will always return the object passed as argument, which mimics variable assignment semantics. If the setter method is defined to return something other than the argument, Ruby will ignore that attempt. (Additionally, methods with names ending in `=` must be defined with a single parameter)
* Since they are so commonplace in Ruby, simple getter and setter method definitions can be replaced by a call to the `attr_accessor` method. This method takes symbols as arguments and uses each symbol to create a setter and getter method of that name to set and reference a correspondingly-named instance variable
* If only a getter method is needed, we can use `attr_reader`. If we only need a setter method, `attr_writer`
* In order to call a setter method within the class, we must explicitly call it on the keyword `self` to disambiguate the expression from the initialization of a local variable.
* Generally, Rubyists avoid calling methods explicitly on `self` where it is not required. Setter methods called within the class are one of the situations that definitely require it. Making a call to `Kernel#class` on the current object is another, since this needs to be disambiguated from the keyword `class`.

**Benefits**

* Using getter methods within the class means that we can process the value during its retrieval. This means any formatting or other manipulation of the data associated to the instance variable can be done in one place, the getter method definition, rather than in every place that the value is referenced.
* This means less repetitive code (DRY) and thus less chance of bugs. It also means that should the formatting or manipulation of the data need to be changed, the class definition can be changed in one place rather than many. Using getter methods instead of direct instance variable references within the class can therefore improve maintainability
* The use of setter methods within the class has similar benefits. For instance, we might want to perform a check on the object passed as argument to the setter before assigning it to the instance variable. This check has only to be written in one place.























