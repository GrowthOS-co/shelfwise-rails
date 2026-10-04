class Order < ApplicationRecord
  has_many :items, -> { order(:id) }, class_name: "OrderItem", inverse_of: :order

  enum :status, { placed: "placed", shipped: "shipped" }, default: :placed

  normalizes :customer_name, :email, :shipping_address, with: ->(value) { value.strip }

  validates :customer_name, :email, :shipping_address, presence: true

  before_create :assign_number

  # Priced at the prices copied when the order was placed.
  def total_cents
    items.to_a.sum(&:amount_cents)
  end

  def book_count
    items.to_a.sum(&:quantity)
  end

  # Turns the cart into this order, all or nothing: copies each book's title
  # and current price, takes the quantities out of stock and empties the cart.
  # Returns false when the customer's details are invalid.
  def place(cart)
    return false if invalid?

    transaction do
      lines = cart.items.includes(:book).to_a
      raise ShopError, "Your cart is empty." if lines.empty?

      lines.each do |line|
        raise ShopError.out_of_stock(line.book) if line.quantity > line.book.stock

        items.build(book: line.book, title: line.book.title, unit_price_cents: line.book.price_cents, quantity: line.quantity)
      end
      save!
      lines.each { |line| line.book.decrement!(:stock, line.quantity) }
      cart.items.delete_all
    end
    true
  end

  def mark_shipped!(at: Time.current)
    raise ShopError, "Order #{number} is #{status} and cannot be shipped." unless placed?

    update!(status: :shipped, shipped_at: at)
  end

  private
    def assign_number
      self.number = format("ORD-%04d", (Order.maximum(:id) || 0) + 1)
    end
end
