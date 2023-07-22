# frozen_string_literal: true

# Replace 6.0 with your Rails version
class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.uuid :order_id, foreign_key: true

      t.timestamps
    end
  end
end
