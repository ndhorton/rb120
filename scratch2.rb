class NameChanger
  def initialize(lamb, name)
    @lamb = lamb
    @name = name
  end

  def change_name
    @lamb.call(@name)
  end
end

def change_name(lamb, new_name)
  NameChanger.new(lamb, new_name).change_name
end

bort = "Bort"

lamb = ->(name) do
  bort = name
end

puts bort

change_name(lamb, "Spoonio")

puts bort