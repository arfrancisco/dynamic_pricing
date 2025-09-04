# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe '.show' do
    context 'when the product exists' do
      let(:product) { FactoryBot.create(:product, name: 'Test Product', category: 'Test Category', default_price: 100, adjusted_price: 80) }

      it 'returns the product details' do
        get :show, params: { product_id: product.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          {
            'id' => product.id.to_s,
            'name' => 'Test Product',
            'category' => 'Test Category',
            'default_price' => 100,
            'adjusted_price' => 80
          }
        )
      end
    end

    context 'when the product does not exist' do
      let(:product_id) { 0 }

      before do
        get :show, params: { product_id: }
      end

      it 'returns a 404 status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq(
          {
            'errors' => [
              {
                'code' => 'not_found',
                'message' => "Product with ID #{product_id} not found"
              }
            ]
          }
        )
      end
    end
  end
end
