# Fix the Program - Mailable

=begin

P:
  Fix the program

rules:
  Assume the Customer and Employee classes have complete
    implementations
  Make the smallest possible changed to ensure that objects of both types have
    access to the `#print_address` method

It's tempting to move the getter method definitions to the module
but the problem asks for the minimum possible changes
=end

module Mailable
  def print_address
    puts "#{name}"
    puts "#{address}"
    puts "#{city}, #{state} #{zipcode}"
  end
end

class Customer
  include Mailable

  attr_reader :name, :address, :city, :state, :zipcode
end

class Employee
  include Mailable

  attr_reader :name, :address, :city, :state, :zipcode
end

betty = Customer.new 
bob = Employee.new
betty.print_address
bob.print_address
