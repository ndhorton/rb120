=begin

### reschool (by Natalie Thompson)

Inside a preschool 
there are children, 

teachers, class assistants, a principle, janitors, and cafeteria workers. 

Both teachers and assistants can help a student with schoolwork and watch them on the playground.
A teacher teaches and an assistant helps kids with any bathroom emergencies. 

Kids themselves can learn and play. 

A teacher and principle can supervise a class.
Only the principle has the ability to expel a kid.

Janitors have the ability to clean.
Cafeteria workers have the ability to serve food.

Children, teachers, class assistants, principles, janitors and cafeteria workers all have the ability to eat lunch.

preschool

child
-learn
-play

teacher
-supervise_class
-teach
assistant
-take_to_bathroom(child)

teaching_staff (teacher, assistant)
-help_with_schoolwork(child)
-watch_on_playground(child)


principal
-expel(child)
-supervise_class

janitor
-clean
cafeteria worker
-serve_food

-eat_lunch (all person classes)

=end

module Lunchable
  def eat_lunch
  end
end

module Supervisable
  def supervise_class
  end
end

class Child
  include Lunchable

  def learn
  end

  def play
  end
end

class Principal
  include Supervisable
  include Lunchable

  def expel(child)
  end
end

class TeachingStaff
  include Lunchable
  
  def help_with_schoolwork(child)
  end

  def watch_on_playground(child)
  end
end

class Teacher < TeachingStaff
  include Supervisable

  def teach
  end
end

class Assistant < TeachingStaff
  def take_to_bathroom(child)
  end
end

class CafeteriaWorker
  include Lunchable

  def serve_food(person)
  end
end

class Janitor
  include Lunchable

  def clean
  end
end

class Preschool
  def initialize
    @principal = Principal.new
    @children = Array.new(50) { Child.new }
    @teachers = Array.new(3) { Teacher.new }
    @assistants = Array.new(5) { Assistant.new }
    @cafeteria_workers = Array.new(3) { CafeteriaWorker.new }
    @janitors = Array.new(2) { Janitor.new }
  end
end

Preschool.new

# 18m25s