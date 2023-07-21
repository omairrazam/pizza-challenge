# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    transient do
      order_data do
        {
          "state" => "OPEN",
          "createdAt" => "2021-04-14T14:08:47Z",
          "items" => [
            {
              "name" => "Salami",
              "size" => "Medium",
              "price" => "6",
              "add" => ["Onions"],
              "remove" => ["Cheese"],
            },
            {
              "name" => "Salami",
              "size" => "Small",
              "price" => "6",
              "add" => [],
              "remove" => [],
            },
            {
              "name" => "Salami",
              "size" => "Small",
              "price" => "6",
              "add" => [],
              "remove" => [],
            },
            {
              "name" => "Salami",
              "size" => "Small",
              "price" => "6",
              "add" => [],
              "remove" => [],
            },
            {
              "name" => "Salami",
              "size" => "Small",
              "price" => "6",
              "add" => ["Olives"],
              "remove" => [],
            },
          ],
          "promotionCodes" => ["2FOR1"],
          "promotions" => {
            "2FOR1" => {
              "target" => "Salami",
              "target_size" => "Small",
              "from" => 2,
              "to" => 1,
            },
          },
          "discountCode" => "SAVE5",
          "discounts" => {
            "SAVE5" => {
              "deduction_in_percent" => 5,
            },
          },
        }
      end
    end

    sequence(:id){ |n| "f40d59d0-48ad-409a-ac7b-54a1b47f668#{n}" }
    state{ "open" }
    created_at{ Time.current }

    after(:create) do |order, evaluator|
      order_data = evaluator.order_data
      order.items.delete_all if order.items.present?

      order_data["items"]&.each do |item_data|
        order.items.create!(
          name: item_data["name"] || "Dummy Item",
          size: item_data["size"]&.downcase || "small",
          price: item_data["price"] || 10.0,
          add_special_requests: item_data["add"]&.map(&:downcase) || [],
          remove_special_requests: item_data["remove"]&.map(&:downcase) || [],
        )
      end

      order_data["promotionCodes"]&.each do |promotion_code|
        next if promotion_code.blank?

        target = order_data["promotions"][promotion_code]["target"] || "Dummy Target"
        target_size = order_data["promotions"][promotion_code]["target_size"]&.downcase || "small"
        from = order_data["promotions"][promotion_code]["from"] || Time.current
        to = order_data["promotions"][promotion_code]["to"] || 1.week.from_now
        promotion_calculator = FactoryBot.create(:two_for_one_promotion,
                                                 code: promotion_code,
                                                 target: target,
                                                 target_size: target_size,
                                                 from: from,
                                                 to: to,
                                                 order: order,)

        promotion = order.promotions.find_or_create_by!(name: promotion_code)
        FactoryBot.create(:calculator, promotion: promotion, calculatable: promotion_calculator)
      end

      if order_data["discountCode"].present?
        discount = order.discounts.find_or_initialize_by(name: order_data["discountCode"])
        deduction_percent = order_data["discounts"][order_data["discountCode"]]["deduction_in_percent"] || 10
        discount.deduction_in_percent = deduction_percent
        discount.save!
      end
    end
  end
end
