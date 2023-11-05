class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  # def ==(other)
    # name == other.name
  # end

  private

  def parse_full_name(full_name)
    names = full_name.split
    @first_name = names.first
    @last_name = names.size > 1 ? names.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

# p bob == rob

p bob.name == rob.name