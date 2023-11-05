# from Zetcode II

begin
  f = File.open("stones.txt", "r")

  while line = f.gets do
    puts line
  end

rescue => e
  puts e
  p e

ensure
  f.close if f
end