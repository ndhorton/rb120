class AnimalClass
  attr_accessor :name, :animals
  
  def initialize(name, animals = [])
    @name = name
    @animals = animals
  end
  
  def <<(animal)
    animals << animal
  end
  
  def +(other_class)
    AnimalClass.new("temporary name", animals + other_class.animals)
  end
end

class Animal
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

mammals = AnimalClass.new('Mammals')
mammals << Animal.new('Human')
mammals << Animal.new('Dog')
mammals << Animal.new('Cat')

birds = AnimalClass.new('Birds')
birds << Animal.new('Eagle')
birds << Animal.new('Blue Jay')
birds << Animal.new('Penguin')

some_animal_classes = mammals + birds

p some_animal_classes 