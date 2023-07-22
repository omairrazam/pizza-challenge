# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Orders", type: :system do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  context "On orders listing page ensure" do
    it "should display all required fields" do
      order = FactoryBot.create(:order_with_promotion_discount)
      visit "/orders"
      expect(page).to have_content("ID: #{order.id}")
      expect(page).to have_content("Created: #{order.created_at.strftime("%Y-%m-%d %H:%M:%S")}")
      expect(page).to have_content("Total Price: #{order.calculate_total_price}")

      order.items.each do |item|
        expect(page).to have_content(item.name.to_s)
        expect(page).to have_content(item.size.to_s)

        if item.add_special_requests.present?
          expect(page).to have_content("Add: #{item.add_special_requests.map(&:capitalize).join(",")}")
        end

        if item.remove_special_requests.present?
          expect(page).to have_content("Remove: #{item.remove_special_requests.map(&:capitalize).join(",")}")
        end
      end
    end

    it "removes items from list after clicking Complete order button on an item", turbo_stream: true do
      FactoryBot.create(:order_with_promotion_discount)
      visit "/orders"

      within "#orders_list" do
        first_order_id = first("div.order_item")["id"]

        within first("div.order_item") do
          click_button "Complete Order"
        end

        expect(page).not_to have_selector("#orders_list div.order_item##{first_order_id}", wait: 5)
      end
    end
  end
end
