class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer # raises NoMethodError
tv.model        # bien

Television.manufacturer # bien
Television.model        # raises NoMethodError
