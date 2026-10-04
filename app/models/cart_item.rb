class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :book

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def amount_cents
    quantity * book.price_cents
  end

  # A quantity of 0 removes the line.
  def change_quantity(quantity)
    raise ShopError, "Quantity cannot be negative." if quantity.negative?
    return destroy! if quantity.zero?
    raise ShopError.out_of_stock(book) if quantity > book.stock

    update!(quantity:)
  end
end
