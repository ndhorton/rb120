class CircularBuffer
  def initialize(sz)
    @size = sz
    @buffer = Array.new(sz)
    @front = 0
    @back = 0
  end

  def get
    value = buffer[front]
    buffer[front] = nil
    increment_front unless value.nil?
    value
  end

  def put(value)
    increment_front unless buffer[back].nil? # front of queue moves if we are
                                             # overwriting oldest element,
                                             # nil is sentinel empty value
    buffer[back] = value
    increment_back
    self
  end

  private

  attr_reader :buffer, :size
  attr_accessor :front, :back

  def increment_front
    self.front = (front + 1) % size
  end

  def increment_back
    self.back = (back + 1) % size
  end
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