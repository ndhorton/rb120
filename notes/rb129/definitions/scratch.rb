def foo()
  puts "Entering foo()"
  begin
    1 / 0
  rescue ZeroDivisionError => e
    puts "Inside rescue clause"
  ensure
    puts "Inside ensure clause"
  end
  puts "back in main flow of foo()"
end

puts "Calling foo()"
begin
  foo()
rescue ZeroDivisionError => e
  puts "back outside foo() in main rescue handler"
end
puts "back outside foo()"