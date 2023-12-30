# Students

class Student
  def initialize(name, year)
    @name = name
    @year = year
  end

  def display_info
    puts "#{@name} enrolled in #{year}"
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year) # 1
    @parking = parking # 2
  end

  def display_info(graduation_year)
    super()
    puts "#{name} graduated in #{graduation_year}"
  end
end

class Undergraduate < Student
  def initialize(name, year)
    super # 3
  end
end

