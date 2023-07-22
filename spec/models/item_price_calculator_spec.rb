# frozen_string_literal: true

# spec/models/item_price_calculator_spec.rb
require "rails_helper"

RSpec.describe ItemPriceCalculator do
  let(:item){ Item.new(price: 5, size: "medium", add_special_requests: ["cheese", "olives"]) }
  subject{ described_class.new(item) }

  describe "#execute" do
    context "with valid item and special requests" do
      it "calculates the final price correctly" do
        # piza Margherita: 5
        # Price by size: 5 * 1 (medium multiplier) = 5
        # Ingredients price: (1 * 2) + (1 * 2.5) = 4.5
        # Final price: 5 + 4.5 = 9.5
        expect(subject.execute).to eq(9.5)
      end
    end
    context "with nil special requests" do
      before{ item.add_special_requests = nil }

      it "calculates the final price correctly" do
        expect(subject.execute).to eq(5)
      end
    end

    context "with empty special requests" do
      before{ item.add_special_requests = [] }
      it "calculates the final price correctly" do
        expect(subject.execute).to eq(5)
      end
    end

    context "with invalid size" do
      before{ item.size = "invalid_size" }

      it "raises an error" do
        expect{ subject.execute }.to raise_error(NoMethodError)
      end
    end
  end
end
