class Array
  def my_each
    i = 0
    while i < size
      yield self[i]
      i += 1
    end
    self
  end
end

class Integer
  def my_times
    [*(0...self)].my_each { |num| yield num }
    self
  end
end

p 5.my_times { |i| puts "I'm on iteration #{i}!" }