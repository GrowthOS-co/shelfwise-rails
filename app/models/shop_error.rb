# Raised when a shop rule refuses a request, such as adding more copies of a
# book than are in stock. The message is written for the customer and is shown
# on the page they were on.
class ShopError < StandardError
  def self.out_of_stock(book)
    new("Only #{book.stock} left in stock of #{book.title}.")
  end
end
