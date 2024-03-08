=begin
DISCLAIMER: I am not a TA, just a student like you.

Introductions: Name
               Location in world
               Location in course
               What do you want to cover today?
                - written
                - definition of collaborator objects and high level concepts
                - practice explanation
                - duck typing vs other types of polymorphism

Study Guide:

Classes and objects
States and behaviour
Instance variables, class variables, and constants, including the scope of each type and how inheritance can affect that scope
Different ways to create and call getter and setter methods
Instance methods vs. class methods
Method access control
Class inheritance, encapsulation and polymorphism
Modules and their use cases
Method lookup path
Method overriding
self
Fake operators and equality
Collaborator objects

=end

# class Shelf
#   def books
#     @objects ||= []
#   end

#   def add_book(book)
#     books << book
#   end
# end

# class Book
#   def initialize(title, author)
#     @title = title
#     @author = author
#   end

#   def to_s
#     "'#@title', by #@author"
#   end

#   def open
#   end
# end

# class Cabinet
#   def open
#   end
# end

# [Cabinet.new, Book.new].each do |obj|
#   obj.open
# end


# shelf = Bookshelf.new
# shelf.add_book(Book.new("The Trial", "Franz Kafka"))
# puts shelf.books
# puts shelf.inspect

##

# class Employee
#   def charge_for_product(item)
#     item.price
#   end
# end

# module Barcoded
#   def price
#     'scan barcode'
#   end
# end

# module Stickered
#   def price
#     'read sticker'
#   end
# end

# class Book
#   include Barcoded
# end

# class ClearanceBook < Book
#   # some other difference
# end

# class BoxedGift
#   include Barcoded
# end

# class GreetingCard
#   include Stickered
# end

# # duck typing for this one
# class GiftCertificate
#   def price
#     'manually input amount of certificate'
#   end
# end

# class Teacher
#   # attr_reader :name, :subject
#   # attr_writer :subject

#   def initialize(name, subject)
#     self.name = name
#     self.subject = subject
#   end

#   # private

#   # attr_writer :name

# end

# p teacher1 = Teacher.new("Nick", "Math")
# p teacher1
# # p teacher1.subject
# # teacher1.subject = "English"
# # p teacher1.subject
# # teacher1.name = "fred"
# # p teacher1.name

# class Protector
#   def self.method_1
#   end

#   def self.method_2
#   end
# end


# def calculate_age
#   method_1()
#   method_2()
#   return something
# end

# Paco's kid's spike

# There is a vehicle company called Cool Car Factory

# There are 3 trucks and two cars there.

# A blue garbage truck has orange wheels and picks up garbage

# An orange recycling truck has blue wheels and picks up recycling

# A purple car called Do Not Touch Anything Dirty has black wheels and if it touches something dirty says "hey don't touch any dirty stuff!"

# a green race car that races and has black wheels

# A red firetruck with black wheels that puts out fires

# All truck/car's of these types would have these same attributes and you can pass only one argument on instantiation

# all trucks can carry heavy stuff

# all cars and the firetruck can go fast

# all vehicles can drive

# calling puts on an object of any class should return a sentence describing that object

=begin
Truck, Car, Vehicle, firetruck, garbage truck
overall color, wheel color, pick up garbage, pick up recycling, touch dirty thing, race, carry heavy stuff, go fast, drive, to_s description
cars can called things (name?)

# Nouns
# Car, Super is Auto
#   has a body color, wheel color, type
#   drives
#   goes fast
#   can make a statement
# Truck, Super is Auto
#   has a body color, wheel color, type
#   drives
#   carries heavy stuff, firetrucks can go fast
# Company Collaborator Autos
#   holds vehicles
#   has a name




=end

info = {
  wheel_color: "purple",
  body_color: "yellow"
}


module Fastable
  def go_fast
    "can go fast"
  end
end


class CarCompany

end

class Autos
  def initialize(info)
    @wheel_color = info[:wheel_color]
    @body_color = info[:body_color]
  end
end

class Trucks < Autos
  def initialize(info)
  
  end
end

class Cars < Autos
  def initialize()
end