**<u>Method Access Control</u>**

**Definition**

* Access modifier methods `Module#public`, `Module#private` and `Module#protected` control levels of access to methods.
* Public methods are methods that are available to client code and can be called anywhere there is a reference to the object. Public methods form the interface of the class
* Private methods are methods that perform work within the class but which we do not want to be accessible to client code. Private methods can only be called within the class definition on the current object. Private methods are only accessible from other methods in the class
* Protected methods are similar to private methods in that they can only be invoked by other methods within the class. However, whereas private methods can only be called on the default object, we can call protected methods on other objects of the class, or a descendant class. So if another object of the same class is passed in to a public method of the class, we can call a protected method on it, as well as on the current object.

**Implementation**

* Methods are public by default, so the most common access modifiers are `private` and `protected`
* To declare methods `public`, `private` or `protected` we simply call e.g. `private` within a class definition and then any methods defined after it will be private methods until another access modifier method is called

**Benefits**

* Method access control facilitates encapsulation of functionality, permitting an object to have internal access to methods that do not form part of its public interface
* Method access control facilitates the separation of interface and implementation
* Method access control can also facilitate encapsulation of state with respect to setter and getter methods