# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderManagement do
  describe '.customer_views_product' do
    it 'delegates to OrderManagement::ViewProduct' do
      expect(OrderManagement::ViewProduct).to receive(:call).with(product_id: 1)

      OrderManagement.customer_views_product(product_id: 1)
    end
  end

  describe '.customer_places_order' do
    it 'delegates to OrderManagement::PlaceOrder' do
      products_array = [{ product_id: 1, quantity: 2, price: 80 }]
      expect(OrderManagement::PlaceOrder).to receive(:call).with(products_array:)

      OrderManagement.customer_places_order(products_array:)
    end
  end
end
