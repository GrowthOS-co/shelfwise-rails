class Book < ApplicationRecord
  GENRES = %w[Fiction Mystery Science History].freeze

  validates :genre, inclusion: { in: GENRES }
  validates :price_cents, :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def in_stock?
    stock.positive?
  end
end
