TAU = 'a Greek letter'

module Outer
  TAU = Math::PI * 2
  module Inner
    # This module's lexical context includes the outer namespace modules
    # because that is how it is written in the text editor (and so
    # presumably that is how the Ruby lexer/parser or whatever sees the
    # the lexical context for constant lookup)
    module Grandson
      def show_tau
        puts TAU
      end
    end
  end
end

# Even though this module is namespaced equally deep with the same outer 
# modules, its lexical context (the surrounding text as it appears in the text
# editor) is only the module itself, its outer namespace modules do not
# lexically surround it, even if we need to reference Granddaughter through\
# their namespaces
module Outer::Inner::Granddaughter
  def show_tau
    puts TAU
  end
end

class ClassOne
  include Outer::Inner::Grandson
end

class ClassTwo
  include Outer::Inner::Granddaughter
end

thing1 = ClassOne.new
thing1.show_tau        # outputs the math constant (2 * pi)

thing2 = ClassTwo.new  # outputs 'a Greek letter'
thing2.show_tau