# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    state{ "open" }
    created_at{ Time.current }
  end

  factory :order_with_items, parent: :order do
    after(:create) do |order, _evaluator|
      create(:item_margherita, order: order)
      create(:item_salami, order: order)
      create(:item_tonno, order: order)
    end
  end

  factory :order_with_special_items, parent: :order do
    after(:create) do |order, _evaluator|
      create(:item_margherita_special_large, order: order)
      create(:item_tonno_medium_special_remove, order: order)
      create(:item_margherita, order: order)
    end
  end

  factory :order_with_promotion_discount, parent: :order do
    transient do
      order_data do
        {
          "state" => "open",
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

    after(:create) do |order, evaluator|
      order_data = evaluator.order_data
      order.items.delete_all if order.items.present?

      order_data["items"]&.each do |item_data|
        order.items.create!(
          name: item_data["name"],
          size: item_data["size"]&.downcase,
          price: item_data["price"],
          add_special_requests: item_data["add"]&.map(&:downcase),
          remove_special_requests: item_data["remove"]&.map(&:downcase),
        )
      end

      order_data["promotionCodes"]&.each do |promotion_code|
        next if promotion_code.blank?

        target = order_data["promotions"][promotion_code]["target"]
        target_size = order_data["promotions"][promotion_code]["target_size"]&.downcase
        from = order_data["promotions"][promotion_code]["from"]
        to = order_data["promotions"][promotion_code]["to"]

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
