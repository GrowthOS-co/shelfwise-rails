# A book as it was sold: its title and price are copied when the order is
# placed, so later changes to the book do not change the order.
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :book

  def amount_cents
    quantity * unit_price_cents
  end
end
