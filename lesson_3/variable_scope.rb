class Computer
  GREETINGS = ["Beep", "Boop"]
end

class Person
  def self.greetings
    Computer::GREETINGS.join(', ')
  end

  def greet
    Computer::GREETINGS.sample
  end
end

puts Person.greetings
puts Person.new.greet
