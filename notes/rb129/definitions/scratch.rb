class Cat
  attr_reader :name

  def initialize
    @name = NAMES.sample
  end

  NAMES = ['Felix', 'Heathcliff', 'Sylvester'].freeze

  def change_name
    new_name = name
    while new_name == name
      new_name = NAMES.sample
    end
    @name = new_name
  end
end
