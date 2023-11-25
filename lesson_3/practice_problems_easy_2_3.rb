module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

# To find a class's lookup path, you call the class method
# `::ancestors'. To do this on an object, you first call the
# instance method `class` and chain `ancestors` on the class
# object returned by `class`.

# The lookup chain for Orange is
# Orange
# Taste
# Object
# Kernel
# BasicObject

# The lookup chain for HotSauce is
# HotSauce
# Taste
# Object
# Kernel
# BasicObject