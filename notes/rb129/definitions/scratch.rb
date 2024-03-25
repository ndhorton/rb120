module Mod
  alias :orig_exit :exit
  def exit(code=0)
    puts "Exiting with #{code}"
    orig_exit(code)
  end
end

include Mod
exit(99)