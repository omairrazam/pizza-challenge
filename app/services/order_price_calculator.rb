# frozen_string_literal: true

class OrderPriceCalculator
  attr_reader :order

  delegate :promotions, :items, :discounts, to: :order

  def initialize(order)
    @order = order
  end

  def execute
    apply_promotions
    price = items.reject(&:skip_price).sum(&:final_price)
    apply_discounts(price)
  end

  private

  def apply_promotions
    return if promotions.joins(:calculator).blank?

    promotions.each(&:calculate)
  end

  def apply_discounts(price)
    return price if discounts.blank?

    discounted_price = discounts.select{ |discount| discount.deduction_in_percent.present? }.sum do |discount|
      discount_percent = discount.deduction_in_percent
      price * (1 - (discount_percent / 100.0))
    end

    discounted_price.round(2)
  end
end
