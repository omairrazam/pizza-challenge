# frozen_string_literal: true

class Item < ApplicationRecord
  serialize :add_special_requests, Array
  serialize :remove_special_requests, Array

  belongs_to :order

  SIZE_MULTIPLIERS = {
    small: 0.7,
    medium: 1,
    large: 1.3,
  }.freeze

  INGREDIENTS_MULTIPLIERS = {
    onions: 1,
    cheese: 2,
    olives: 2.5,
  }.freeze

  attr_accessor :skip_price

  def final_price
    ItemPriceCalculator.new(self).execute
  end
end
