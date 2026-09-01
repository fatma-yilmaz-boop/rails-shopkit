module Shopkit
  class Cart
    attr_reader :items, :customer

    def initialize(customer: nil)
      @customer = customer
      @items = []
    end

    def add_item(variant, quantity: 1)
      existing = @items.find { |i| i[:variant].id == variant.id }
      if existing
        existing[:quantity] += quantity
      else
        @items << { variant: variant, quantity: quantity }
      end
      self
    end

    def remove_item(variant_id)
      @items.reject! { |i| i[:variant].id == variant_id }
      self
    end

    def total_cents
      @items.sum { |i| i[:variant].price_cents * i[:quantity] }
    end

    def total
      total_cents / 100.0
    end

    def item_count
      @items.sum { |i| i[:quantity] }
    end

    def empty?
      @items.empty?
    end
  end
end
