class A
  def initialize
    self.class.value += 1
  end

  class << self
    def value
      @value ||= 0
    end

    def value=(value)
      @value = value
    end
  end
end

class B < A; end

10.times { A.new }
16.times { B.new }

puts A.value
puts B.value