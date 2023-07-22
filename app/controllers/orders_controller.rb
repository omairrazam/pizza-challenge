# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: :update

  def index
    @orders = open_orders
  end

  def update
    respond_to do |format|
      if @order.update(state: :closed)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("orders_list", partial: "orders/index",
                                                                   locals: { orders: open_orders },)
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@order, partial: "orders/order", locals: { order: @order })
        end
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def open_orders
    Order.includes(:promotions, :discounts).open
  end
end
