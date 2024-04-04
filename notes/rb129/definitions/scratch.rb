class Person
  def name=(new_name)
    @first_name, @last_name = new_name.split
  end

  def name
    "#@first_name #@last_name".strip
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name.inspect # "John Doe"
p person1 # <Person:0x... @first_name="John", @last_name="Doe"

person2 = Person.new
person2.name = "Fred"
p person2
p person2.name