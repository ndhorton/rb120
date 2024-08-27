module MyInterface
  def foo
    raise "Not implemented"
  end

  def bar
    raise "Not implemented"
  end
end

class MyClass
  include MyInterface

  def foo
    puts "foo to you"
  end

  def bar
    puts "bar to you"
  end
end

a = MyClass.new
a.foo
a.bar