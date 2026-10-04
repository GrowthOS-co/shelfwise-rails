require "test_helper"

class OrderTest < ActiveSupport::TestCase
  CUSTOMER = { customer_name: "Ben Turner", email: "ben.turner@example.com",
               shipping_address: "14 Elm Street\nSpringfield, IL 62704" }.freeze

  test "placing an order copies titles and prices, takes the stock and empties the cart" do
    lantern = create_book("Lantern", price_cents: 1699, stock: 12)
    locker = create_book("Locker", price_cents: 1399, stock: 15)
    cart = Cart.new
    cart.add(lantern, 2)
    cart.add(locker, 1)

    order = Order.new(CUSTOMER)
    assert order.place(cart)

    assert_equal [ [ "Lantern", 1699, 2 ], [ "Locker", 1399, 1 ] ],
                 order.reload.items.map { |item| [ item.title, item.unit_price_cents, item.quantity ] }
    assert_equal [ 10, 14 ], [ lantern.reload.stock, locker.reload.stock ]
    assert_empty cart.items.reload

    lantern.update!(price_cents: 9999)
    assert_equal 4797, order.reload.total_cents
  end

  test "placing an order with an empty cart raises and creates no order" do
    cart = Cart.create!

    error = assert_raises(ShopError) { Order.new(CUSTOMER).place(cart) }
    assert_equal "Your cart is empty.", error.message
    assert_equal 0, Order.count
  end

  private
    def create_book(title, price_cents:, stock:)
      Book.create!(title:, author: "Clara Whitlow", isbn: "isbn-#{title}", genre: "Fiction",
                   published_year: 2021, description: "", price_cents:, stock:)
    end
end
