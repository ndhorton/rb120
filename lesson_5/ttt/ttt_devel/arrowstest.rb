require 'io/console'
$stdin.echo = false
$stdin.raw!
begin
  loop do
    ch = $stdin.getc.chr
    begin
      if ch == "\e"
        ch << $stdin.read_nonblock(3)
        ch << $stdin.read_nonblock(2)
      elsif ch == 'q'
        break
      end
    rescue IO::EAGAINWaitReadable => e
      # doesn't seem to need handling
    end
    case ch
    when "\e[A"
      $stdin.cooked!
      $stdout.puts "up"
      $stdin.raw!
    when "\e[B"
      $stdin.cooked!
      $stdout.puts "down"
      $stdin.raw!
    when "\e[C"
      $stdin.cooked!
      $stdout.puts "right"
      $stdin.raw!
    when "\e[D"
      $stdin.cooked!
      $stdout.puts "left"
      $stdin.raw!
    end
  end
ensure
  $stdin.echo = true
  $stdin.cooked!
end