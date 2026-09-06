# frozen_string_literal: true

module Shopkit
  # Represents a customer order with line items and state tracking.
  #
  # States: pending -> confirmed -> shipped -> delivered
  #                 -> cancelled
  #
  # @example
  #   order = Shopkit::Order.create!(customer_email: "user@example.com")
  #   order.add_item(variant, quantity: 2)
  #   order.confirm!
  #
  class Order < ApplicationRecord
    self.table_name = "shopkit_orders"

    has_many :line_items, class_name: "Shopkit::LineItem", dependent: :destroy
    has_many :variants, through: :line_items

    validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :status, inclusion: { in: %w[pending confirmed shipped delivered cancelled] }

    before_validation :set_defaults, on: :create

    scope :active, -> { where.not(status: "cancelled") }
    scope :recent, -> { order(created_at: :desc) }

    # Add a variant to this order.
    #
    # @param variant [Shopkit::Variant] the variant to add
    # @param quantity [Integer] number of units
    # @return [Shopkit::LineItem] the created line item
    def add_item(variant, quantity: 1)
      item = line_items.find_or_initialize_by(variant: variant)
      item.quantity = (item.quantity || 0) + quantity
      item.unit_price_cents = variant.price_cents
      item.save!
      recalculate_total!
      item
    end

    # Remove a variant from this order.
    def remove_item(variant)
      line_items.where(variant: variant).destroy_all
      recalculate_total!
    end

    # Total price in dollars.
    def total
      total_cents / 100.0
    end

    # Transition: pending -> confirmed
    def confirm!
      raise InvalidTransition, "Cannot confirm a #{status} order" unless status == "pending"
      update!(status: "confirmed", confirmed_at: Time.current)
    end

    # Transition: confirmed -> shipped
    def ship!
      raise InvalidTransition, "Cannot ship a #{status} order" unless status == "confirmed"
      update!(status: "shipped", shipped_at: Time.current)
    end

    # Transition: confirmed/pending -> cancelled
    def cancel!
      raise InvalidTransition, "Cannot cancel a #{status} order" unless %w[pending confirmed].include?(status)
      update!(status: "cancelled", cancelled_at: Time.current)
      restore_stock!
    end

    private

    def set_defaults
      self.status ||= "pending"
      self.total_cents ||= 0
    end

    def recalculate_total!
      new_total = line_items.sum { |li| li.unit_price_cents * li.quantity }
      update_column(:total_cents, new_total)
    end

    def restore_stock!
      line_items.includes(:variant).each do |li|
        li.variant.increment!(:stock, li.quantity)
      end
    end

    class InvalidTransition < StandardError; end
  end
end
