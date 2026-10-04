class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_cart

  private
    # This browser's cart; a new, unsaved cart until its first add to cart.
    def current_cart
      @current_cart ||= Cart.find_by(token: cookies[:cart_token]) || Cart.new
    end

    # The quantity fields are number inputs, so anything but a whole number is
    # a bad request.
    def quantity_param
      Integer(params.expect(:quantity), 10)
    rescue ArgumentError
      raise ActionController::BadRequest, "quantity must be a whole number"
    end
end
