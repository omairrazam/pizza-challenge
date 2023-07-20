# frozen_string_literal: true

class AddSpecialRequestsToItems < ActiveRecord::Migration[7.0]
  def change
    change_table(:items) do |t|
      t.text :add_special_requests, :remove_special_requests, default: [].to_yaml
    end
  end
end
