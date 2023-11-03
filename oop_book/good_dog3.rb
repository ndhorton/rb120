class GoodDog
  attr_accessor :name, :height, :weight

  puts self

  def initialize(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def change_info(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def what_is_self
    self
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall"
  end
end

sparky = GoodDog.new("Sparky", "12 inches", "10 lbs")
puts sparky.what_is_self