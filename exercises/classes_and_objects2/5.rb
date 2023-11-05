class Cat
  @@total_number_of_cats = 0

  def self.total
    puts @@total_number_of_cats
  end

  def initialize
    @@total_number_of_cats += 1
  end
end

kitty1 = Cat.new
kitty2 = Cat.new

Cat.total