# Bank Balance

require 'pry-byebug'

class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    potential_balance = balance - amount
    self.balance -= amount

    if balance == potential_balance
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def balance=(new_balance)
    @balance = new_balance if valid_transaction?(new_balance)
  end

  def valid_transaction?(new_balance)
    new_balance >= 0
  end
end

# The problem with my solution is that it lets you withdraw $0
# LS solution

class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    if amount > 0 && valid_transaction?(balance - amount)
      self.balance -= amount
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def balance=(new_balance)
    @balance = new_balance
  end

  def valid_transaction?(new_balance)
    new_balance >= 0
  end
end

# Example

account = BankAccount.new('5538898', 'Genevieve')

                          # Expected output:
p account.balance         # => 0
p account.deposit(50)     # => $50 deposited. Total balance is $50.
p account.balance         # => 50
p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
                          # Actual output: $80 withdrawn. Total balance is $50.
p account.balance         # => 50

# Further exploration

class Cat
  def name=(n)
    @name = n
    n << 'holemew'
  end

  def name
    @name
  end
end

bort = Cat.new
p bort.name = 'Bort'
p bort.name

# So even if you reassing the parameter local variable, the setter method will
# always return a reference to the original object. However, if you mutate
# the object, all references to it (the instance variable, the parameter local
# variable) will reflect that, since of course the object has been mutated in
# its space in memory and any reference to it will reflect that change.

# Basically this means setter methods in Ruby are hard-wired to return a
# reference to the argument object

# You also cannot have more than one parameter to a setter method.