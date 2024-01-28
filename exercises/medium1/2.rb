# Fixed Array

=begin

P:

Write a class that implements a fixed-length array, and provides the
necessary methods to support the following code.

rules:
  You can pass in first-position argument to specify how big the array should be
    when calling the `FixedArray::new` method.
  You can reference an element with `[]` subscript notation and an index
  You can assign an element with `[]=` method
  If you try to assign an element past the fixed size, it raises an IndexError
  If you try to reference an element past the fixed size, it raises an 
    IndexError
  Both of the above are true for negative indexes
  You can call a `to_a` method to convert a FixedArray to a regular Array
  You can call a `to_s` method

Etc:
given

to_s method format looks to be calling to_s on the internal array

if you have -1 as an index, it basically means Array#size - 1
so do that and just work with non-negative indexes for the bounds check

DS:
Use an array and do your own bounds-checking to prevent it growing etc

subprocess FixedArray#[]
given an integer, index
if absolute value of index > size || (index is non-negative && index > size - 1)
  raise an IndexError

if index < 0
  index = size - index

if index >= 0 && index <= size of internal array - 1
  return the element at that index
else
  raise an IndexError

subprocess FixedArray#[]=
subprocess FixedArray#to_a
subprocess FixedArray#to_s

=end

# class FixedArray
#   attr_reader :size

#   def initialize(size)
#     @size = size
#     @internal_array = Array.new(size)
#   end

#   def [](index)
#     if index.abs > size || index > size - 1
#       raise IndexError
#     end
  
#     internal_array[index]
#   end

#   def []=(index, element)
#     if index.abs > size || index > size - 1
#       raise IndexError
#     end
  
#     internal_array[index] = element
#   end

#   def to_a
#     internal_array.dup
#   end

#   def to_s
#     internal_array.to_s
#   end

#   private

#   attr_reader :internal_array
# end


# LS solution
class FixedArray
  def initialize(max_size)
    @array = Array.new(max_size)
  end

  def [](index)
    @array.fetch(index)
  end

  def []=(index, value)
    self[index] # calling above method to use Array#fetch for bounds checking
    @array[index] = value
  end

  def to_a
    @array.clone
  end

  def to_s
    to_a.to_s
  end
end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end