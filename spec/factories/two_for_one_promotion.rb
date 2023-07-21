FactoryBot.define do
  factory :two_for_one_promotion do
    sequence(:code) { |n| "PROMO#{n}" }
    target { "Dummy Target" }
    target_size { "small" }
    from { Time.current }
    to { 1.week.from_now }
    association :order
  end
end
