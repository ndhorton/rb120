## `self` ##

`self`

**Ruby OOP Book**

<u>calling methods with `self`</u>

"[When calling setter methods from within a class definition] To disambiguate from creating a local variable, we need to use `self.`... Note that prefixing `self.` is not restricted to just the accessor methods; you can use it with any instance method."



```ruby
class Cat
  attr_accessor :name
  
  def initialize(n)
    self.name = n # setter methods in the class must be called on self
  end
  
  def greeting
    "#{self.name} says meow!" # you can use it with getters too if you want
  end
  
  def speak
    puts self.greeting # self can be used with any method
  end
end

felix = Cat.new("Felix")
felix.speak # Felix says meow!
```





"The general rule from the Ruby style guide is to 'Avoid `self` where not required'"



* When called within a class definition within an instance method definition, setter methods must be called on `self` to disambiguate them from the initialization of local variables
* Any instance method within a class definition can be called on `self`. However, the Ruby style guide suggests not to use `self` when not needed



<u>**more** about `self`</u>

"`self` can refer to different things depending on where it is used"

* `self` refers to different things depending on where it is used

"Use `self` when calling setter methods from within the class... We had to use `self` to allow Ruby to disambiguate between initializing a local variable and calling a setter method"

"Use `self` for class method definitions"

* `self` can be used for class method definitions
* `self` within the class but outside of any method definition refers to the class

```ruby
class GoodDog
  attr_accessor :name, :height, :weight
  
  def intialize(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end
  
  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end
  
  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end
  
  def what_is_self # returns whatever self references within an instance method
    self
  end
end

sparky = GoodDog.new("Sparky", "12 inches", "10 lbs")
p sparky.what_is_self # <GoodDog [object id]: @name="Sparky", @height="12 inches", @weight="10 lbs">
```

"From within the class, when an instance method uses `self`, it references the *calling object*."

* From within the class definition within an instance method definition, `self` references the calling object

"The other place we use `self` is when we're defining class methods"

```ruby
class MyAwesomeClass
  def self.this_is_a_class_method
  end
end
```

"When `self` is prepended to a method definition, it is defining a class method."

* When `self` is prepended to the name of a method defined within a class, this is the beginning of a class method definition

```ruby
class GoodDog
  # code omitted for brevity
  puts self # outputs "GoodDog"
end
```

"Using `self` inside a class but outside an instance method refers to the class itself. Therefore, a method definition prefixed with `self` is the same as defining the method on the class. That is `def self.a_method` is equivalent to `def GoodDog.a_method`. Using `self.a_method` rather than `GoodDog.a_method` is a convention. It is useful because if in the future we rename the class, we only have to change the name of the class, rather than having to rename all of the class methods too"

* From within the class but outside any instance methods, `self` references the class



1. `self`, inside of an instance method, references the instance (object) that called the method - the calling object. 
2. `self`, outside of an instance method, references the class and can be used to define class methods.

"Thus, we can see that `self` is a way of being explicit about what our program is referencing and what our intentions are as far as behavior. `self` changes depending on the scope it is used in, so pay attention to see if you're inside an instance method or not."





* `self` is a keyword which dynamically references the current object.  `self` refers to different things depending on where it is used
* `self` within a class definition but outside of any method definition refers to the class
* From within the class definition and within an instance method definition, `self` references the calling object
* When called within a class definition within an instance method definition, setter methods must be called on `self` to disambiguate them from the initialization of local variables
* Any instance method within a class definition can be called on `self`. However, the Ruby style guide suggests not to use `self` when not needed
* `self` can be used for class method definitions. When `self` is prepended to the name of a method defined within a class, this is the beginning of a class method definition
