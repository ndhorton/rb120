# from Zetcode II

class Wood

  def info
    "This is a wood object"
  end

end

wood = Wood.new
p wood.info

class Brick

  attr_accessor :info

end

brick = Brick.new
brick.info = "This is a brick object"
p brick.info

class Rock

end

rock = Rock.new
def rock.info
  "This is a rock object"
end

p rock.info