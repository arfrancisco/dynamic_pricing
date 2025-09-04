# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderManagement do
  describe '.customer_views_product' do
    it 'delegates to OrderManagement::ViewProduct' do
      expect(OrderManagement::ViewProduct).to receive(:call).with(product_id: 1)

      OrderManagement.customer_views_product(product_id: 1)
    end
  end
end
