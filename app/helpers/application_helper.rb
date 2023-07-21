# frozen_string_literal: true

module ApplicationHelper
  def price_with_currency(price)
    price.presence && "#{price} €"
  end
end
