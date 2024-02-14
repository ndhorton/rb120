# private methods

class Customer
  attr_reader :name

  def initialize(name, bank_card_number)
    @name = name
    @bank_card_number = bank_card_number
  end

  def card_details
    "xxxx-xxxx-xxxx-#{bank_card_number[-4..-1]}"
  end

  private

  attr_reader :bank_card_number
end

fred = Customer.new("Fred Williams", "8927-2983-2352-3927")
puts "Customer name: #{fred.name}"
puts "Current payment method: #{fred.card_details}"

# protected methods

class Employee
  attr_reader :name

  def initialize(name, salary)
    @name = name
    @salary = salary
  end

  def better_paid?(other_employee)
    salary > other_employee.salary
  end

  protected

  attr_reader :salary
end

fred = Employee.new("Fred", 50000)
barnie = Employee.new("Barnie", 60000)

if fred.better_paid?(barnie)
  puts "#{fred.name} is earning more than #{barnie.name}"
else
  puts "#{barnie.name} is earning more than #{fred.name}"
end

# instance variables

class HotelCustomer
  attr_reader :name, :room_number

  def initialize(name, room_number)
    @name = name
    @room_number = room_number
  end

  def change_room(new_room_number)
    @room_number = new_room_number
  end

  def display_details
    puts "#{@name} is staying in room #{@room_number}."
  end
end

customer = HotelCustomer.new("Fred Williams", 13)
customer.display_details
customer.change_room(15)
customer.display_details
