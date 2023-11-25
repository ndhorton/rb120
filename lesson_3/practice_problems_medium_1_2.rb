class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
  end
end

# Line 11 seems to be intended to reassign
# the `@quantity` instance variable but there are two problems:
# 1) there is no setter method for `@quantity` and even if there
#      were, it would need to be called on `self`
# 2) you would therefore need to prepend `@` to `quantity`
# This can be fixed by either adding a setter method and prefixing
# `quantity` on line 11 with `self.` or simply prefixing `quantity`
# with `@`