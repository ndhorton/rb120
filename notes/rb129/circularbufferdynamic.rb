# class CircularBuffer
#   def initialize(sz)
#     @size = sz
#     @buffer = Array.new(sz)
#     @front = 0
#     @back = 0
#   end

#   def get
#     value = buffer[front]
#     buffer[front] = nil
#     increment_front
#     value
#   end

#   def put(value)
#     increment_front if buffer[back] # front of queue moves if we are
#                                     # overwriting oldest element
#     buffer[back] = value
#     increment_back
#     self
#   end

#   private

#   attr_reader :buffer, :size
#   attr_accessor :front, :back

#   def increment_front
#     return if buffer.all?(nil)
#     self.front = (front + 1) % size
#   end

#   def increment_back
#     return if buffer.all?(nil)
#     self.back = (back + 1) % size
#   end
# end

class CircularBuffer
  def initialize(sz)
    @size = sz
    @buffer = []
  end

  def put(value)
    buffer.shift if buffer.size == size
    buffer.push(value)
    self
  end

  def get
    buffer.shift
  end

  private

  attr_reader :size, :buffer
end

buffer = CircularBuffer.new(3)
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