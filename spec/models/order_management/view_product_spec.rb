# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderManagement::ViewProduct do
  describe '.call' do
    subject(:view_product) { described_class.call(product_id:) }

    let(:product) { FactoryBot.create(:product, adjusted_price: 80) }
    let(:product_id) { product.id }

    context 'when the product exists' do
      it 'returns the product details' do
        expect(view_product).to eq(
          {
            id: product.id,
            name: product.name,
            category: product.category,
            default_price: product.default_price,
            adjusted_price: product.adjusted_price
          }
        )
      end
    end

    context 'when the product does not exist' do
      let(:product_id) { 0 }

      it 'raises a ProductNotFoundError' do
        expect { view_product }.to raise_error(OrderManagement::ViewProduct::ProductNotFoundError, /Product with ID 0 not found/)
      end
    end
  end
end
