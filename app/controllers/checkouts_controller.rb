class CheckoutsController < ApplicationController
  def show
    return redirect_to cart_path if current_cart.items.empty?

    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.place(current_cart)
      redirect_to @order
    else
      render :show, status: :unprocessable_entity
    end
  rescue ShopError => error
    flash.now[:alert] = error.message
    render :show, status: :unprocessable_entity
  end

  private
    def order_params
      params.expect(order: [ :customer_name, :email, :shipping_address ])
    end
end
