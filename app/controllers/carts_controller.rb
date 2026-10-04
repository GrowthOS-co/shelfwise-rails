class CartsController < ApplicationController
  before_action :set_item, only: %i[update remove]

  def show
    @items = current_cart.items.includes(:book)
  end

  def add
    book = Book.find(params.expect(:book_id))
    current_cart.add(book, quantity_param)
    cookies[:cart_token] = { value: current_cart.token, httponly: true, same_site: :lax, path: "/" }
    redirect_to cart_path
  rescue ShopError => error
    redirect_to book, alert: error.message
  end

  def update
    @item.change_quantity(quantity_param)
    redirect_to cart_path
  rescue ShopError => error
    redirect_to cart_path, alert: error.message
  end

  def remove
    @item.destroy!
    redirect_to cart_path
  end

  private
    def set_item
      @item = current_cart.items.find_by!(book_id: params.expect(:book_id))
    end
end
