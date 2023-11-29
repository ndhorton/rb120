class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

trip = RoadTrip.new
puts trip.predict_the_future

# This code will call the `#predict_the_future` method inherited
# from `Oracle`, which in turn will call the `RoadTrip#choices` method
# and that will return a string chosen at random from the array therein.

# So this code will return e.g. "You will fy to Fiji"
