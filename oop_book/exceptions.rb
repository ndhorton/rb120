# from Zetcode II

x = 35
y = 0

begin
  z = x / y
  puts z
rescue => e
  puts e # calls `to_s`
  p e    # calls `inspect`
end
