# frozen_string_literal: true

# db/migrate/<timestamp>_create_discounts.rb
# Replace 6.0 with your Rails version
class CreateDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :deduction_in_percent

      t.uuid :order_id, foreign_key: true
      t.timestamps
    end
  end
end
