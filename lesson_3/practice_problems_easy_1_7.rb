class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# `self`, here, is used inside an instance method and so refers to
# the instance that has called that method. It is used because the
# syntactic sugar around setter methods requires disambiguating
# the call to the setter method from an initialization of a new
# local variable.