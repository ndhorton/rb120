class Person
  attr_reader :first_name
  attr_accessor :last_name

  def initialize(first_name = '', last_name = '')
    @first_name = first_name
    @last_name = last_name
  end

  def name
    if first_name.empty? && !last_name.empty?
      last_name
    elsif !first_name.empty? && last_name.empty?
      first_name
    elsif first_name.empty? && last_name.empty?
      first_name + last_name
    else
      "#{first_name} #{last_name}"
    end
  end
end

# LS solution
class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parts = full_name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : ''
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end

bob = Person.new('Robert')
p bob.name
p bob.first_name
p bob.last_name
bob.last_name = 'Smith'
p bob.name