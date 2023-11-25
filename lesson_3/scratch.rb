class SpoonException < Exception
  def say_spoon
    puts "spoon"
  end
end

begin
  raise SpoonException if 'spoon' == 'spoon'
rescue SpoonException => spoon
  spoon.say_spoon
end