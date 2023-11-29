class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# 1) this outputs "Hello"

# 2) This will raise a NoMethodError

# 3) This will raise an ArgumentError

# 4) This will output "Goodbye"

# 5) This will raise a NameError (?) NO, a NoMethodError