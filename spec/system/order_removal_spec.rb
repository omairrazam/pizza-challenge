# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Orders", type: :system do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  it 'clicks on "Complete Order" button and removes the specific order container', turbo_stream: true do
    FactoryBot.create(:order)
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
