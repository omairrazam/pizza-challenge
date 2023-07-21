require 'rails_helper'

RSpec.describe "Orders", type: :system do
  before do
    driven_by :selenium, using: :headless_chrome 
  end

  it 'create order and check if necessary data is displayed' do
    order = FactoryBot.create(:order)
    visit '/orders'

    expect(page).to have_content("ID: #{order.id}")
    expect(page).to have_content("Created: #{order.created_at.strftime("%Y-%m-%d %H:%M:%S")}")
    expect(page).to have_content("Total Price: #{order.calculate_total_price}")

    order.items.each do |item|
      expect(page).to have_content("#{item.name}")
      expect(page).to have_content("#{item.size}")

      if item.add_special_requests.present?
        expect(page).to have_content("Add: #{item.add_special_requests.map(&:capitalize).join(',')}")
      end

      if item.remove_special_requests.present?
        expect(page).to have_content("Remove: #{item.remove_special_requests.map(&:capitalize).join(',')}")
      end
    end
  end
end
