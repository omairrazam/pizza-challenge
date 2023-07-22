# frozen_string_literal: true

class Order < ApplicationRecord
  enum state: {
    open: 0,
    closed: 1,
    processing: 2,
  }

  has_many :items, dependent: :destroy
  has_many :promotions, dependent: :destroy
  has_many :discounts, dependent: :destroy

  validates :state, inclusion: { in: %w[open closed processing] }

  def calculate_total_price
    OrderPriceCalculator.new(self).execute
  end
end
