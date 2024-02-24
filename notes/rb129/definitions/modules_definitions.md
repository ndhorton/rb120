**<u>Modules and their use cases</u>**

**Definition**

* Modules allow us to group together a logical set of behaviors, classes, or other modules, depending on how we intend to use the module
* Mixin modules can be used to apply polymorphic structure to programs by grouping behaviors that are then mixed in to multiple classes. This is sometimes called interface inheritance
* Modules can be used for namespacing to group similar classes or other modules under a namespace
* Modules can be used as a container for methods defined on the module itself. Such methods are sometimes called **module methods** and are called directly on the module using the dot operator
* Unlike classes, modules cannot be instantiated

**Implementation**

* Mixin modules can be used for interface inheritance. Class inheritance models an "is a " relationship; the type of the subclass is specialized with respect to the type of the superclass. Interface inheritance through mixin modules models a "has a " relationship; the class has a behavior or ability provided by the module. The class is not a specialization of the module
* Modules containing instance method definitions can be mixed in to one or more classes. This use of a module is known as a **mixin**. Once mixed in to a class, the behaviors contained in the module are available to the class and its descendants
* If there's an "is-a" relationship, class inheritance is usually the correct choice. If there's a "has-a" relationship, interface inheritance is generally a better choice. For example, a dog "is an" animal and "has an" ability to swim
* Mixin modules are mixed in to a class using the `Module#include` method invocation at the class level

* To instantiate a class that is in the namespace of a module, we use the `::` namespace resolution operator after the module name and append the name of the class: `ModuleName::ClassName.new`

**Benefits**

* While class inheritance is good for modeling naturally hierarchical relationships, mixin modules can provide polymorphic structure when there are behaviors that need to be shared among classes that cannot be related hierarchically
* Even when classes can be related in terms of a hierarchy, there may be some behavior that needs to be shared by classes that already subclass as part of the hierarchy but whose superclasses have descendants that should not share that behavior. In this situation, a mixin module can be used to distribute shared behavior on a class-by-class basis. Ruby only allows single inheritance; a class can only have one superclass. However, Ruby permits a class to mix in an arbitrary number of mixin modules, providing the benefits of multiple inheritance with less logical complexity
* Namespacing prevents name collisions in large software projects
* Container modules for module methods provide a way to group methods that do not logically belong in any particular class
