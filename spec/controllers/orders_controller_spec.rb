# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe '.create' do
    context 'when placing a valid order' do
      let(:coffee) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity: 100) }
      let(:tea) { FactoryBot.create(:product, name: 'tea', category: 'drinks', default_price: 50, adjusted_price: 40, quantity: 50) }

      let(:params) do
        {
          products_array: [
            { product_id: coffee.id, quantity: 2, price: 80 },
            { product_id: tea.id, quantity: 3, price: 40 }
          ]
        }
      end

      before do
        post :create, params:
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the order details' do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response['total_price']).to eq(280)
        order_items = parsed_response['order_items'].map do |order_item|
          {
            'product_id' => order_item['product_id'],
            'quantity' => order_item['quantity'],
            'price' => order_item['price']
          }
        end

        expect(order_items).to contain_exactly(
          { 'product_id' => coffee.id, 'quantity' => 2, 'price' => 80 },
          { 'product_id' => tea.id, 'quantity' => 3, 'price' => 40 }
        )
      end
    end

    context 'when placing an order with an invalid product ID' do
      let(:params) { { products_array: [{ product_id: 123, quantity: 2, price: 80 }] } }

      it 'returns a not found status with an error message' do
        post(:create, params:)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to be_an(Array)
        expect(parsed_response['errors'].first['code']).to eq('not_found')
        expect(parsed_response['errors'].first['message']).to match(/Product with ID 123 not found/)
      end
    end

    context 'when placing an order with invalid parameters' do
      let(:params) { { products_array: 'invalid_string_instead_of_array' } }

      it 'returns a bad request status with an error message' do
        post(:create, params:)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to be_an(Array)
        expect(parsed_response['errors'].first['code']).to eq('invalid_argument')
        expect(parsed_response['errors'].first['message']).to match(/products_array must be an array of hashes/)
      end
    end

    context 'when placing an order with insufficient stock' do
      let(:coffee) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity: 100) }
      let(:params) { { products_array: [{ product_id: coffee.id, quantity: 200, price: 80 }] } }

      it 'returns a bad request status with an error message' do
        post(:create, params:)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to be_an(Array)
        expect(parsed_response['errors'].first['code']).to eq('insufficient_stock')
        expect(parsed_response['errors'].first['message']).to match(/Insufficient stock for product ID #{coffee.id}/)
      end
    end
  end
end
