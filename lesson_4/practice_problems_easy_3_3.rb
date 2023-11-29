class AngryCat
  def initialize(age, name)
    @age = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "hisssss!!!"
  end
end

tom = AngryCat.new(11, 'tom')
whiskers = AngryCat.new(7, 'whiskers')

tom.age
tom.name

whiskers.age
whiskers.name
