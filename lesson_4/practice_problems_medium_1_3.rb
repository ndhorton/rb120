class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end

# If you simply change `attr_reader` to `attr_accessor` on line 2
# then you will also add a setter method for `@product_name`,
# which might be undesirable.

# LS solution

# You also would currently be making the setter method available
# to clients of the class, since there is currently no `private`
# method call before the proposed change.

# This is especially important since the role of the `update_quantity`
# method is to perform checks on the value passed to it and only if
# it passes those check reassign the value to `@quantity`; having
# a publicly-available setter for `@quantity` that does not perform
# those checks is therefore almost certainly problematic