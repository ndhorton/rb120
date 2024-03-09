class Parent
  def to_s
    "foo"
  end
end

class Child < Parent
  def to_s
    42
  end
end

c = Child.new
puts c.class.superclass
puts c.to_s
puts c

p = Parent.new
puts p
