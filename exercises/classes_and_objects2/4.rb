class Cat
  def self.generic_greeting
    puts "Hello! I am a cat!"
  end

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def personal_greeting
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting