# frozen_string_literal: true

class CreateCalculators < ActiveRecord::Migration[7.0]
  def change
    create_table :calculators do |t|
      t.integer :calculatable_id
      t.string  :calculatable_type

      t.references :promotion
      t.timestamps
    end
  end
end
