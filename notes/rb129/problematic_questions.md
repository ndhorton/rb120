q3 - I do not see a way to describe 'why' what is output in detail, and answer the two questions on top of it in much less than 15 minutes. The code is just too complicated and the constant-resolution question just requires so much detail in response (including stuff about namespaced constant resolution that is not mentioned in detail in the material)

q4 - again just a long and awkward question to answer. Can be done in around 10 minutes. Would be difficult to do in much less.

q12 - Definitely don't bother with this again

q14 - can be done in just over 10 minutes but finding it difficult

q19 - Took a long time to answer. I think the main problem here is that I don't have a good example ready to go.

q22 - Took a long time, need to practice. Use the car-engine example to demonstrate the functionality of the collaborator contributing to the functionality of the containing object

q26 - This shouldn't take that long. The points are

instance variables are scoped at the object level, and an instance variable once initialized is accessible by all the instance methods available to an object, whether the method is defined in the class of the object or in a class or module in the inheritance chain.

In Ruby, an instance variable is only created once an instance method that initializes it is actually called on the object. Again, this is true regardless of where in the method lookup path for the object a method is defined.

So although instance methods are inherited, and instance methods may initialize instance variables, instance variables themselves are not inherited directly from classes or mixin modules.

The methods available to an object from its method lookup path define only the set of potential instance variables that might be initialized in an object. The only instance variables initialized when the object is instantiated are those initialized by the constructor whether that constructor is inherited or not.

q30 -Took a long time to answer, probably because it asks for examples of when we would use method of all three types of access level, maybe should break up

q32- This is the question that someone said would take half an hour to answer, could try breaking it into three

q33 - General question on encapsulation. Need to practice this repeatedly, especially an example, since its such a general principle it's hard to even give a satisfying example.

q34 - took a long time to answer, very awkward, is it even asking for an explanation of how the classes work? Is the answer to the question just that `Person` and `Cat` don't have a logical superclass of which they are specialized types?

q35 - What is OOP? Remember that OOP is partly about allowing us to think at a greater level of abstraction

q36 - essentially:

classes as blueprints/templates. Classes determine behaviors and attributes

Behaviors are instance methods, attributes are potential instance variables

Classes group behaviors and objects encapsulate state

Creating an object from a class is called instantiation

q43 - took a long time

q47 - took a long time, probably a bad question tbh as it just takes a long time to describe all these classes. Maybe change to a less detailed approach?

q50 - took a very long time, not sure it's realistic to answer this question in under 10 minutes given how many types of variable and their scopes (and a quirky exception !) are involved.
