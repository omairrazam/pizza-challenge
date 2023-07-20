# frozen_string_literal: true

class Promotion < ApplicationRecord
  belongs_to :order
  has_one :calculator, dependent: :destroy

  def calculate
    calculator.calculatable.calculate(order)
  end
end
