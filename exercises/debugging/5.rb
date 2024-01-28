# Files

# The `uninitialized constant` problem is related to the lexical scope
# of Ruby constants. Ruby searches the method lookup path to find the `to_s`
# method in the `File` parent class and executes the method. When the
# constant `FORMAT` is referenced in this `to_s` method, Ruby searches the
# immediate lexical scope of the parent class (and its parents, and toplevel)
# but does not search the child class which the method was called on.
# To rectify this, one could change `FORMAT` on line 29 to `self.class::FORMAT`.
# Since `self` still refers to the object on which the method was called,
# and the return value of `class` will be the class of that object,
# a dynamic way to reference the namespace of the class
# containing the appropriate `FORMAT` constant.

# The other troubling thing is that `File` is already a core class, so it
# seems as though we are monkey-patching the existing `File` class. But I
# don't think this is related to the `NameError` exception being raised.

class File
  attr_accessor :name, :byte_content

  def initialize(name)
    @name = name
  end

  alias_method :read,  :byte_content
  alias_method :write, :byte_content=

  def copy(target_file_name)
    target_file = self.class.new(target_file_name)
    target_file.write(read)

    target_file
  end

  def to_s
    "#{name}.#{self.class::FORMAT}"
  end
end

class MarkdownFile < File
  FORMAT = :md
end

class VectorGraphicsFile < File
  FORMAT = :svg
end

class MP3File < File
  FORMAT = :mp3
end

# Test

blog_post = MarkdownFile.new('Adventures_in_OOP_Land')
blog_post.write('Content will be added soon!'.bytes)

copy_of_blog_post = blog_post.copy('Same_Adventures_in_OOP_Land')

puts copy_of_blog_post.is_a? MarkdownFile     # true
puts copy_of_blog_post.read == blog_post.read # true

puts blog_post