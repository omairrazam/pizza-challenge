# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name{ "salami" }
    size{ "small" }
    price{ 6 }
    add_special_requests{ [] }
    remove_special_requests{ [] }
  end

  factory :item_margherita, parent: :item do
    name{ "margherita" }
    size{ "small" }
    price{ 5 }
    add_special_requests{ [] }
    remove_special_requests{ [] }
  end

  factory :item_margherita_special_large, parent: :item_margherita do
    size{ "large" }
    add_special_requests{ ["onions", "cheese", "olives"] }
  end

  factory :item_salami, parent: :item do
    name{ "salami" }
    size{ "small" }
    price{ 6 }
    add_special_requests{ [] }
    remove_special_requests{ [] }
  end

  factory :item_tonno, parent: :item do
    name{ "tonno" }
    size{ "small" }
    price{ 8 }
    add_special_requests{ [] }
    remove_special_requests{ [] }
  end

  factory :item_tonno_medium_special_remove, parent: :item_tonno do
    size{ "medium" }
    remove_special_requests{ ["onions", "olives"] }
  end
end
