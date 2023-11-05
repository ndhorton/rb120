# from Zetcode II

class Wood

  def self.info
    "This is a Wood class"
  end

end

class Brick

  class << self
    def info
      "This is a Brick class"
    end
  end

end

class Rock

  def Rock.info
    "This is a Rock class"
  end

end

p Wood.info
p Brick.info
p Rock.info