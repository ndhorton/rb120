class Foo
  def justice
    'justice' + all
  end

  def justice_for(other)
    'justice' + other.all
  end

  private

  def all
    'all'
  end
end

foo = Foo.new

p foo.justice
p foo.justice_for(foo)