# frozen_string_literal: true

class Calculator < ApplicationRecord
  belongs_to :calculatable, polymorphic: true
  belongs_to :promotion
end
