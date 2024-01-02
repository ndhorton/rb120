# Stack Machine Interpretation

=begin

P:

Write a class that implements a miniature stack-and-register-based
programming language with the following commands:

n - place value n in register. do not modify stack
PUSH - push register value to the stack. leave value in register
ADD - pop value from stack and add to register value, store result in register
SUB - pop value from stack and subtract from register value
MULT - pop value from stack and multiply by register value
DIV - pop value from stack and divide into register value
MOD - pop value from stack, divide into register value, store remainder in reg
POP - remove topmost stack value and place in register
PRINT - print register value

rules:
  programs are strings passed to Minilang::new
  raise an exception if program contains unexpected token
    exception message: "Invalid token: " + the token in question
  raise exception if program requires stack value that is not present
    exception message: "Empty stack!"
  in above exceptions, simply print message and quit
  initialize register to 0
  the Minilang#eval method should execute the program

Etc:

Minilang
- initialize(program)
- eval

DS:
stack - array

A:

=end

# without #send
# class Minilang
#   INVALID_TOKEN_ERROR = "Invalid token: ".freeze
#   STACK_ERROR = "Empty stack!".freeze

#   def initialize(program)
#     @program = program
#     @register = 0
#     @stack = []
#   end

#   def eval
#     @program.split.each do |token|
#       if valid_integer?(token)
#         store(token)
#         next
#       end

#       interpret(token.upcase)
#     end
#   rescue StandardError => e
#     puts e.message
#     exit 1
#   end

#   private

#   def interpret(token)
#     case token
#     when 'ADD'                 then add
#     when 'SUB'                 then subtract
#     when 'MULT'                then multiply
#     when 'DIV'                 then divide
#     when 'MOD'                 then modulo
#     when 'PUSH'                then push
#     when 'POP'                 then pop
#     when 'PRINT'               then print
#     else
#       raise StandardError.new(INVALID_TOKEN_ERROR + token)
#     end
#   end

#   def add
#     raise StandardError.new(STACK_ERROR) if @stack.empty?
#     @register += @stack.pop
#   end

#   def subtract
#     raise StandardError.new(STACK_ERROR) if @stack.empty?
#     @register -= @stack.pop
#   end

#   def multiply
#     raise StandardError.new(STACK_ERROR) if @stack.empty?
#     @register *= @stack.pop
#   end

#   def divide
#     raise StandardError.new(STACK_ERROR) if @stack.empty?
#     @register /= @stack.pop
#   end

#   def modulo
#     raise StandardError.new(STACK_ERROR) if @stack.empty?
#     @register %= @stack.pop
#   end

#   def push
#     @stack << @register
#   end

#   def pop
#     raise StandardError.new(STACK_ERROR) if @stack.empty?
#     @register = @stack.pop
#   end

#   def print
#     puts @register
#   end

#   def valid_integer?(token)
#     token.to_i.to_s == token
#   end

#   def store(token)
#     @register = token.to_i
#   end
# end

# with #send

# class StackUnderflowError < StandardError; end
# class TokenError < StandardError; end

# class Minilang
#   TOKEN_TO_OPERATOR = {
#     'ADD' => :+,
#     'MULT' => :*,
#     'SUB' => :-,
#     'DIV' => :/,
#     'MOD' => :%
#   }.freeze

#   INVALID_TOKEN_ERROR = "Invalid token: ".freeze
#   STACK_ERROR = "Empty stack!".freeze

#   def initialize(program)
#     @program = program
#     @register = 0
#     @stack = []
#   end

#   def eval
#     @program.split.each do |token|
#       interpret(token.upcase)
#     end
#   rescue StandardError => e
#     puts e.message
#     exit 1
#   end

#   private

#   def binary_operation(token)
#     raise StackUnderflowError.new(STACK_ERROR) if @stack.empty?
#     @register = @register.send(TOKEN_TO_OPERATOR[token], @stack.pop)
#   end

#   def binary_operator?(token)
#     TOKEN_TO_OPERATOR.keys.include?(token)
#   end

#   def interpret(token)
#     if valid_integer?(token)      then store(token)
#     elsif binary_operator?(token) then binary_operation(token)  
#     elsif token == 'PUSH'         then push
#     elsif token == 'POP'          then pop
#     elsif token == 'PRINT'        then print
#     else
#       raise TokenError.new(INVALID_TOKEN_ERROR + token)
#     end
#   end

