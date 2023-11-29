# It is done by using the `self` keyword which will refer
# the instance that calls the `go_fast` method and then chaining a call
# to the instance method `#class` on the object identified by
# `self`, which returns the name of the class to which the
# instance belongs.

# LS solution
# Also mentions that the class object returned by `#class` is implicitly
# converted to a string because it is interpolated into a string,
# and so the `#to_s` method is called automatically to provide the
# actual string name of the instance of class Class.
