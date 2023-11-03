class BigClass
  def self.class_method
    puts "I am a class method"
  end
end

class SmallClass < BigClass
end

class_little = SmallClass.new

SmallClass.class_method

