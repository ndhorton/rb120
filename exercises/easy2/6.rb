# Comparing Wallets

class Wallet
  include Comparable

  def initialize(amount)
    @amount = amount
  end

  def <=>(other_wallet)
    amount <=> other_wallet.amount
  end

  protected

  attr_reader :amount
end

bills_wallet = Wallet.new(500)
pennys_wallet = Wallet.new(465)
if bills_wallet > pennys_wallet
  puts 'Bill has more money than Penny'
elsif bills_wallet < pennys_wallet
  puts 'Penny has more money than Bill'
else
  puts 'Bill and Penny have the same amount of money.'
end

# Further exploration

# Perhaps password verification, where you don't want to publicly reveal
# either the stored password object's value or the user input value?

# Any application where we want to hide implementation details involving
# data that doesn't need to be publicly available
# This could involve specific network or database details, file handles,
# and so on