# Pet = Struct.new('Pet', :kind, :name, :age)

# (almost) equivalent to

# class Pet
#   attr_accessor :kind, :name, :age

#   def initialize(kind, name, age)
#     @kind = kind
#     @name = name
#     @age = age
#   end
# end

# (almost because see below for the extra hash-like syntax available
# for getting and setting)

# So you have
# struct_var = Struct.new('SomeStruct', :attr)
# struct_var.attr / struct_var[:attr] / struct_var['attr']
# and
# struct_var.attr = val / struct_var[:attr] = val / struct_var['attr'] = val

# Struct objects respond to regular getter and setter method syntax
# but also to hash-like syntax; however, unline for hashes, you can
# treat symbols and strings as interchangeable as Struct 'keys'

# cat = Cat.new
# cat.name = "Bort"
# p cat.class
# p cat.name
# p cat['name']
# p cat[:name]
# p cat.meow

# An important thing to note about Structs is that their implicit
# initilaize method will have optional positional parameters
# with default values of `nil`

# So the following is more actually equivalent to the struct
# with the exception that any classes derived from this class
# definition will inherit the non-optional parameters #intiailze 
# method (unlike with a struct)
# class Pet
#   def initialize(kind = nil, name = nil, age = nil)
#     @internal_hash = {
#       kind: kind,
#       name: name,
#       age: age
#     }
#   end

#   def [](key)
#     if key == :kind || key == :name || key ==  :age
#       @internal_hash[key]
#     elsif key == 'kind' || key == 'name' || key == 'age'
#       @internal_hash[key.to_sym]
#     else
#       raise NameError, "no member '#{key}' in struct"
#     end
#   end

#   def []=(key, value)
#     if key == :kind || key == :name || key ==  :age
#       @internal_hash[key] = value
#     elsif key == 'kind' || key == 'name' || key == 'age'
#       @internal_hash[key.to_sym] = value
#     else
#       raise NameError.new("no member '#{key}' in struct")
#     end
#   end

#   def kind
#     @internal_hash[:kind]
#   end

#   def kind=(kind)
#     @internal_hash[:kind] = kind
#   end

#   def name
#     @internal_hash[:name]
#   end

#   def name=(name)
#     @internal_hash[:name] = name
#   end

#   def age
#     @internal_hash[:age]
#   end

#   def age=(age)
#     @internal_hash[:age] = age
#   end
# end

# Pet = Struct.new('Pet', :kind, :name, :age)

# asta = Pet.new('dog', 'Asta', 10)
# cocoa = Pet.new('cat', 'Cocoa', 2)

# p asta.age
# p asta[:age]
# p asta['age']
# p cocoa.age
# cocoa.age = 3
# p cocoa['age']
# cocoa[:age] = 4
# p cocoa.age

# kitty = Pet.new
# p kitty.name

# So here it was 52 lines to write a class functionally-
# equivalent to a 1-line Struct definition

# However, there is more complex stuff when declaring a struct.
# You can actually define behaviours on the Struct::Pet struct
# by passing a block when you define the Struct.

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
