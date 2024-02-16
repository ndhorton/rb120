class NamedRegexp
  attr_reader :expression, :name
  
  def initialize(expression, name)
    @expression = expression
    @name = name
  end

  def ===(str)
    expression === str
  end
end

rgx = NamedRegexp.new(/f.*/, 'bob')

case 'fish'
when /b.*/ then puts "starts with a b"
when /c.*/ then puts "starts with a c"
when rgx   then puts "starts with a #{rgx.name}"
else
  puts "It's all gone wrong"
end