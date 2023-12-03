Pet = Struct.new('Pet', :kind, :name, :age)
asta = Pet.new('dog', 'Asta', 10)
cocoa = Pet.new('cat', 'Cocoa', 2)
p asta.age
p asta[:age]
p asta['age']
p cocoa.age
cocoa.age = 3
p cocoa['age']
cocoa[:age] = 4
p cocoa.age

# So you have
# struct_var = Struct.new('SomeStruct', :attr)
# struct_var.attr / struct_var[:attr] / struct_var['attr']
# and
# struct_var.attr = val / struct_var[:attr] = val / struct_var['attr'] = val
