# Pet = Struct.new('Pet', :kind, :name, :age)

# kitty = Pet.new('Cat', 'Kitty')

# whiskers = Pet.new
# p kitty
# p whiskers

Pet = Struct.new('Pet', :kind, :name, :age) do
  def to_s
    "I am a #{kind}. My name is #{name} and I am #{age} years old."
  end

  def speak
    "makes a sound"
  end
end

kitty = Pet.new('cat', 'Kitty', 4)

puts kitty
puts kitty.speak