#   def pop
#     raise StackUnderflowError.new(STACK_ERROR) if @stack.empty?
#     @register = @stack.pop
#   end

#   def print
#     puts @register
#   end

#   def push
#     @stack << @register
#   end

#   def store(token)
#     @register = token.to_i
#   end

#   def valid_integer?(token)
#     token =~ /\A[+-]?\d+\z/
#   end
# end

# LS solution
# require 'set'

# class MinilangError < StandardError; end
# class BadTokenError < MinilangError; end
# class EmptyStackError < MinilangError; end

# class Minilang
#   ACTIONS = Set.new %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

#   def initialize(program)
#     @program = program
#   end

#   def eval
#     @stack = []
#     @register = 0
#     @program.split.each { |token| eval_token(token) }
#   rescue MinilangError => error
#     puts error.message
#   end

#   private

#   def eval_token(token)
#     if ACTIONS.include?(token)
#       send(token.downcase)
#     elsif token =~ /\A[-+]?\d+\z/
#       @register = token.to_i
#     else
#       raise BadTokenError, "Invalid Token: #{token}"
#     end
#   end

#   def push
#     @stack.push(@register)
#   end

#   def pop
#     raise EmptyStackError, "Empty stack!" if @stack.empty?
#     @register = @stack.pop
#   end

#   def add
#     @register += pop
#   end

#   def sub
#     @register -= pop
#   end

#   def div
#     @register /= pop
#   end

#   def mod
#     @register %= pop
#   end

#   def mult
#     @register *= pop
#   end

#   def sub
#     @register -= pop
#   end

#   def print
#     puts @register
#   end
# end

# Further exploration 1 & 2

require 'set'

class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Minilang
  ACTIONS = Set.new %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(program)
    @program = program
  end

  def eval(**variable_hash)
    @stack = []
    @register = 0
    modified_program = format(@program, variable_hash)
    modified_program.split.each { |token| eval_token(token) }
  rescue MinilangError => error
    puts error.message
  end

  private

  def eval_token(token)
    if ACTIONS.include?(token)
      send(token.downcase)
    elsif token =~ /\A[-+]?\d+\z/
      @register = token.to_i
    else
      raise BadTokenError, "Invalid Token: #{token}"
    end
  end

  def push
    @stack.push(@register)
  end

  def pop
    @register = safe_pop
  end

  def safe_pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @stack.pop
  end

  def add
    @register += safe_pop
  end

  def sub
    @register -= safe_pop
  end

  def div
    @register /= safe_pop
  end

  def mod
    @register %= safe_pop
  end

  def mult
    @register *= safe_pop
  end

  def sub
    @register -= safe_pop
  end

  def print
    puts @register
  end
end


# Minilang.new('PRINT').eval
# # 0

# Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

# Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

# Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

# Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

# Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

# Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

# Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)

# CENTIGRADE_TO_FAHRENHEIT =
#   '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 100)).eval
# # 212
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 0)).eval
# # 32
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: -40)).eval
# # -40

CENTIGRADE_TO_FAHRENHEIT =
  "5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT"
# minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
# minilang.eval(degrees_c: 100)
# # 212
# minilang.eval(degrees_c: 0)
# # 32
# minilang.eval(degrees_c: -40)
# # -40

FAHRENHEIT_TO_CENTIGRADE = 
  '9 PUSH 32 PUSH %<degrees_f>d SUB PUSH 5 MULT DIV PRINT'

# fahrenheit_to_centigrade = Minilang.new(FAHRENHEIT_TO_CENTIGRADE)
# fahrenheit_to_centigrade.eval(degrees_f: 100)

MPH_TO_KPH = "3 PUSH %<mph>d PUSH 5 MULT DIV PRINT"
# mph_to_kph = Minilang.new(MPH_TO_KPH)
# mph_to_kph.eval(mph: 100)

RECTANGLE_AREA =
  '%<side_a>d PUSH %<side_b>d MULT PRINT'

rectangle_area_formula = Minilang.new(RECTANGLE_AREA)
rectangle_area_formula.eval(side_a: 5, side_b: 4)
