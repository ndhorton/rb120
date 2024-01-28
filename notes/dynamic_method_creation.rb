# class Thing
# end

# thing1 = Thing.new
# def thing1.spoon
#   puts "Spoon!"
# end

# thing1.spoon

# # thing2 = Thing.new
# # thing2.spoon # raises a NoMethodError - defining a method on an instance of a
#              # class does not make that method available to other instances

# thing2 = thing1.clone # this does copy the new method to a new instance
# thing2.spoon          # (though `#dup` does not)

class Thing
  def fork
    puts "Fork!"
  end
end

thing1 = Thing.new

class Thing
  def spoon
    puts "Spoon!"
  end
end

thing1.fork
thing1.spoon # This does work! monkey-patching a class after an object
             # has been instantiated from it makes the method available to
             # the existing instance, which complicates any static metaphor
             # for what a class is (e.g. a blueprint or mold) since the
             # behavior available to the instance of a class is updated
             # dynamically
