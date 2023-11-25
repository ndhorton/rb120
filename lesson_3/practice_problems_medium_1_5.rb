# class KrispyKreme
#   def initialize(filling_type, glazing)
#     if filling_type
#       @filling_type = filling_type
#     else
#       @filling_type = 'Plain'
#     end
#     @glazing = glazing
#   end

#   def to_s
#     message = @filling_type
#     message += " with #{@glazing}" if @glazing
#     message
#   end
# end

# LS solution
class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    filling_string = @filling_type ? @filling_type : "Plain"
    glazing_string = @glazing ? " with #{@glazing}" : ''
    filling_string + glazing_string
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
puts donut2
puts donut3
puts donut4
puts donut5
