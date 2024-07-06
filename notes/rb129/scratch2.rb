module Barrable
  def bar
    @bar
  end

  def bar=(b)
    @bar = b
  end
end

class Foo
  include Barrable
end

foo = Foo.new
foo.bar = 'baz'
puts foo.bar