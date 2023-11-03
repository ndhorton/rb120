class Parent
  def say_hi
    p "Hi from Parent."
  end
end

class Child < Parent
  def say_hi
    p "Hi from Child."
  end

end

child = Child.new
child.send(:say_hi)
p child.instance_of? Child
p child.instance_of? Parent
