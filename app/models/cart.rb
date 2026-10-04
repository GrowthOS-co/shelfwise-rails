# A browser's cart, found by the token in its cart_token cookie. A new cart is
# saved with its first book.
class Cart < ApplicationRecord
  has_many :items, -> { order(:id) }, class_name: "CartItem", inverse_of: :cart, dependent: :delete_all

  attribute :token, default: -> { SecureRandom.hex(16) }

  # Priced at each book's current price: a cart is not an order yet.
  def total_cents
    items.includes(:book).sum(&:amount_cents)
  end

  def book_count
    items.sum(:quantity)
  end

  def add(book, quantity)
    raise ShopError, "Quantity must be at least 1." unless quantity.positive?

    item = items.find_by(book:) || items.build(book:, quantity: 0)
    raise ShopError.out_of_stock(book) if item.quantity + quantity > book.stock

    item.update!(quantity: item.quantity + quantity)
  end
end
