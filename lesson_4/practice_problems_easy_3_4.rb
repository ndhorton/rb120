class Cat
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{type} cat"
  end

  def display_type
    puts "I am a #{type} cat"
  end
end

cat = Cat.new("persian")
puts cat
cat.display_type
