# frozen_string_literal: true

# Replace 6.0 with your Rails version
class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :size
      t.uuid :order_id, foreign_key: true

      t.timestamps
    end
  end
end
