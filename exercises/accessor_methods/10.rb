class Person
  def name=(name)
    names = name.split
    @first_name = names.first
    @last_name = names.size > 1 ? names.last : ''
  end

  def name
    "#{@first_name} #{@last_name}".rstrip
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
