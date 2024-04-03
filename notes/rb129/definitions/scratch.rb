class Pet
  attr_reader :appointments_history

  def initialize
    @appointments_history = []
  end
end

class Cat < Pet
  def initialize(name)
    super() # need to avoid passing `name` through to superclass method
    @name = name
  end
end

fluffy = Cat.new("Fluffy")
p fluffy.appointments_history # []
p fluffy # <Cat:0x... @name="Fluffy", @appointments_history=[]>