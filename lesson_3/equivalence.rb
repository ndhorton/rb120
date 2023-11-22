num = 25

case num
when 1..50
  puts "small number"
when 51..100
  puts "large number"
else
  puts "Not in range"
end

if (1..50) === num
  puts "smol number"
elsif (51..100) === num
  puts "big num"
else
  puts "no bueno"
end