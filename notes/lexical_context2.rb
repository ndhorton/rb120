# If the enclosing lexical scope and the inheritance hierarchy are searched
# and the constant is not found, the top-level will finally be searched
# for constants
TAU = 'a Greek letter'

class Outer
  TAU = Math::PI * 2
  class Inner
    class ClassA
      def show_tau
        # a call to Module::nesting shows the enclosing lexical scope
        puts "The enclosing lexical scope of the following reference is #{Module.nesting}"
        puts "Tau is #{TAU}"
      end
    end
  end
end

class Outer::Inner::ClassB
  # def self.const_missing(constant_symbol)
  #   constant_symbol
  # end

  def show_tau
    puts "The enclosing lexical scope of the following reference is #{Module.nesting}"
    puts "Tau is #{TAU}"
  end
end

object_a = Outer::Inner::ClassA.new
object_a.show_tau

object_b = Outer::Inner::ClassB.new
object_b.show_tau

# remember neither namespacing nor nesting is the same as inheritance
puts "ClassA inheritance hierarchy: #{Outer::Inner::ClassA.ancestors}"
puts "ClassB inheritance hiararchy: #{Outer::Inner::ClassB.ancestors}"
