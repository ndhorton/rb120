# from Zetcode II

class BigValueError < StandardError ; end

LIMIT = 333
x = 3_432_453

begin

  if x > LIMIT
    raise BigValueError, "Exceeded the maximum value"
  end

  puts "Script continues"

rescue => e

  puts e
  p e
  exit 1

end
