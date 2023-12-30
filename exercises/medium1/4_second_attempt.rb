# Circular Buffer

class CircularBuffer
  attr_reader :buffer, :read_index, :write_index
  def initialize(size)
    @buffer = Array.new(size)
    @read_index = 0
    @write_index = 0
  end

  def put(value)
    @buffer[@write_index] = value
    @write_index = (@write_index + 1) % @buffer.size
  end

  def get
    value = @buffer[@read_index]
    @buffer[@read_index] = nil
    @read_index = (@read_index + 1) % @buffer.size if value
    value
  end
end

require 'pry-byebug'
buffer = CircularBuffer.new(3)
puts buffer.get == nil
# binding.pry
buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

buffer = CircularBuffer.new(4)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 4
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil