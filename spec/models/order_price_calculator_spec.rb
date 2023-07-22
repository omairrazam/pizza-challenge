# frozen_string_literal: true

# spec/models/order_price_calculator_spec.rb
require "rails_helper"

RSpec.describe OrderPriceCalculator do
  describe "#execute" do
    context "for order with promotions and discounts" do
      order = FactoryBot.create(:order_with_promotion_discount)
      subject{ described_class.new(order) }

      it "applies TwoForOnePromotion correctly to eligible items and applies discount as well" do
        expect(subject.execute).to eq(16.29)
      end
    end

    context "for order without promotions and discounts" do
      order = FactoryBot.create(:order_with_items)
      subject{ described_class.new(order) }

      it "gives accurate price" do
        # 0.7(5+6+8) = 13.3
        expect(subject.execute).to eq(13.3)
      end
    end

    context "for order with special requests" do
      order = FactoryBot.create(:order_with_special_items)
      subject{ described_class.new(order) }

      it "gives accurate price" do
        expect(subject.execute).to eq(25.15)
      end
    end
  end
end
