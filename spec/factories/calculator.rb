# frozen_string_literal: true

FactoryBot.define do
  factory :calculator do
    association :promotion
    association :calculatable, factory: :two_for_one_promotion
  end
end
