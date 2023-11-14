# Fix the Program - Books (Part 2)

=begin

P:
rules:
  add setter methods for @title and @author
  add getter methods for @title and @author

=end

class Book
  attr_accessor :title, :author

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# Further exploration
# Separating the steps of creating the object and initializing its state
# could cause errors if an object is left with uninitalized values that
# other objects using its interface expect not to be `nil`. So if a method that operates
# on `Book` objects expects `Book#name` to return a String and instead receives a `nil`
# then this could lead to String methods being called on the `nil` object, which
# would raise an exception.