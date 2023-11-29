class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

oracle = Oracle.new
p oracle.predict_the_future

# This code will return a string with "You will " followed by
# a random sample from the array of strings returned by the `Oracle#choices`
# method, e.g "You will eat a nice lunch"
