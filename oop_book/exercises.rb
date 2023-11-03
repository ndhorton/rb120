# 1)
class Thing
end

thing = Thing.new
# 2)
# Modules can implement polymorphism in Ruby; a module is a collection of behaviours that can be reusably added
# to multiple classes.
module Speak
  def speak
    puts "I am the Thing"
  end
end

class Thing
  include Speak
end

thing = Thing.new
thing.speak