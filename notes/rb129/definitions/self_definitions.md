**<u>`self`</u>**

**Definition**

* `self` is a keyword which dynamically references the current object.  `self` refers to different things depending on where it is used
* `self` within a class definition but outside of any method definition refers to the class
* From within the class definition and within an instance method definition, `self` references the calling instance (object)
* Method calls

**Implementation**

* Prior to Ruby 2.7, private instance methods could not be called on `self` with the sole exception of setter methods. Now all private instance methods can be called on `self`
* Any instance method can be called on `self`. However, the Ruby style guide suggests not to use `self` when not needed
* When called within an instance method definition, setter methods must be called on `self` to disambiguate them from the initialization of local variables
* `self` can be used for class method definitions. When `self` is prepended to the name of a method defined within a class, this is the beginning of a class method definition
* the construction `self.class::` can be used to dynamically reference constants defined in the class of the calling object rather than constants defined in the class where the method is defined

**Benefits**

* Allows setters to be called within the class definition
* Facilitates class method definitions
* Allows dynamic constant reference within instance methods inherited by subclasses

