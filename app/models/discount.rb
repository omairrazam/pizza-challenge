# frozen_string_literal: true

# app/models/discount.rb
class Discount < ApplicationRecord
  belongs_to :order
end
