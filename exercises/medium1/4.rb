# Circular Buffer

=begin

P:

Implement a circular buffer that satisfies the given use cases.

rules:
  Buffer#put adds an object to the buffer
  Buffer#get removes and returns the oldest object in the buffer
  nil will never be a value but can be used to designate empty slot in buffer
  fixed size is given in argument to constructor


What do we know?
The first element will be index 0 for reading and writing


Etc:

_ _ _
1 _ _ put
1 2 _ ""
1 2 3 ...
4 2 3
4 5 3
4 5 3 get

so you could start with
write_index = 0
read_index = 0

DS:

A:

subprocess CircularBuffer#put
given an object, value
if write index > buffer size - 1
  write index = 0
if buffer[write index] exists
  read index = write index + 1
buffer[write index] = value
write index = write index + 1

subprocess CircularBuffer#get
if read index > buffer size - 1
  read index = 0
return buffer[read index]

=end

BufferSlot = Struct.new('BufferSlot', :value, :place)

class CircularBuffer
  def initialize(size)
    @place = 0
    @buffer = Array.new(size) do
      @place += 1
      BufferSlot.new(nil, @place)
    end
    @write_index = 0
  end

  def put(value)
    self.place += 1
    buffer[write_index].value = value
    buffer[write_index].place = place
    self.write_index = (write_index + 1) % buffer.size
  end

  def get
    full_slots = buffer.select { |slot| slot.value != nil }
    return nil if full_slots.empty?
    oldest = full_slots.min_by(&:place)
    value = oldest.value

    oldest.value = nil
    self.place += 1
    oldest.place = place
    
    value
  end

  private

  attr_accessor :write_index, :place
  attr_reader :buffer
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
