# Pet Shelter

=begin

P:

Write the classes and methods that make the test cases produce
the example output

rules:
  the order of the output does not matter, only the information presented

Etc:

output:

P Hanson has adopted the following pets:
a cat named Butterscotch
a cat named Pudding
a bearded dragon named Darwin

B Holmes has adopted the following pets:
a dog named Molly
a parakeet named Sweetie Pie
a dog named Kennedy
a fish named Chester

P Hanson has 3 adopted pets.
B Holmes has 4 adopted pets.

A:

Pet animals need an init method that stores two string arguments
Owener objects need to store one string argument on init
Shelter needs to store nothin on init

Shelter needs a method `#adopt` that takes an Owner object arg, and a Pet object arg

Owner object needs instance method called `#number_of_oets`

=end

# Modified my solution after seeing LS implementation
# My original had an @adoptions hash storing a copy of the owner's list of pets as value
class Pet
  attr_reader :name, :animal

  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{animal} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end
end

class Shelter
  attr_reader :unadopted_pets

  def initialize
    @owners = {}
    @unadopted_pets = {}
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    owners[owner.name] ||= owner
  end

  def print_adoptions
    owners.each do |name, owner|
      puts "#{name} has adopted the following pets:"
      puts owner.pets
      puts
    end
  end

  def print_unadopted
    puts "The Animal Shelter has the following unadopted pets:"
    puts unadopted_pets.values
    puts
  end

  def add_unadopted_pet(pet)
    @unadopted_pets[pet.name] = pet
  end

  def number_of_unadopted
    unadopted_pets.size
  end

  private
  attr_accessor :owners
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.add_unadopted_pet Pet.new('dog', 'Asta')
shelter.add_unadopted_pet Pet.new('dog', 'Laddie')
shelter.add_unadopted_pet Pet.new('cat', 'Fluffy')
shelter.add_unadopted_pet Pet.new('cat', 'Kat')
shelter.add_unadopted_pet Pet.new('cat', 'Ben')
shelter.add_unadopted_pet Pet.new('parakeet', 'Chatterbox')
shelter.add_unadopted_pet Pet.new('parakeet', 'Bluebell')

shelter.print_adoptions
shelter.print_unadopted

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal shelter has #{shelter.number_of_unadopted} unadopted pets."