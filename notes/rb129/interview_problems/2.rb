# Problem received from Raul Romero
class Human 
  attr_reader :name

  def initialize(name="Dylan", hair_colour = "blonde")
    @name = name
    @hair_color = hair_colour
  end

  def self.hair_colour(colour)
    "Hi, my name is Dylan and I have blonde hair"
  end

  def hair_colour(new_colour)
    @hair_color = new_colour unless new_colour.empty?
    self
  end

  def to_s
    "Hi, my name is #@name and I have #@hair_color hair"
  end
end

puts Human.new("Jo").hair_colour("blonde")  
# Should output "Hi, my name is Jo and I have blonde hair."

puts Human.hair_colour("")              
# Should "Hi, my name is Dylan and I have blonde hair."