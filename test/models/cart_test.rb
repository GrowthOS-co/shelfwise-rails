require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "total is quantity times each book's current price" do
    cart = Cart.new
    cart.add(create_book("Lantern", price_cents: 1699, stock: 10), 2)
    cart.add(create_book("Locker", price_cents: 1399, stock: 10), 1)

    assert_equal 4797, cart.total_cents
  end

  test "adding more than the stock raises and leaves the cart unchanged" do
    book = create_book("Fern Hollow", price_cents: 1299, stock: 2)
    cart = Cart.new
    cart.add(book, 2)

    error = assert_raises(ShopError) { cart.add(book, 1) }
    assert_equal "Only 2 left in stock of Fern Hollow.", error.message
    assert_equal 2, cart.items.find_by!(book:).quantity
  end

  private
    def create_book(title, price_cents:, stock:)
      Book.create!(title:, author: "Clara Whitlow", isbn: "isbn-#{title}", genre: "Fiction",
                   published_year: 2021, description: "", price_cents:, stock:)
    end
end
