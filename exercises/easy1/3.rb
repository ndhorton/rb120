class Book
  attr_reader :title, :author

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author})
puts %(book = #{book}.)

# Further exporation

# The `Module#attr_reader` method creates a getter method for the instance variable named by the Symbol passed as argument.
# `attr_accessor` creates both a getter and a setter method. Both of these will solve the above problem, but
# a setter method might not be desired, which makes `attr_reader` a less presumptuous choice. `attr_writer` only
# creates a setter method for the instance variables, and as such would not solve the above problem.

# The explicitly defined getter methods shown in the code will function exactly the same as those created by
# `attr_reader`. The advantage of the explicitly-defined methods would be less changes necessary if the value
# retrieved from the instance variable needed to be altered in any way before being returned. An example of this
# might be if part of the data needed to be conceiled from public access, e.g. a bank card number which needs
# to have most of its digits obfuscated from public view.
