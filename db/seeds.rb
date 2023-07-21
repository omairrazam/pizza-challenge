# frozen_string_literal: true

# db/seeds.rb
require "json"

data = Rails.root.join("db/data/orders.json").read

orders_data = JSON.parse(data)

orders_data.each do |order_data|
  ActiveRecord::Base.transaction do
    order = Order.find_or_create_by!(
     id: order_data["id"],
     state: order_data["state"].downcase,
     created_at: order_data["createdAt"],
    )

    order.items.delete_all if order.items.present?
    order_data["items"].each do |item_data|

      order.items.create!(
       name: item_data["name"],
       size: item_data["size"].downcase,
       price: item_data["price"],
       add_special_requests: item_data["add"].map(&:downcase),
       remove_special_requests: item_data["remove"].map(&:downcase)
      )
    end

    order_data["promotionCodes"].each do |promotion_code|
      next if promotion_code.blank?

      promotion_calculator = TwoForOnePromotion.create!(
       code: promotion_code,
       target: order_data["promotions"][promotion_code]["target"],
       target_size: order_data["promotions"][promotion_code]["target_size"].downcase,
       from: order_data["promotions"][promotion_code]["from"],
       to: order_data["promotions"][promotion_code]["to"],
       order_id: order.id
      )

      promotion = order.promotions.find_or_create_by!(name: promotion_code)

      calculator = Calculator.create!(
       promotion_id: promotion.id,
       calculatable_id: promotion_calculator.id,
       calculatable_type: promotion_calculator.class
      )

    end

    if order_data["discountCode"].present?
      discount = order.discounts.find_or_initialize_by(name: order_data["discountCode"])
      discount.deduction_in_percent = order_data["discounts"][order_data["discountCode"]]["deduction_in_percent"]
      discount.save!
    end

    Rails.logger.debug { "Success: Loaded order #{order.id}" }
  end
# rescue StandardError
  Rails.logger.debug { "Error: Loading order #{order_data["id"]}" }
end
