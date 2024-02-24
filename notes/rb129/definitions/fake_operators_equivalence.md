## Fake Operators and Equivalence ##

**<u>3: 2: Equivalence</u>**

"When we compare `str1` with `str2` using `==`, the string objects somehow know to compare their values, even though they're different objects. What we're asking is 'are the values within the two objects the same?' and *not* 'are the two objects the same'"

"But... suppose we care about whether the two variables actually point to the *same* object? That's where another method comes in: the `equal?` method"



* `==` is a fake operator (actually a method) conventionally defined to test for object-value equality between two different objects
* The value `==` compares is specific to the `==` method definition in the class of the calling object
* the `equal?` method is defined to test for object equality between two variables, essentially checking whether two variables point to the same object



```ruby
str1 = "something"
str2 = "something"
str1_copy = str1

# comparing the string object's values
str1 == str2 # true
str1 == str1_copy # true
str2 == str1_copy # true

# comparing the actual objects
str1.equal? str2 # false
str1.equal? str1_copy # true
str2.equal? str1_copy # false
```

"Notice that when we use `==` to compare the string object values, everything is `true`; all 3 variables have the value `"something"`. However, the story changes when we use the `equal?` method. Because the `equal?` method checks to see if the two objects are the same, only `str1.equal? str1_copy` returns `true`. This is because `str1` and `str1_copy` reference the same object, or space in memory.

