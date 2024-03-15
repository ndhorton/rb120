=begin
- Classes and objects
- States and behaviour
- Instance variables, class variables, and constants, including the scope of each type and how inheritance can affect that scope
- Different ways to create and call getter and setter methods
- Instance methods vs. class methods
- Method access control
- Class inheritance, encapsulation and polymorphism
  - what is encapsulation
    - sectioning off a unit of functionality in code/date in order to hide implementation details or expose 
      an interface through which the rest of the program interacts.
  - how can you achieve it?
    - Encapsulaiton in Ruby is achieved by defining classes and instantiating objects
    - Method Access Control
      - modifies methods through the use of public/private/protected keywords to expose or limit behaviors 
       within the class
       - private, calling object
       - protected, calling object and other objects passed as arguments to an instance method
       - public
- Modules and their use cases
  - mixin modules
  - namespacing
  - module as containers
- Method lookup path
- Method overriding
- self
- Fake operators and equality
  - == - object value equality, object id
  - equal? - object identity (object id)
  - eql? - same value, same class
- Collaborator objects

- inheritance, polymorphism, encapsulation, what the scope of these questions, and how much i should say
- code spike, time management for the assessment 

https://launchschool.com/lessons/3315a57a/assignments/5fe1a165
=end


# class Cat
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def change_name(new_name)
#     self.name = new_name
#   end

#   private

#   attr_writer :name
# end

# felix = Cat.new('felix')
# p felix.change_name("Felix")
# puts felix.name

# class Person
#   def initialize(height)
#     @height = height
#   end

#   def >(other)
#     height > other.height
#   end

#   protected

#   attr_reader :height
# end

class Event
  def initialize
    # @performers = 

  end

  def perform(performers)
    performers.each do |performer|
      p performer.perform
    end
  end
end

class Singer
  def perform
    "I am a singer, and I sing!"
  end
end

class Host
  def perform
    "I am a host, and I introduce everyone!"
  end
end


Event.new.perform([Singer.new, Host.new])