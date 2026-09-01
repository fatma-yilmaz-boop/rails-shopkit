module Shopkit
  class Product < ApplicationRecord
    self.table_name = "shopkit_products"

    has_many :variants, dependent: :destroy
    has_many :line_items, through: :variants

    validates :title, presence: true
    validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

    scope :active, -> { where(status: :active) }
    scope :by_price, -> { order(price_cents: :asc) }

    enum :status, { draft: 0, active: 1, archived: 2 }

    def price
      price_cents / 100.0
    end

    def in_stock?
      variants.any?(&:in_stock?)
    end
  end
end
