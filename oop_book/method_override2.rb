class Child
  def instance_of?
    p "I am a fake instance."
  end
end

heir = Child.new
heir.instance_of? Child