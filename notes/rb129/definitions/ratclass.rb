class Rat
  attr_reader :numerator, :denominator

  def initialize(numerator, denominator)
    numerator, denominator = normalize_negatives(numerator, denominator)
    @numerator, @denominator = lowest_terms(numerator, denominator)
  end

  def +(other)
    left_numerator, right_numerator, new_denominator = common_terms(other)
    new_numerator = left_numerator + right_numerator
    new_numerator, new_denominator = 
      lowest_terms(new_numerator, new_denominator)
    Rat.new(new_numerator, new_denominator)
  end

  def -(other)
    left_numerator, right_numerator, new_denominator = common_terms(other)
    new_numerator = left_numerator - right_numerator
    new_numerator, new_denominator =
      lowest_terms(new_numerator, new_denominator)
    Rat.new(new_numerator, new_denominator)
  end

  def *(other)
    new_numerator, new_denominator = 
      lowest_terms(numerator * other.numerator, denominator * other.denominator)
    Rat.new(new_numerator, new_denominator)
  end

  def /(other)
    self * Rat.new(other.denominator, other.numerator)
  end

  def **(exponent)
    if exponent.instance_of?(Float)
      return (numerator ** exponent).to_f / (denominator ** exponent).to_f
    elsif exponent.negative?
      numerator_rat = Rat.new(1, numerator ** -exponent)
      denominator_rat = Rat.new(1, denominator ** -exponent)
      return numerator_rat / denominator_rat
    end

    new_numerator, new_denominator =
      lowest_terms(numerator ** exponent, denominator ** exponent)
    Rat.new(new_numerator, new_denominator)
  end

  def -@
    @numerator = -@numerator
    self
  end

  def to_f
    numerator.fdiv(denominator)
  end

  def to_i
    to_f.to_i
  end

  def to_s
    "(#{numerator}/#{denominator})"
  end

  private

  def common_terms(other)
    left_numerator = numerator * other.denominator
    right_numerator = other.numerator * denominator
    new_denominator = denominator * other.denominator
    [left_numerator, right_numerator, new_denominator]
  end

  def lowest_terms(numerator, denominator)
    (denominator / 2).downto(2) do |divisor|
      if numerator % divisor == 0 && denominator % divisor == 0
        numerator /= divisor
        denominator /= divisor
        break
      end
    end
    [numerator, denominator]
  end

  def normalize_negatives(numerator, denominator)
    if (numerator.negative? && denominator.negative?) || denominator.negative?
      numerator = -numerator
      denominator = -denominator
    end
    [numerator, denominator]
  end
end

a = Rat.new(9, 25)
b = Rat.new(1, 5)
c = Rat.new(50, 250)
puts c