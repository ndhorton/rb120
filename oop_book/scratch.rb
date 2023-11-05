class Some
  attr_accessor :field

  def get_field
    field
  end

  def set_field(field)
    self.field=(field)
  end
end

obj = Some.new

obj.field = 'spoon'
obj.set_field 'moon'
p obj.field