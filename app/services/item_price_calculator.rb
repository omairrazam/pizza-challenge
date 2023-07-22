# frozen_string_literal: true

class ItemPriceCalculator
  attr_reader :item

  delegate :price, :size, :add_special_requests, to: :item

  def initialize(item)
    @item = item
  end

  def execute
    final_price
  end

  private

  def validate_size!
    raise NoMethodError unless Item::SIZE_MULTIPLIERS.key?(size.to_sym)
  end

  def final_price
    validate_size!
    price_by_size.round(2) + ingredients_price.round(2)
  end

  def price_by_size
    size_multiplier = Item::SIZE_MULTIPLIERS[size.to_sym]
    price * size_multiplier
  end

  def ingredients_price
    add_special_requests.inject(0) do |sum, ingredient|
      sum + (Item::SIZE_MULTIPLIERS[size.to_sym] * Item::INGREDIENTS_MULTIPLIERS[ingredient.to_sym])
    end
  end
end
