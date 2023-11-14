# Fix the Program - Flight Data

# The initialize method is dependent on a specific `Database` class interface. (It could be
# less likely to lead to problems if a database handle is passed in from the caller?)
# The `@database_handle` instance variable is able to be reassigned using a public method. This
# might cause problems. The entire `@database_handle` value can also be accessed by a public getter method.
# This might be a security concern?

# If you decide not to use a Database at all, you would need to change the class or it would
# raise an exception as soon as you create an object of class Flight.

# LS solution

# The database handle is almost certainly an implementation detail and therefore should not
# be exposed as part of the public interface. Users have no need of implementation details
# so they should not be exposed. Therefore we should delete the accessor methods for `@database_handle`

class Flight
#  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# If the implementation detail is exposed, other classes may be written in a way that is dependent on it
# and it may therefore be too difficult to remove if we later wanted to change the Flight class's implementation.
