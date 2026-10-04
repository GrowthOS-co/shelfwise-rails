class OrdersController < ApplicationController
  before_action :set_order, only: %i[show ship]

  # A page opened before the order was shipped can still post "Mark as shipped".
  rescue_from ShopError do |error|
    redirect_to @order, alert: error.message
  end

  def index
    @orders = Order.includes(:items).order(created_at: :desc, id: :desc)
  end

  def show
  end

  def ship
    @order.mark_shipped!
    redirect_to @order
  end

  private
    def set_order
      @order = Order.find(params.expect(:id))
    end
end
