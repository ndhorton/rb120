GREETINGS = ["Hi, I am Shakespeare"]

module ElizabethanEra
  GREETINGS = ['How doest thou', 'Bless thee', 'Good morrow']

  class Person
    def self.greetings
      GREETINGS.join(', ')
    end

    def greet
      GREETINGS.sample
    end
  end
end

class ElizabethanEra::Playwright
  def self.greet
    GREETINGS.sample
  end
end

puts ElizabethanEra::Person.greetings
puts ElizabethanEra::Person.new.greet
puts ElizabethanEra::Playwright.greet