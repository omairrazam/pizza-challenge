# frozen_string_literal: true

# db/migrate/<timestamp>_create_orders.rb
# Replace 6.0 with your Rails version
class CreateOrders < ActiveRecord::Migration[6.0]
  enable_extension "pgcrypto" unless extension_enabled?("pgcrypto") # <-- HERE

  def change
    create_table :orders, id: :uuid do |t|
      t.integer :state, default: 0 # 0 will be the default value for the enum

      t.timestamps
    end
  end
end
