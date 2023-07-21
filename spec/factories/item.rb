# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name{ "Dummy Item" }
    size{ "small" }
    price{ 10.0 }
    add_special_requests{ [] }
    remove_special_requests{ [] }
  end
end
