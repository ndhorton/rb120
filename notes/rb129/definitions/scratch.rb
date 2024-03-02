class Array
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_map
    result = []
    my_each { |element| result << yield(element) }
    result
  end
end

class Range
  def my_each
    i = min
    final_i = max
    while i <= final_i
      yield(i)
      i += 1
    end
    self
  end
end

class Integer
  def my_times
    (0...self).my_each { |i| yield(i) }
    self
  end
end

arr = [12, 13, 14, 15, 16, 17, 18, 19]
p arr.my_map { |num| num * num }

10.my_times { |i| p i }