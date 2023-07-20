# frozen_string_literal: true

class CreateTwoForOnePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :two_for_one_promotions do |t|
      t.string :code
      t.string :target
      t.string :target_size
      t.integer :from
      t.integer :to
      t.uuid :order_id, foreign_key: true

      t.timestamps
    end
  end
end
