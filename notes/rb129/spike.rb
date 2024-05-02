=begin

# The following is a short description of an application that lets a customer place an order for a meal:

# - A meal always has three meal items: a burger, a side, and drink.
# - For each meal item, the customer must choose an option.
# - The application must compute the total cost of the order.

# 1. Identify the nouns and verbs we need in order to model our classes and methods.
# 2. Create an outline in code (a spike) of the structure of this application.
# 3. Place methods in the appropriate classes to correspond with various verbs.

Application

-compute total cost
-place_an_order

Customer

Order/Meal
  <has a
    Item

Item
  <is a
    Burger
    Side
    Drink


So syntax could look like

customer.place_order

customer.choose(Burger.new)

[Burger.new, Side.new, Drink.new].each { |item| choose(item) }

compute_total_cost(customer.order)

So Burger encapsulates options for burgers
Side options for sides
Drink options for drinks

Customer has an order has a burger, side, drink

When a Customer places order, we create an order
Should creating an order require choices for its items?

=end

class MealOrderApp # orchestration engine
  def take_orders
    loop do # order loop
      current_customer = Customer.new
      current_customer.place_order
      current_total = compute_total_cost(current_customer.order)
      break # if condition
    end
  end

  private

  def compute_total_cost(order)
  end
end

class Customer
  attr_reader :order

  def place_order
    @order = Order.new
  end
end

class Order
  attr_reader :burger, :side, :drink

  def initalize
    @burger = Burger.new
    @side = Side.new
    @drink = Drink.new
  end
end

class MealItem
  attr_reader :choice

  def initialize
    @choice = make_choice
  end

  def make_choice; end # overridden by subclasses
end

class Burger < MealItem
  def make_choice
  end
end

class Side < MealItem
  def make_choice
  end
end

class Drink < MealItem
  def make_choice
  end
end

MealOrderApp.new.take_orders