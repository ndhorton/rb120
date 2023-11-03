class Person
  def initialize(age)
    @age = age
  end

  def older?(other_person)
    age > other_person.age
  end

  protected

  attr_reader :age
end

class SmolPerson < Person
end

malory = Person.new(64)
sterling = Person.new(42)

p malory.older?(sterling) # true
p sterling.older?(malory) # false

malory.age # error