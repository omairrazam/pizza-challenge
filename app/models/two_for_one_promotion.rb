# frozen_string_literal: true

class TwoForOnePromotion < ApplicationRecord
  PROMOTION_SIZE = 2

  def eligible?(item)
    item.name == target && item.size == target_size
  end

  def asc_sort_by_request_length(order)
    order.items.select{ |item| eligible?(item) }.sort_by{ |el| el.add_special_requests.length }
  end

  def calculate(order)
    matched_items_sorted = asc_sort_by_request_length(order)

    skips = (matched_items_sorted.length / PROMOTION_SIZE).floor

    matched_items_sorted[0..skips - 1].each do |item|
      item.skip_price = true
    end
  end
end
