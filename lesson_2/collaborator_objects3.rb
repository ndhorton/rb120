class Person
  attr_accessor :name, :pet

  def initialize(name)
    @name = name
    @pets = []
  end
end

bob = Person.new("Robert")

kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud

bob.pets # => [#<Cat:0x007fd839999620>, #<Bulldog:0x007fd839994ff8>]

bob.pets.each { |pet| pet.jump }
