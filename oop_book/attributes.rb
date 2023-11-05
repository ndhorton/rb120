class Laptop
  def initialize(memory)
    @memory = memory
  end

  def memory
    @memory
  end

  def memory=(memory)
    @memory = memory
  end
end

laptop = Laptop.new('8GB')
p laptop.memory
laptop.memory = '16GB'
p laptop.memory